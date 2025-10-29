import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:docusense_ai/Auth/google_auth.dart' as authService;

Future<void> showSignInDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFFF5F5FF),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Sign in to upload documents",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "Please sign in with your Google or Apple account to continue with document uploads.",
                style: TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              //SizedBox(
              // width: double.infinity,
              //child: OutlinedButton.icon(
              // style: OutlinedButton.styleFrom(
              //  padding: const EdgeInsets.symmetric(vertical: 14),
              // shape: RoundedRectangleBorder(
              //  borderRadius: BorderRadius.circular(12),
              // ),
              //side: const BorderSide(color: Colors.transparent),
              // backgroundColor: Colors.white,
              // shadowColor: Colors.black12,
              //elevation: 1,
              // ),
              //onPressed: () async {
              // Navigator.pop(context);
              //await authService.signInWithGoogle();
              // AuthState will automatically update via Firebase listener
              //},
              //icon: const Icon(
              // FontAwesomeIcons.google,
              //color: Colors.black54,
              // size: 18,
              // ),
              //label: const Text(
              // "Sign in with Google",
              //style: TextStyle(
              // color: Colors.black87,
              //fontSize: 16,
              //fontWeight: FontWeight.w600,
              // ),
              //),
              //),
              //),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    // TODO: Handle Apple Sign-In
                  },
                  icon: const Icon(
                    FontAwesomeIcons.apple,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: const Text(
                    "Sign in with Apple",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
