import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grebooo/core/utils/appFunctions.dart';


class GoogleAuth {
  static Future disconnectGoogle() async {}
  static Future<Map<String, dynamic>?> signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    late GoogleSignInAuthentication googleSignInAuthentication;
    late UserCredential userCredential;
    if (googleSignInAccount != null) {
      googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      try {
        userCredential = await auth.signInWithCredential(credential);
        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          flutterToast(
              'The account already exists with a different credential.');
        } else if (e.code == 'invalid-credential') {
          flutterToast(
              'Error occurred while accessing credentials. Try again.');
        }
        return null;
      } catch (e) {
        flutterToast('Error occurred using Google Sign-In. Try again.');
        return null;
      }
    }
    final Map<String, dynamic> profile =
        userCredential.additionalUserInfo!.profile ?? {};
    return {
      "user": user,
      "token": googleSignInAuthentication.idToken,
      "socialId": profile["sub"] ?? ""
    };
  }

  static Future<bool> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await FirebaseAuth.instance.signOut();
      await googleSignIn.signOut();
      return true;
    } catch (e) {
      flutterToast('Error signing out. Try again.');
    }
    return false;
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }
}
