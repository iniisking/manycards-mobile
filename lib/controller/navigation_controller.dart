// ignore_for_file: unused_field

import 'package:flutter/material.dart';

class NavigationController extends ChangeNotifier {
  bool _isBottomNavBarVisible = true;
  final List<String> _screensWithoutNavBar = [
    'subcard',
    '/subcard',
    'topup',
    '/topup',
    'modal',
    '/modal',
    'transfer',
    '/transfer',
  ];

  // Track the previous route to handle back navigation properly
  String? _previousRoute;

  bool get isBottomNavBarVisible => _isBottomNavBarVisible;

  void handleRouteChange(String? routeName) {
    if (routeName == null) return;

    debugPrint('NavigationController: Handling route change to $routeName');
    // Store the current route as previous before updating
    _previousRoute = routeName;

    final shouldHide = _screensWithoutNavBar.contains(routeName);
    debugPrint('NavigationController: Should hide nav bar: $shouldHide');

    if (_isBottomNavBarVisible == shouldHide) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _isBottomNavBarVisible = !shouldHide;
        notifyListeners();
      });
    }
  }

  void showBottomNavBar() {
    debugPrint('NavigationController: Showing bottom nav bar');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isBottomNavBarVisible) {
        _isBottomNavBarVisible = true;
        notifyListeners();
      }
    });
  }

  void hideBottomNavBar() {
    debugPrint('NavigationController: Hiding bottom nav bar');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isBottomNavBarVisible) {
        _isBottomNavBarVisible = false;
        notifyListeners();
      }
    });
  }

  void resetToDefault() {
    debugPrint('NavigationController: Resetting to default');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isBottomNavBarVisible) {
        _isBottomNavBarVisible = true;
        notifyListeners();
      }
    });
  }

  void handleBackNavigation(String? currentRoute) {
    if (currentRoute == null) return;

    debugPrint(
      'NavigationController: Handling back navigation from $currentRoute',
    );
    // If we're navigating back from a screen that should hide the nav bar
    if (_screensWithoutNavBar.contains(currentRoute)) {
      showBottomNavBar();
    }
  }
}
