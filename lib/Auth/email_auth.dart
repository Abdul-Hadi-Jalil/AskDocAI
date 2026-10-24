import 'package:firebase_auth/firebase_auth.dart';

Future<bool> signInWithEmail(
  String email,
  String password,
  bool createAccount,
) async {
  final auth = FirebaseAuth.instance;
  final credential = createAccount
      ? await auth.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password,
        )
      : await auth.signInWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );
  return credential.user != null;
}

Future<void> resetEmailPassword(String email) =>
    FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
