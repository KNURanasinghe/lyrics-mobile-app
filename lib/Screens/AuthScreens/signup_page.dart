import 'package:flutter/material.dart';
import 'package:lyrics/Screens/AuthScreens/login_page.dart';
import 'package:lyrics/widgets/auth_button.dart';
import 'package:lyrics/widgets/auth_textfeild_container.dart';
import 'package:lyrics/widgets/auth_via_big_button.dart';
import 'package:lyrics/widgets/auth_via_buttons.dart';
import 'package:lyrics/widgets/main_background.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<SignupPage> {
  bool _isAgreed = false;
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
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  AuthViaBigButton(
                    name: 'Continue with Apple',
                    path: 'assets/AppleInc.png',
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ), // Match main column padding
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
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  AuthTextfeildContainer(
                    hintText: 'Fullname',
                    icon: Icons.person,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.013),
                  AuthTextfeildContainer(
                    hintText: 'Phone Number',
                    icon: Icons.mail,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.013),
                  AuthTextfeildContainer(hintText: 'Email', icon: Icons.mail),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.013),
                  AuthTextfeildContainer(
                    hintText: 'Password',
                    icon: Icons.lock,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.013),
                  AuthTextfeildContainer(
                    hintText: 'Confirm Password',
                    icon: Icons.lock,
                  ),
                  // Then replace your current Align widget with checkbox with this:
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
                  // Example of a button
                  AuthButton(text: 'Sign Up'),

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
