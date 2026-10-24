import 'package:docusense_ai/Auth/google_auth.dart' as auth_service;
import 'package:docusense_ai/app_localization.dart';
import 'package:docusense_ai/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Future<bool> showSignInDialog(BuildContext context) async =>
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => SignInDialog(
        googleSignIn: () async => await auth_service.signInWithGoogle() != null,
      ),
    ) ??
    false;

class SignInDialog extends StatefulWidget {
  const SignInDialog({super.key, required this.googleSignIn});

  final Future<bool> Function() googleSignIn;

  @override
  State<SignInDialog> createState() => _SignInDialogState();
}

class _SignInDialogState extends State<SignInDialog> {
  bool _busy = false;
  String? _error;

  Future<void> _signIn(Future<bool> Function() action, String failure) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final success = await action();
      if (!mounted) return;
      if (success) {
        Navigator.of(context).pop(true);
        return;
      }
      setState(() => _error = failure);
    } catch (_) {
      if (mounted) setState(() => _error = failure);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return PopScope(
      canPop: !_busy,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppConstants.surfaceTint,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                strings.signInToUpload,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(strings.signInDescription, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: _busy
                    ? null
                    : () => _signIn(
                        widget.googleSignIn,
                        strings.googleSignInFailed,
                      ),
                icon: const Icon(FontAwesomeIcons.google, size: 18),
                label: Text(strings.signInWithGoogle),
              ),
              const SizedBox(height: 12),
              if (_busy) ...[
                const SizedBox(height: 12),
                const CircularProgressIndicator(
                  color: AppConstants.primaryColor,
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 12),
              TextButton(
                onPressed: _busy
                    ? null
                    : () => Navigator.of(context).pop(false),
                child: Text(strings.cancel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
