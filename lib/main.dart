import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waterspring/pages/login.dart';
import 'package:waterspring/pages/mainpage.dart';
import 'package:waterspring/pages/registerpage.dart';
import 'package:waterspring/pages/welcomescreen.dart';
import 'package:waterspring/providers/pageprovider.dart';
// import 'package:waterspring/pages/stepper.dart';

// C:\Users\ASUS\AppData\Local\Android\Sdk\platform-tools
// adb connect localhost:5555
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PageProvider(),
        ),
      ],
      child: MaterialApp(
        // theme: ThemeData(useMaterial3: true),
        debugShowCheckedModeBanner: false,
        //home: const SplashScreen(),
        routes: {
          '/': (context) => const MainScreen(),
          '/welcome': (context) => const WelcomeScreen(),
          '/register': (context) => const RegisterScreen(),
          '/login': (context) => const LoginScreen(),
          '/main': (context) => const MainScreen()
        },
      ),
    );
  }
}
