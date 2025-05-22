import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:manycards/controller/currency_controller.dart';
import 'package:manycards/controller/auth_controller.dart';
import 'package:manycards/services/auth_service.dart';
import 'package:manycards/services/storage_service.dart';
import 'package:manycards/view/authentication/auth_wrapper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CurrencyController()),
        Provider<StorageService>(create: (_) => StorageService()),
        Provider<AuthService>(
          create:
              (context) => AuthService(
                client: http.Client(),
                storageService: context.read<StorageService>(),
              ),
        ),
        ChangeNotifierProxyProvider<AuthService, AuthController>(
          create: (context) => AuthController(context.read<AuthService>()),
          update:
              (_, authService, controller) =>
                  controller ?? AuthController(authService),
        ),
      ],
      child: ScreenUtilInit(
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
