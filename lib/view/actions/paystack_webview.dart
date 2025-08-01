// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:manycards/controller/payment_controller.dart';
import 'package:manycards/controller/currency_controller.dart';

class PaystackWebView extends StatefulWidget {
  final String url;
  final String reference;
  final String cardId;

  const PaystackWebView({
    super.key,
    required this.url,
    required this.reference,
    required this.cardId,
  });

  @override
  State<PaystackWebView> createState() => _PaystackWebViewState();
}

class _PaystackWebViewState extends State<PaystackWebView> {
  late final WebViewController controller;
  bool isLoading = true;
  bool isVerifying = false;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(Colors.black)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (String url) {
                debugPrint('Page started loading: $url');
                setState(() {
                  isLoading = true;
                });
              },
              onPageFinished: (String url) async {
                debugPrint('Page finished loading: $url');
                setState(() {
                  isLoading = false;
                });

                // Inject JavaScript to detect payment status
                await controller.runJavaScript('''
                  (function() {
                    function checkSuccess() {
                      try {
                        // Get all text content
                        const bodyText = document.body.innerText.toLowerCase();
                        const titleText = document.title.toLowerCase();
                        
                        // Check for success indicators in text
                        const successIndicators = [
                          'successful',
                          'payment successful',
                          'transaction successful',
                          'payment completed',
                          'transaction completed',
                          'payment verified',
                          'transaction verified',
                          'success',
                          'completed',
                          'verified',
                          'thank you'
                        ];
                        
                        // Check text content for success indicators
                        for (const indicator of successIndicators) {
                          if (bodyText.includes(indicator) || titleText.includes(indicator)) {
                            console.log('Found success indicator:', indicator);
                            return true;
                          }
                        }
                        
                        // Check for success elements
                        const successElements = document.querySelectorAll(
                          '[class*="success"], [id*="success"], [class*="Success"], [id*="Success"], ' +
                          '[class*="successful"], [id*="successful"], [class*="Successfully"], [id*="Successfully"], ' +
                          '[class*="completed"], [id*="completed"], [class*="Completed"], [id*="Completed"], ' +
                          '[class*="verified"], [id*="verified"], [class*="Verified"], [id*="Verified"]'
                        );
                        
                        if (successElements.length > 0) {
                          console.log('Found success elements:', successElements.length);
                          return true;
                        }
                        
                        return false;
                      } catch (error) {
                        console.error('Error in checkSuccess:', error);
                        return false;
                      }
                    }
                    
                    // Initial check
                    if (checkSuccess()) {
                      window.location.href = 'paystack://success';
                    }
                    
                    // Set up a mutation observer to watch for changes
                    const observer = new MutationObserver(function(mutations) {
                      if (checkSuccess()) {
                        console.log('Success detected after DOM change');
                        window.location.href = 'paystack://success';
                      }
                    });
                    
                    // Start observing
                    observer.observe(document.body, {
                      childList: true,
                      subtree: true,
                      characterData: true
                    });
                  })();
                ''');
              },
              onNavigationRequest: (NavigationRequest request) {
                debugPrint('Navigation request: ${request.url}');
                // Check if the URL contains success or cancel
                if (request.url.contains('paystack://success') ||
                    request.url.contains('success') ||
                    request.url.contains('status=success') ||
                    request.url.contains('thank-you') ||
                    request.url.contains('completed')) {
                  _handleSuccess();
                  return NavigationDecision.prevent;
                } else if (request.url.contains('cancel')) {
                  Navigator.pop(context, false);
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
              onWebResourceError: (WebResourceError error) {
                debugPrint('WebView error: ${error.description}');
              },
            ),
          );

    // Load the URL after a short delay to ensure the controller is ready
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        debugPrint('Loading URL: ${widget.url}');
        controller.loadRequest(Uri.parse(widget.url));
      }
    });
  }

  Future<void> _handleSuccess() async {
    debugPrint('_handleSuccess called. isVerifying: $isVerifying');
    if (isVerifying) return; // Prevent multiple verifications

    setState(() {
      isVerifying = true;
      debugPrint('isVerifying set to true');
    });

    try {
      final paymentController = context.read<PaymentController>();
      final success = await paymentController.verifyTransaction(
        reference: widget.reference,
        cardId: widget.cardId,
      );

      if (success && mounted) {
        // Refresh the currency balances
        final currencyController = context.read<CurrencyController>();
        await currencyController.refreshBalances();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment successful! Your balance has been updated.'),
            backgroundColor: Colors.green,
          ),
        );

        // Close both the webview and the top up screen
        if (mounted) {
          // Pop twice to close both the webview and top-up screen
          Navigator.of(context).pop(); // Close webview
          Navigator.of(context).pop(); // Close top-up screen
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              paymentController.error ?? 'Transaction verification failed',
            ),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context, false);
      }
    } catch (e) {
      debugPrint('Error verifying transaction: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error verifying payment: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context, false);
      }
    } finally {
      if (mounted) {
        setState(() {
          isVerifying = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show confirmation dialog before closing
        final shouldPop = await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                backgroundColor: const Color(0xFF1E1E1E),
                title: const Text(
                  'Cancel Payment?',
                  style: TextStyle(color: Colors.white),
                ),
                content: const Text(
                  'Are you sure you want to cancel this payment?',
                  style: TextStyle(color: Colors.white),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text(
                      'No',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text(
                      'Yes',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
        );
        return shouldPop ?? false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () async {
              final shouldPop = await showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      backgroundColor: const Color(0xFF1E1E1E),
                      title: const Text(
                        'Cancel Payment?',
                        style: TextStyle(color: Colors.white),
                      ),
                      content: const Text(
                        'Are you sure you want to cancel this payment?',
                        style: TextStyle(color: Colors.white),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text(
                            'No',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            'Yes',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
              );
              if (shouldPop ?? false) {
                if (mounted) {
                  Navigator.pop(context, false);
                }
              }
            },
          ),
          title: const Text(
            'Complete Payment',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: controller),
            if (isLoading || isVerifying)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    if (isVerifying) ...[
                      const SizedBox(height: 16),
                      const Text(
                        'Verifying payment...',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
