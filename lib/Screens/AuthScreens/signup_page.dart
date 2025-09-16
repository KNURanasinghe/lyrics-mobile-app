import 'package:flutter/material.dart';
import 'package:lyrics/FireBase/auth_service.dart';
import 'package:lyrics/Models/user_model.dart';
import 'package:lyrics/Screens/AuthScreens/login_page.dart';
import 'package:lyrics/Screens/HomeScreen/home_screen.dart';
import 'package:lyrics/Service/user_service.dart';
import 'package:lyrics/widgets/auth_button.dart';
import 'package:lyrics/widgets/auth_textfeild_container.dart';
import 'package:lyrics/widgets/auth_via_big_button.dart';
import 'package:lyrics/widgets/main_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final userService = UserService();
  bool _isAgreed = false;
  String? errorMessage = '';
  bool isLoading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  Future<void> googleSignUp() async {
    print('Google sign up initiated');
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      print('Calling signInWithGoogle');
      final result = await FireBaseAuthServices().signUpWithGoogle();
      print('Google sign in result: $result');

      print('User signed in successfully: ');
      if (result == true) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => HomePage()),
          (route) => false, // This removes all previous routes
        );
      }
    } on FirebaseAuthException catch (e) {
      print('Google sign in error: ${e.message}');
      if (mounted) {
        setState(() {
          errorMessage = e.message ?? 'An unknown error occurred';
        });
      }
    } catch (e) {
      print('Unexpected error during Google sign in: $e');
      if (mounted) {
        setState(() {
          errorMessage = 'An unexpected error occurred';
        });
      }
    } finally {
      print('Google sign in process completed');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> signUp() async {
    // Validate all fields are filled
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      setState(() {
        errorMessage = 'Please fill in all fields';
      });
      return;
    }

    // Validate password match
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        errorMessage = 'Passwords do not match';
      });
      return;
    }

    // Validate terms agreed
    if (!_isAgreed) {
      setState(() {
        errorMessage = 'Please agree to the Privacy Policy';
      });
      return;
    }

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
      final newUser = UserModel(
        fullname: _nameController.text,
        email: _emailController.text,
        phonenumber: _phoneController.text,
        password: _passwordController.text,
      );

      final result = await userService.signUp(newUser);
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
                  Text(
                    'Create\nAccount',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Join Us for Premium Experience',
                    style: TextStyle(
                      color: Color(0xFF909090),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  AuthViaBigButton(
                    name: 'Continue with Google',
                    path: 'assets/Google.png',
                    ontap: googleSignUp,
                    isLoading: isLoading,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  AuthViaBigButton(
                    name: 'Continue with Apple',
                    path: 'assets/AppleInc.png',
                    ontap: () {},
                    isLoading: false,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Center(
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Color(0xFF828282),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Text(
                              'or',
                              style: TextStyle(
                                color: Color(0xFFBBBBBB),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Color(0xFF828282),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  AuthTextfeildContainer(
                    controller: _nameController,
                    hintText: 'Fullname',
                    icon: Icons.person,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.013),
                  AuthTextfeildContainer(
                    controller: _phoneController,
                    hintText: 'Phone Number',
                    icon: Icons.phone,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.013),
                  AuthTextfeildContainer(
                    hintText: 'Email',
                    icon: Icons.mail,
                    controller: _emailController,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.013),
                  AuthTextfeildContainer(
                    controller: _passwordController,
                    hintText: 'Password',
                    icon: Icons.lock,
                    isPassword: true,
                    // isPassword: true,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.013),
                  AuthTextfeildContainer(
                    controller: _confirmPasswordController,
                    hintText: 'Confirm Password',
                    icon: Icons.lock,
                    isPassword: true,
                  ),
                  if (errorMessage!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        errorMessage!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20, top: 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: _isAgreed,
                            onChanged: (bool? value) {
                              setState(() {
                                _isAgreed = value ?? false;
                              });
                            },
                            activeColor: Colors.white,
                            checkColor: Colors.black,
                            side: BorderSide(
                              color: Color(0xFFBBBBBB),
                              width: 2,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isAgreed = !_isAgreed;
                              });
                            },
                            child: Text(
                              'I agree with Privacy and Policy',
                              style: TextStyle(
                                color: Color(0xFFBBBBBB),
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  AuthButton(
                    text: 'Sign Up',
                    onTap: signUp,
                    // isLoading: isLoading,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
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
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Login',
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
