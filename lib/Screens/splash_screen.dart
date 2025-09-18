import 'package:flutter/material.dart';
import 'package:lyrics/Screens/AuthScreens/login_page.dart';
import 'package:lyrics/Screens/HomeScreen/home_screen.dart';
import 'package:lyrics/Service/user_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    getProfile();
    Future.delayed(const Duration(seconds: 3), () async {
      // Navigate to the next screen after the splash screen
      // For example, you can use Navigator.pushReplacementNamed(context, '/home');

      final page = await UserService.getUserID();
      print('pageeeee $page');
      if (page != '') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });
  }

  Future<void> getProfile() async {
    final UserService userService = UserService();
    final page = await UserService.getUserID();
    try {
      final response = await userService.getFullProfile(page);
      print('response from splash $response');
      if (response['success']) {
        await UserService.saveIsPremium(response['profile']['isPremium']);
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/1202.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
            ),
            // const SizedBox(height: 20),
            // const Text(
            //   'Welcome to Lyrics App',
            //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(height: 10),
            // const Text(
            //   'Your favorite lyrics at your fingertips',
            //   style: TextStyle(fontSize: 16, color: Colors.grey),
            // ),
          ],
        ),
      ),
    );
  }
}
