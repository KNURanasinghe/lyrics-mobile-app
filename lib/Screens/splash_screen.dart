import 'package:flutter/material.dart';
import 'package:lyrics/Screens/AuthScreens/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      // Navigate to the next screen after the splash screen
      // For example, you can use Navigator.pushReplacementNamed(context, '/home');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(children: [Image.asset('assets/splash.png')]));
  }
}
