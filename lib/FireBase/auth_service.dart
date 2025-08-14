import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lyrics/Models/user_model.dart';
import 'package:lyrics/Service/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FireBaseAuthServices {
  final UserService _userService = UserService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  static const String imageUrl = 'imageUrl';

  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();
  static Future<void> saveIsPremium(String imageUrl) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(imageUrl, imageUrl);
    } catch (e) {
      print('Error saving user ID: $e');
    }
  }

  static Future<String> getemailProfileImage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(imageUrl);
      return userId != null ? userId.toString() : '';
    } catch (e) {
      print('Error loading getemailProfileImage $e');
      return '';
    }
  }

  Future<bool> signUpWithGoogle() async {
    try {
      print('calling signInWithGoogle method');
      // Sign out first to clear any previous sessions
      await _googleSignIn.signOut();

      // Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      print('calling signInWithGoogle method  googleUser $googleUser');
      print(
        'calling signInWithGoogle method  googleUser ${googleUser!.displayName}',
      );
      final newUser = UserModel(
        fullname: googleUser.displayName!,
        email: googleUser.email,
        phonenumber: '07xxxxxxx',
        password: '1a2a3a4a',
      );
      await saveIsPremium(googleUser.photoUrl!);
      final result = await _userService.signUp(newUser);
      print('signup results ${result['success']}');
      if (result['success'] == true) {
        return true;
      }
      return false;
    } on FirebaseException catch (e) {
      print('Google sign in error: $e');
      rethrow; // Let the caller handle the exception
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      print('calling signInWithGoogle method');
      // Sign out first to clear any previous sessions
      await _googleSignIn.signOut();

      // Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      print('calling signInWithGoogle method  googleUser $googleUser');
      print(
        'calling signInWithGoogle method  googleUser ${googleUser!.displayName}',
      );
      await saveIsPremium(googleUser.photoUrl!);
      final result = await _userService.login(
        emailOrPhone: googleUser.email,
        password: '1a2a3a4a',
      );
      print('signup results ${result['success']}');
      if (result['success'] == true) {
        return true;
      }
      return false;
    } on FirebaseException catch (e) {
      print('Google sign in error: $e');
      rethrow; // Let the caller handle the exception
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}

///use this in signup//
// Future<void> googleSignUp() async {
//     print('Google sign up initiated');
//     setState(() {
//       isLoading = true;
//       errorMessage = '';
//     });

//     try {
//       print('Calling signInWithGoogle');
//       final result = await FireBaseAuthServices().signInWithGoogle();
//       print('Google sign in result: $result');

//       if (result != null) {
//         print('User signed in successfully: ${result.uid}');
//         if (mounted) {
//           Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(builder: (_) => HomePage()),
//             (route) => false, // This removes all previous routes
//           );
//         }
//       } else {
//         print('Google sign in returned null user');
//         if (mounted) {
//           setState(() {
//             errorMessage = 'Sign in was cancelled or failed';
//           });
//         }
//       }
//     } on FirebaseAuthException catch (e) {
//       print('Google sign in error: ${e.message}');
//       if (mounted) {
//         setState(() {
//           errorMessage = e.message ?? 'An unknown error occurred';
//         });
//       }
//     } catch (e) {
//       print('Unexpected error during Google sign in: $e');
//       if (mounted) {
//         setState(() {
//           errorMessage = 'An unexpected error occurred';
//         });
//       }
//     } finally {
//       print('Google sign in process completed');
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     }
//   }

//   Future<void> signUpWithEmailAndPassword() async {
//     if (!_isAgreed) {
//       setState(() {
//         errorMessage = 'Please agree to Privacy and Policy';
//       });
//       return;
//     }

//     if (_passwordController.text != _confirmPasswordController.text) {
//       setState(() {
//         errorMessage = 'Passwords do not match';
//       });
//       return;
//     }

//     setState(() {
//       isLoading = true;
//       errorMessage = '';
//     });

//     try {
//       await FireBaseAuthServices().signUpWithEmailAndPassword(
//         _emailController.text,
//         _passwordController.text,
//       );
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => HomePage()),
//       );
//     } on FirebaseAuthException catch (e) {
//       setState(() {
//         errorMessage = e.message ?? 'An unknown error occurred';
//       });
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
