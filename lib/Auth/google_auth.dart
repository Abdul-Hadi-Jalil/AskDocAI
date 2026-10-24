import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart'; // for debugPrint

Future<UserCredential?> signInWithGoogle() async {
  try {
    if (kIsWeb || defaultTargetPlatform == TargetPlatform.windows) {
      final provider = GoogleAuthProvider();
      return kIsWeb
          ? await FirebaseAuth.instance.signInWithPopup(provider)
          : await FirebaseAuth.instance.signInWithProvider(provider);
    }
    // Start Google Sign-In flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      debugPrint("❌ Sign-in canceled by user");
      return null;
    }

    // Get authentication details
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in with Firebase
    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );

    debugPrint("✅ Signed in as: ${userCredential.user?.displayName}");
    return userCredential;
  } catch (e) {
    debugPrint("❌ Error signing in with Google: $e");
    return null;
  }
}
