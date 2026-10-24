import 'package:askdocai/Auth/google_auth.dart' as auth_service;
import 'package:askdocai/Auth/email_auth.dart' as email_auth;
import 'package:askdocai/app_localization.dart';
import 'package:askdocai/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Future<bool> showSignInDialog(BuildContext context) async =>
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => SignInDialog(
        googleSignIn: () async => await auth_service.signInWithGoogle() != null,
        emailSignIn: email_auth.signInWithEmail,
        resetPassword: email_auth.resetEmailPassword,
      ),
    ) ??
    false;

class SignInDialog extends StatefulWidget {
  const SignInDialog({
    super.key,
    required this.googleSignIn,
    this.emailSignIn,
    this.resetPassword,
  });

  final Future<bool> Function() googleSignIn;
  final Future<bool> Function(
    String email,
    String password,
    bool createAccount,
  )?
  emailSignIn;
  final Future<void> Function(String email)? resetPassword;

  @override
  State<SignInDialog> createState() => _SignInDialogState();
}

class _SignInDialogState extends State<SignInDialog> {
  bool _busy = false;
  String? _error;
  String? _notice;
  bool _createAccount = false;
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submitEmail() async {
    if (_busy) return;
    if (!_formKey.currentState!.validate()) return;
    await _signIn(
      () => widget.emailSignIn!(
        _email.text.trim(),
        _password.text,
        _createAccount,
      ),
      'Unable to sign in. Check your details and try again.',
    );
  }

  Future<void> _resetPassword() async {
    if (_busy) return;
    final email = _email.text.trim();
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      setState(() => _error = 'Enter your email address first.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
      _notice = null;
    });
    try {
      await widget.resetPassword!(email);
      if (mounted) {
        setState(
          () => _notice =
              'If an account exists, a password reset email has been sent.',
        );
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = 'Unable to send the reset email. Please try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _signIn(Future<bool> Function() action, String failure) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
      _notice = null;
    });
    try {
      final success = await action();
      if (!mounted) return;
      if (success) {
        Navigator.of(context).pop(true);
        return;
      }
      setState(() => _error = failure);
    } on FirebaseAuthException catch (error) {
      if (mounted) {
        setState(
          () => _error = switch (error.code) {
            'weak-password' =>
              'Choose a stronger password with at least 6 characters.',
            'email-already-in-use' =>
              'Unable to create this account. Try signing in or resetting your password.',
            'too-many-requests' => 'Too many attempts. Please try again later.',
            'network-request-failed' =>
              'Check your internet connection and try again.',
            _ => failure,
          },
        );
      }
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
          child: SingleChildScrollView(
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
                Text(
                  widget.emailSignIn == null
                      ? strings.signInDescription
                      : 'Sign in with email or Google to upload documents.',
                  textAlign: TextAlign.center,
                ),
                if (widget.emailSignIn != null) ...[
                  const SizedBox(height: 16),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _email,
                          enabled: !_busy,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (value) =>
                              RegExp(
                                r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                              ).hasMatch(value?.trim() ?? '')
                              ? null
                              : 'Enter a valid email address.',
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _password,
                          enabled: !_busy,
                          obscureText: true,
                          autofillHints: [
                            _createAccount
                                ? AutofillHints.newPassword
                                : AutofillHints.password,
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Password',
                          ),
                          onFieldSubmitted: (_) {
                            if (!_busy) _submitEmail();
                          },
                          validator: (value) => (value?.isEmpty ?? true)
                              ? 'Enter your password.'
                              : _createAccount && value!.length < 6
                              ? 'Use at least 6 characters.'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: _busy ? null : _submitEmail,
                          child: Text(
                            _createAccount
                                ? 'Create account'
                                : 'Sign in with email',
                          ),
                        ),
                        TextButton(
                          onPressed: _busy
                              ? null
                              : () => setState(() {
                                  _createAccount = !_createAccount;
                                  _error = null;
                                  _notice = null;
                                  _formKey.currentState?.reset();
                                }),
                          child: Text(
                            _createAccount
                                ? 'Already have an account? Sign in'
                                : 'Create an account',
                          ),
                        ),
                        if (!_createAccount && widget.resetPassword != null)
                          TextButton(
                            onPressed: _busy ? null : _resetPassword,
                            child: const Text('Forgot password?'),
                          ),
                      ],
                    ),
                  ),
                ],
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
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                if (_notice != null)
                  Text(_notice!, textAlign: TextAlign.center),
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
      ),
    );
  }
}
