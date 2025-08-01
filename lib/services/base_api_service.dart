// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:manycards/services/auth_service.dart';

abstract class BaseApiService {
  final http.Client client;
  final AuthService? _authService;

  BaseApiService({required this.client, AuthService? authService})
    : _authService = authService;

  static String get _region => dotenv.env['AWS_REGION'] ?? 'us-east-1';
  static String get _service => dotenv.env['AWS_SERVICE'] ?? 'execute-api';

  // AWS credentials
  final String _accessKey = dotenv.env['AWS_ACCESS_KEY_ID'] ?? '';
  final String _secretKey = dotenv.env['AWS_SECRET_ACCESS_KEY'] ?? '';

  final bool _debugMode = dotenv.env['DEBUG_MODE'] == 'true';

  void _logDebug(String message) {
    if (_debugMode) {
      print('API DEBUG: $message');
    }
  }

  String _getCanonicalRequest(
    String method,
    String path,
    Map<String, String> headers,
    String payload, {
    Map<String, String>? queryParameters,
  }) {
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

    // Build canonical query string
    String canonicalQueryString = '';
    if (queryParameters != null && queryParameters.isNotEmpty) {
      final sortedQueryParams = queryParameters.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));
      canonicalQueryString = sortedQueryParams
          .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final canonicalRequest = [
      method,
      path,
      canonicalQueryString,
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
    String payload, {
    Map<String, String>? queryParameters,
  }) {
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
      queryParameters: queryParameters,
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
      'User-Agent': dotenv.env['USER_AGENT'] ?? 'ManyCards/1.0',
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
    bool useAwsSignature = false,
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
          _logDebug('Token length: ${cognitoToken.length}');
          _logDebug('Token starts with: ${cognitoToken.substring(0, 20)}...');
        } else {
          _logDebug(
            'Warning: No Cognito token available for authenticated request',
          );
        }
      }

      if (useAwsSignature) {
        // Add AWS signature
        final signedHeaders = _getSignedHeaders(
          'POST',
          Uri.parse(url).path,
          requestHeaders,
          payload,
        );
        // Replace Authorization header with AWS signature
        requestHeaders['Authorization'] = signedHeaders['Authorization']!;
        requestHeaders['X-Amz-Date'] = signedHeaders['X-Amz-Date']!;
        requestHeaders['Content-Type'] = signedHeaders['Content-Type']!;
      }
    }

    _logDebug('HEADERS: $requestHeaders');

    try {
      final response = await client
          .post(Uri.parse(url), headers: requestHeaders, body: payload)
          .timeout(Duration(seconds: int.parse(dotenv.env['API_TIMEOUT_SECONDS'] ?? '15')));

      _logDebug('RESPONSE STATUS: ${response.statusCode}');
      _logDebug('RESPONSE HEADERS: ${response.headers}');
      _logDebug('RESPONSE BODY: ${response.body}');

      return handleApiResponse(response);
    } catch (e) {
      _logDebug('Unexpected error: $e');
      // Don't wrap the exception again, just rethrow it
      rethrow;
    }
  }

  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
    bool useAwsSignature = false,
    String? directToken,
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
      if (directToken != null) {
        cognitoToken = directToken;
        _logDebug('Using direct token: ${cognitoToken.substring(0, 20)}...');
      } else if (_authService != null) {
        cognitoToken = await _authService.getAuthToken();
        if (cognitoToken != null) {
          _logDebug('Added Authorization header with token: $cognitoToken');
          _logDebug('Token length: ${cognitoToken.length}');
          _logDebug('Token starts with: ${cognitoToken.substring(0, 20)}...');
        } else {
          _logDebug(
            'Warning: No Cognito token available for authenticated request',
          );
        }
      }
      
      if (cognitoToken != null) {
        requestHeaders['Authorization'] = 'Bearer $cognitoToken';
      }

      if (useAwsSignature) {
        // Add AWS signature
        final signedHeaders = _getSignedHeaders(
          'GET',
          path,
          requestHeaders,
          payload,
          queryParameters: stringQueryParams,
        );
        // Replace Authorization header with AWS signature
        requestHeaders['Authorization'] = signedHeaders['Authorization']!;
        requestHeaders['X-Amz-Date'] = signedHeaders['X-Amz-Date']!;
        requestHeaders['Content-Type'] = signedHeaders['Content-Type']!;
      }
    }

    _logDebug('HEADERS: $requestHeaders');

    try {
      final response = await client
          .get(uri, headers: requestHeaders)
          .timeout(Duration(seconds: int.parse(dotenv.env['API_TIMEOUT_SECONDS'] ?? '15')));

      _logDebug('RESPONSE STATUS: ${response.statusCode}');
      _logDebug('RESPONSE HEADERS: ${response.headers}');
      _logDebug('RESPONSE BODY: ${response.body}');

      return handleApiResponse(response);
    } catch (e) {
      _logDebug('Unexpected error: $e');
      // Don't wrap the exception again, just rethrow it
      rethrow;
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
          final errorMessage = _extractErrorMessage(decodedResponse);
          throw Exception(errorMessage);
        case 401:
        case 403:
          final errorMessage = _extractErrorMessage(decodedResponse);
          throw Exception(errorMessage);
        case 500:
          final errorMessage = _extractErrorMessage(decodedResponse);
          throw Exception(errorMessage);
        default:
          final errorMessage = _extractErrorMessage(decodedResponse);
          throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Invalid response format: ${response.body}');
      }
      rethrow;
    }
  }

  String _extractErrorMessage(dynamic response) {
    if (response is Map<String, dynamic>) {
      // Try to extract message from common error response formats
      if (response.containsKey('message')) {
        return response['message'] as String;
      }
      if (response.containsKey('error')) {
        final error = response['error'];
        if (error is String) {
          return error;
        }
        if (error is Map<String, dynamic> && error.containsKey('message')) {
          return error['message'] as String;
        }
      }
      if (response.containsKey('detail')) {
        return response['detail'] as String;
      }
      if (response.containsKey('error_message')) {
        return response['error_message'] as String;
      }
      // If no specific error message found, return a generic message
      return 'An error occurred. Please try again.';
    }
    return 'An error occurred. Please try again.';
  }
}
