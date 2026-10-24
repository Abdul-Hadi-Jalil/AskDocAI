import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class AuthState with ChangeNotifier {
  bool _isUserSignedIn = false;
  User? _user;
  late final StreamSubscription<User?> _subscription;

  AuthState() {
    // Initialize auth state
    _user = FirebaseAuth.instance.currentUser;
    _isUserSignedIn = _user != null;
    // Listen for auth state changes
    _subscription = FirebaseAuth.instance.authStateChanges().listen((
      User? user,
    ) {
      _user = user;
      _isUserSignedIn = user != null;
      notifyListeners();
    });
  }

  bool get isUserSignedIn => _isUserSignedIn;
  User? get user => _user;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void signOut() {
    _user = null;
    _isUserSignedIn = false;
    notifyListeners();
  }
}
