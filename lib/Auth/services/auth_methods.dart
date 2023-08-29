// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/utils/snackbar.dart';
import '../../generated/l10n.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null && user.emailVerified) {
        showSnackBar(context, S.of(context).email_verified);
        return;
      }

      await sendEmailVerification(context);

      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // GoRouter.of(context).push('/createProfile');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(context, S.of(context).weak_password);
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(context, S.of(context).account_already_exists);
      }
      showSnackBar(context, e.message!);
    }
  }

  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (!user!.emailVerified) {
        await _auth.currentUser!.sendEmailVerification();
        showSnackBar(context, S.of(context).email_verification_sent);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email is already verified.')),
        );
        GoRouter.of(context).push('/createProfile');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending email verification: $e')),
      );
    }
  }

  Future<void> waitForEmailVerification(BuildContext context) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      while (!currentUser.emailVerified) {
        await Future.delayed(Duration(seconds: 2)); // Wait for 2 seconds
        await currentUser.reload(); // Refresh user data
      }
      showSnackBar(context, S.of(context).email_verified);

      // Check if the user is new or existing
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: currentUser.email!,
        password: "", // Empty password as we're already verifying email
      );

      if (userCredential.additionalUserInfo!.isNewUser) {
        GoRouter.of(context).push('/createProfile');
      } else {
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('showHome', true);
        GoRouter.of(context).push('/home');
      }
    }
  }

// // EMAIL VERIFICATION
//   Future<void> sendEmailVerification(BuildContext context) async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;

//       if (!user!.emailVerified) {
//         _auth.currentUser!.sendEmailVerification();
//         showSnackBar(context, S.of(context).email_verification_sent);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Email is already verified.')),
//         );
//         GoRouter.of(context).push('/createProfile');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error sending email verification: $e')),
//       );
//     }
//   }

  // EMAIL VERIFICATION
  // Future<void> sendEmailVerification(BuildContext context) async {
  //   try {
  //     _auth.currentUser!.sendEmailVerification();
  //     showSnackBar(context, S.of(context).email_verification_sent);
  //   } on FirebaseAuthException catch (e) {
  //     showSnackBar(context, e.message!); // Display error message
  //   }
  // }

  // EMAIL LOGIN

  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('showHome', true);

      // Check if the user is new or existing
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        if (user.emailVerified) {
          final userDoc = await FirebaseFirestore.instance
              .collection('players')
              .doc(user.uid)
              .get();

          if (userDoc.exists) {
            final prefs = await SharedPreferences.getInstance();
            prefs.setBool('showHome', true);
            // User profile already exists
            GoRouter.of(context).push('/home');
          } else {
            // User profile doesn't exist
            GoRouter.of(context).push('/createProfile');
          }
        } else {
          // User's email is not verified
          showSnackBar(context, 'Please verify your email before logging in.');
          await _auth.signOut(); // Sign out the user
        }
      } else {
        // User is not registered
        showSnackBar(context, 'User is not registered. Please register.');
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, 'User is not registered. Swap Right to register.');
    }
  }

  // GOOGLE SIGN IN
  void signInWithGoogle(BuildContext context) async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        googleProvider
            .addScope('https://www.googleapis.com/auth/contacts.readonly');

        await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        if (googleUser == null) {
          showSnackBar(context, S.of(context).google_signin_no_user);
          return;
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        // Sign in to Firebase Authentication
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        // Check if the user is new or existing
        final user = userCredential.user;
        if (user != null) {
          final userDoc = await FirebaseFirestore.instance
              .collection('players')
              .doc(user.uid)
              .get();

          if (userDoc.exists) {
            final prefs = await SharedPreferences.getInstance();
            prefs.setBool('showHome', true);
            // User profile already exists
            GoRouter.of(context).push('/home');
          } else {
            // User profile doesn't exist
            GoRouter.of(context).push('/createProfile');
          }
        }
        // The routing code should be here after successful sign-in
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    } catch (e) {
      showSnackBar(
        context,
        '${S.of(context).google_signin_unexpected_error}$e',
      );
    }
  }

  //reset password
  Future<void> sendPasswordResetEmail({
    required String email,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(
        msg: S.of(context).password_reset_email_sent,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: S.of(context).failed_send_password_reset_email,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (error) {
      SnackBar(content: Text('Error during sign out: $error'));
    }
  }
}
