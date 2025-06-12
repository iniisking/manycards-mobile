import 'package:flutter/material.dart';
import 'package:manycards/controller/navigation_controller.dart';
import 'package:manycards/view/bottom%20nav%20bar/bottom_nav_bar.dart';
import 'package:manycards/view/cards/card_screen.dart';
import 'package:manycards/view/home/home_screen.dart';
import 'package:manycards/view/settings/settings.dart';
import 'package:manycards/view/transaction%20history/transaction_history.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Create navigation keys for each tab that needs navigation
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(), // Home
    GlobalKey<NavigatorState>(), // Card
    GlobalKey<NavigatorState>(), // Transaction History
    GlobalKey<NavigatorState>(), // Settings
  ];

  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
      context.read<NavigationController>().resetToDefault();
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationController>(
      builder: (context, navigationController, child) {
        return WillPopScope(
          onWillPop: () async {
            final isFirstRouteInCurrentTab =
                !await _navigatorKeys[_selectedIndex].currentState!.maybePop();
            if (isFirstRouteInCurrentTab) {
              return true;
            }
            return false;
          },
          child: Scaffold(
            extendBody: true,
            body: Stack(
              children: [
                IndexedStack(
                  index: _selectedIndex,
                  children: [
                    _buildOffstageNavigator(0),
                    _buildOffstageNavigator(1),
                    _buildOffstageNavigator(2),
                    _buildOffstageNavigator(3),
                  ],
                ),
                if (navigationController.isBottomNavBarVisible)
                  BottomNavBar(
                    selectedIndex: _selectedIndex,
                    onItemTapped: _onItemTapped,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOffstageNavigator(int index) {
    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        observers: [
          _NavigationObserver(
            onRouteChanged: (route, previousRoute) {
              if (!mounted) return;

              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;

                final navigationController =
                    context.read<NavigationController>();

                if (route != null) {
                  // Handle new route
                  final routeName = route.settings.name;
                  debugPrint('NavigationObserver: New route: $routeName');
                  navigationController.handleRouteChange(routeName);
                } else if (previousRoute != null) {
                  // Handle back navigation
                  final previousRouteName = previousRoute.settings.name;
                  debugPrint(
                    'NavigationObserver: Back navigation from: $previousRouteName',
                  );
                  navigationController.handleBackNavigation(previousRouteName);
                }
              });
            },
          ),
        ],
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            settings: settings,
            builder: (context) {
              switch (index) {
                case 0:
                  return const HomeScreen();
                case 1:
                  return const CardScreen();
                case 2:
                  return const TransactionHistory();
                case 3:
                  return const Settings();
                default:
                  return const HomeScreen();
              }
            },
          );
        },
      ),
    );
  }
}

class _NavigationObserver extends NavigatorObserver {
  final void Function(Route<dynamic>?, Route<dynamic>?) onRouteChanged;

  _NavigationObserver({required this.onRouteChanged});

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    onRouteChanged(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    onRouteChanged(previousRoute, route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    onRouteChanged(newRoute, oldRoute);
  }
}
