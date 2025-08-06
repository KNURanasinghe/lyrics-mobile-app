import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lyrics/FireBase/auth_service.dart';
import 'package:lyrics/Models/user_model.dart';
import 'package:lyrics/Screens/AuthScreens/signup_page.dart';
import 'package:lyrics/Screens/HomeScreen/home_screen.dart';
import 'package:lyrics/Service/user_service.dart';
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
  final userService = UserService();
  bool isLoading = false;
  String? errorMessage;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Future<void> signInWithEmailAndPassword() async {
    try {
      await FireBaseAuthServices().signInWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> signIn() async {
    // Validate all fields are filled
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        errorMessage = 'Please fill in all fields';
      });
      return;
    }

    // Validate terms agreed
    // if (!_isAgreed) {
    //   setState(() {
    //     errorMessage = 'Please agree to the Privacy Policy';
    //   });
    //   return;
    // }

    // Basic email validation
    if (!_emailController.text.contains('@')) {
      setState(() {
        errorMessage = 'Please enter a valid email';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final result = await userService.login(
        emailOrPhone: _emailController.text,
        password: _passwordController.text,
      );
      print('Login result: ${result['user']}');
      if (result['success'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        print('Signup failed: ${result['message']}');
        setState(() {
          errorMessage = result['message'] ?? 'Signup failed';
        });
      }
    } catch (e) {
      print('Signup failed: $e');
      setState(() {
        errorMessage = 'An error occurred: ${e.toString()}';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

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
                    controller: _emailController,
                    hintText: 'Email or Phone Number',
                    icon: Icons.email,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  AuthTextfeildContainer(
                    controller: _passwordController,
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
                  AuthButton(text: 'Login', onTap: signIn),
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
