// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:manycards/services/auth_service.dart';

abstract class BaseApiService {
  final http.Client client;
  final AuthService? _authService;

  BaseApiService({required this.client, AuthService? authService})
    : _authService = authService;

  static const String _region = 'us-east-1';
  static const String _service = 'execute-api';

  // AWS credentials
  final String _accessKey = 'AKIA24VI23NWMJG7HVS6';
  final String _secretKey = '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';

  final bool _debugMode = true;

  void _logDebug(String message) {
    if (_debugMode) {
      print('API DEBUG: $message');
    }
  }

  String _getCanonicalRequest(
    String method,
    String path,
    Map<String, String> headers,
    String payload,
  ) {
    final canonicalHeaders = Map<String, String>.fromEntries(
      headers.entries.map((e) => MapEntry(e.key.toLowerCase(), e.value.trim())),
    );

    final sortedHeaders =
        canonicalHeaders.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key));

    final canonicalHeadersStr = sortedHeaders
        .map((e) => '${e.key}:${e.value}\n')
        .join('');

    final signedHeaders = sortedHeaders.map((e) => e.key).join(';');
    final payloadHash = sha256.convert(utf8.encode(payload)).toString();

    final canonicalRequest = [
      method,
      path,
      '', // canonical query string (empty)
      canonicalHeadersStr,
      signedHeaders,
      payloadHash,
    ].join('\n');

    _logDebug('Canonical Request:\n$canonicalRequest');
    return canonicalRequest;
  }

  String _getStringToSign(String canonicalRequest, String timestamp) {
    final dateStamp = timestamp.substring(0, 8);
    final scope = [dateStamp, _region, _service, 'aws4_request'].join('/');
    final canonicalRequestHash =
        sha256.convert(utf8.encode(canonicalRequest)).toString();

    final stringToSign = [
      'AWS4-HMAC-SHA256',
      timestamp,
      scope,
      canonicalRequestHash,
    ].join('\n');

    _logDebug('String to Sign:\n$stringToSign');
    return stringToSign;
  }

  List<int> _getSigningKey(
    String secretKey,
    String dateStamp,
    String region,
    String service,
  ) {
    var kDate =
        Hmac(
          sha256,
          'AWS4$secretKey'.codeUnits,
        ).convert(utf8.encode(dateStamp)).bytes;
    var kRegion = Hmac(sha256, kDate).convert(utf8.encode(region)).bytes;
    var kService = Hmac(sha256, kRegion).convert(utf8.encode(service)).bytes;
    return Hmac(sha256, kService).convert(utf8.encode('aws4_request')).bytes;
  }

  Map<String, String> _getSignedHeaders(
    String method,
    String path,
    Map<String, String> headers,
    String payload,
  ) {
    final timestamp = DateFormat(
      "yyyyMMdd'T'HHmmss'Z'",
    ).format(DateTime.now().toUtc());
    final dateStamp = timestamp.substring(0, 8);

    final requestHeaders = Map<String, String>.from(headers);
    requestHeaders['x-amz-date'] = timestamp;
    requestHeaders['content-type'] = 'application/json; charset=utf-8';

    final canonicalRequest = _getCanonicalRequest(
      method,
      path,
      requestHeaders,
      payload,
    );

    final stringToSign = _getStringToSign(canonicalRequest, timestamp);
    final signingKey = _getSigningKey(_secretKey, dateStamp, _region, _service);

    final signature =
        Hmac(sha256, signingKey)
            .convert(utf8.encode(stringToSign))
            .bytes
            .map((b) => b.toRadixString(16).padLeft(2, '0'))
            .join();

    final scope = [dateStamp, _region, _service, 'aws4_request'].join('/');
    final signedHeaders =
        requestHeaders.keys.map((k) => k.toLowerCase()).toList()..sort();
    final signedHeadersStr = signedHeaders.join(';');

    final authorization = [
      'AWS4-HMAC-SHA256',
      'Credential=$_accessKey/$scope',
      'SignedHeaders=$signedHeadersStr',
      'Signature=$signature',
    ].join(', ');

    return {
      'Authorization': authorization,
      'X-Amz-Date': timestamp,
      'Content-Type': 'application/json; charset=utf-8',
    };
  }

  Map<String, String> getHeaders({bool requiresAuth = true}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth && _authService != null) {
      final token = _authService.getAuthToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool requiresAuth = true,
  }) async {
    final url = endpoint;
    _logDebug('POST REQUEST to $url');

    Map<String, String> requestHeaders = {
      'Host': Uri.parse(url).host,
      ...?headers,
    };
    final payload = body != null ? json.encode(body) : '';

    if (requiresAuth) {
      // Add Cognito token if available
      String? cognitoToken;
      if (_authService != null) {
        cognitoToken = await _authService.getAuthToken();
        if (cognitoToken != null) {
          requestHeaders['Authorization'] = 'Bearer $cognitoToken';
          _logDebug('Added Authorization header with token: $cognitoToken');
        } else {
          _logDebug(
            'Warning: No Cognito token available for authenticated request',
          );
        }
      }

      // Add AWS signature
      final signedHeaders = _getSignedHeaders(
        'POST',
        Uri.parse(url).path,
        requestHeaders,
        payload,
      );
      // Use x-aws-signature header instead of Authorization
      requestHeaders['x-aws-signature'] = signedHeaders['Authorization']!;
    }

    _logDebug('HEADERS: $requestHeaders');

    try {
      final response = await client
          .post(Uri.parse(url), headers: requestHeaders, body: payload)
          .timeout(Duration(seconds: 15));

      _logDebug('RESPONSE STATUS: ${response.statusCode}');
      _logDebug('RESPONSE HEADERS: ${response.headers}');
      _logDebug('RESPONSE BODY: ${response.body}');

      return handleApiResponse(response);
    } catch (e) {
      _logDebug('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    final url = endpoint;
    _logDebug('GET REQUEST to $url');

    // Convert query parameters to strings
    final Map<String, String> stringQueryParams = {};
    if (queryParameters != null) {
      queryParameters.forEach((key, value) {
        stringQueryParams[key] = value.toString();
      });
    }

    final uri = Uri.parse(url).replace(queryParameters: stringQueryParams);
    final path = uri.path;

    Map<String, String> requestHeaders = {'Host': uri.host, ...?headers};
    final payload = ''; // GET requests don't have a body

    if (requiresAuth) {
      // Add Cognito token if available
      String? cognitoToken;
      if (_authService != null) {
        cognitoToken = await _authService.getAuthToken();
        if (cognitoToken != null) {
          requestHeaders['Authorization'] = 'Bearer $cognitoToken';
          _logDebug('Added Authorization header with token: $cognitoToken');
        } else {
          _logDebug(
            'Warning: No Cognito token available for authenticated request',
          );
        }
      }

      // Add AWS signature
      final signedHeaders = _getSignedHeaders(
        'GET',
        path,
        requestHeaders,
        payload,
      );
      // Use x-aws-signature header instead of Authorization
      requestHeaders['x-aws-signature'] = signedHeaders['Authorization']!;
    }

    _logDebug('HEADERS: $requestHeaders');

    try {
      final response = await client
          .get(uri, headers: requestHeaders)
          .timeout(Duration(seconds: 15));

      _logDebug('RESPONSE STATUS: ${response.statusCode}');
      _logDebug('RESPONSE HEADERS: ${response.headers}');
      _logDebug('RESPONSE BODY: ${response.body}');

      return handleApiResponse(response);
    } catch (e) {
      _logDebug('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  dynamic handleApiResponse(http.Response response) {
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    try {
      final dynamic decodedResponse = jsonDecode(response.body);

      switch (response.statusCode) {
        case 200:
          return decodedResponse;
        case 400:
          throw Exception('Bad request: ${response.body}');
        case 401:
        case 403:
          throw Exception('Authentication failed: ${response.body}');
        case 500:
          throw Exception('Server error: ${response.body}');
        default:
          throw Exception(
            'Request failed with status: ${response.statusCode}, body: ${response.body}',
          );
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Invalid response format: ${response.body}');
      }
      rethrow;
    }
  }
}
