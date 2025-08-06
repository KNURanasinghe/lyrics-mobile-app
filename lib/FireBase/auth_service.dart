import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FireBaseAuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();

  Future<User?> signInWithGoogle() async {
    try {
      print('calling signInWithGoogle method');
      // Sign out first to clear any previous sessions
      await _googleSignIn.signOut();

      // Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      print('calling signInWithGoogle method  googleUser $googleUser');
      if (googleUser == null) {
        print('Google sign in cancelled by user');
        return null;
      }

      // Get authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      print('calling signInWithGoogle method  googleAuth $googleAuth');
      // Create Firebase credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      print('calling signInWithGoogle method  credential $credential');
      // Sign in to Firebase
      try {
        final UserCredential userCredential = await _firebaseAuth
            .signInWithCredential(credential);
        print(
          'calling signInWithGoogle method  userCredential $userCredential',
        );
        print(
          'Google sign in successful - User ID: ${userCredential.user?.uid}',
        );
        return userCredential.user;
      } catch (e) {
        print('calling signInWithGoogle method  userCredential error $e');
      }
    } catch (e) {
      print('Google sign in error: $e');
      rethrow; // Let the caller handle the exception
    }
    return null;
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
