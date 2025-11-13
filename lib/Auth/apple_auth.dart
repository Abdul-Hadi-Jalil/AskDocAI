import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleAuth {
  static Future<User?> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(oauthCredential);
      return userCredential.user;
    } catch (e) {
      print("Apple Sign-In error: $e");
      return null;
    }
  }

  // Apple Sign Out - Note: Apple doesn't have a specific sign out like Google
  // We use Firebase sign out which covers both Google and Apple
  static Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      debugPrint("✅ Apple user signed out from Firebase");
    } catch (e) {
      debugPrint("❌ Error signing out Apple user: $e");
      rethrow;
    }
  }
}
