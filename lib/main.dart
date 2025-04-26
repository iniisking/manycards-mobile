import 'package:flutter/material.dart';
import 'package:manycards/view/authentication/sign_up_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:manycards/controller/currency_controller.dart'; // Import your controller

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => CurrencyController()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Many Cards',
            home: child, // Use the child parameter here
          ),
        );
      },
      child: const SignUpScreen(), // Pass HomeScreen as child
    );
  }
}
