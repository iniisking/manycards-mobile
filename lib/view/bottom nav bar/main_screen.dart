import 'package:flutter/material.dart';
import 'package:manycards/view/bottom%20nav%20bar/bottom_nav_bar.dart';
import 'package:manycards/view/cards/ngn_card_screen.dart';
import 'package:manycards/view/home/home_screen.dart';
import 'package:manycards/view/settings/settings.dart';
import 'package:manycards/view/transaction%20history/transaction_history.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _isOnSubCardScreen = false;

  // Create navigation keys for each tab that needs navigation
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(), // Home
    GlobalKey<NavigatorState>(), // Card
    GlobalKey<NavigatorState>(), // Transaction History
    GlobalKey<NavigatorState>(), // Settings
  ];

  bool _shouldShowBottomNavBar() {
    return !_isOnSubCardScreen;
  }

  void _onItemTapped(int index) {
    // If tapping the current tab, try to navigate to the root route
    if (index == _selectedIndex) {
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
      // Reset subcard screen state when going back to root
      if (index == 1) {
        setState(() {
          _isOnSubCardScreen = false;
        });
      }
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            // Content area
            IndexedStack(
              index: _selectedIndex,
              children: [
                _buildOffstageNavigator(0),
                _buildOffstageNavigator(1),
                _buildOffstageNavigator(2),
                _buildOffstageNavigator(3),
              ],
            ),
            // Floating navigation bar overlay
            if (_shouldShowBottomNavBar())
              BottomNavBar(
                selectedIndex: _selectedIndex,
                onItemTapped: _onItemTapped,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(int index) {
    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (RouteSettings settings) {
          // Update state when route changes in the card tab
          if (index == 1) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _isOnSubCardScreen = settings.name == '/subcard';
                });
              }
            });
          }
          return MaterialPageRoute(
            settings: settings,
            builder: (context) {
              switch (index) {
                case 0:
                  return const HomeScreen();
                case 1:
                  return const NgnCardScreen();
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
