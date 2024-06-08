import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waterspring/pages/login.dart';
import 'package:waterspring/pages/mainpage.dart';
import 'package:waterspring/pages/registerpage.dart';
import 'package:waterspring/pages/splashscreen.dart';
import 'package:waterspring/pages/welcomescreen.dart';
import 'package:waterspring/providers/pageprovider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PageProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        //home: const SplashScreen(),
        routes: {
          '/': (context) => const SplashScreen(),
          '/welcome': (context) => const WelcomeScreen(),
          '/register': (context) => const RegisterScreen(),
          '/login': (context) => const LoginScreen(),
          '/main': (context) => const MainScreen()
        },
      ),
    );
  }
}
