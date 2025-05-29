import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:manycards/controller/currency_controller.dart';
import 'package:manycards/controller/auth_controller.dart';
import 'package:manycards/controller/card_controller.dart';
import 'package:manycards/services/auth_service.dart';
import 'package:manycards/services/storage_service.dart';
import 'package:manycards/view/authentication/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<StorageService>(create: (_) => StorageService()),
        Provider<AuthService>(
          create:
              (context) => AuthService(
                client: http.Client(),
                storageService: context.read<StorageService>(),
              ),
        ),
        ChangeNotifierProxyProvider<AuthService, AuthController>(
          create:
              (context) =>
                  AuthController(context.read<AuthService>(), prefs: prefs),
          update:
              (_, authService, controller) =>
                  controller ?? AuthController(authService, prefs: prefs),
        ),
        ChangeNotifierProvider(
          create:
              (context) => CurrencyController(
                context.read<AuthController>(),
                http.Client(),
              ),
        ),
        ChangeNotifierProvider(create: (_) => CardController()),
      ],
      child: ScreenUtilInit(
        ensureScreenSize: true,
        useInheritedMediaQuery: true,
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'ManyCards',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: const Color(0xFF121212),
            ),
            home: const AuthWrapper(),
          );
        },
      ),
    );
  }
}
