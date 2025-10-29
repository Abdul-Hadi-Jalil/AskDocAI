/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

Future<void> googleSignout() async {
  try {
    // sign out from google sign in
    await GoogleSignIn().signOut();

    // sign out from firebase
    await FirebaseAuth.instance.signOut();
    //isUserSignedIn = false;
    debugPrint("Successfully signed out");
  } catch (e) {
    debugPrint("Failed to sign out");
    rethrow;
  }
}
*/
