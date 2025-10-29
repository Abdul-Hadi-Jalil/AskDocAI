import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthState with ChangeNotifier {
  bool _isUserSignedIn = false;
  User? _user;

  AuthState() {
    // Initialize auth state
    _user = FirebaseAuth.instance.currentUser;
    _isUserSignedIn = _user != null;
    // Listen for auth state changes
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _user = user;
      _isUserSignedIn = user != null;
      notifyListeners();
    });
  }

  bool get isUserSignedIn => _isUserSignedIn;
  User? get user => _user;

  void signOut() {
    _user = null;
    _isUserSignedIn = false;
    notifyListeners();
  }
}
