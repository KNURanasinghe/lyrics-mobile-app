import 'package:flutter/material.dart';
import 'package:lyrics/Screens/AuthScreens/signup_page.dart';
import 'package:lyrics/Screens/HomeScreen/home_screen.dart';
import 'package:lyrics/widgets/auth_button.dart';
import 'package:lyrics/widgets/auth_textfeild_container.dart';
import 'package:lyrics/widgets/auth_via_buttons.dart';
import 'package:lyrics/widgets/main_background.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: MainBAckgound(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 40.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.13),
                  // Add your login form widgets here
                  Text(
                    'Hello,\nWelcome Back!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    'Sign in to continue experience',
                    style: TextStyle(
                      color: Color(0xFF909090),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  AuthTextfeildContainer(
                    hintText: 'Email or Phone Number',
                    icon: Icons.email,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  AuthTextfeildContainer(
                    hintText: 'Password',
                    icon: Icons.lock,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20, top: 10),
                      child: GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Color(0xFFBBBBBB),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                  // Example of a button
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                    child: AuthButton(text: 'Login'),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Center(
                    child: Text(
                      'or continue with',
                      style: TextStyle(
                        color: Color(0xFFBBBBBB),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AuthViaButtons(name: 'Google', path: 'assets/Google.png'),
                      AuthViaButtons(
                        name: 'Apple',
                        path: 'assets/AppleInc.png',
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: TextStyle(
                          color: Color(0xFF9E9E9E),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
