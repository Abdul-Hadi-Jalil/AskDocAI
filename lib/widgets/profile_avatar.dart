import 'package:flutter/material.dart';
//import 'package:docusense_ai/Auth/google_sign_out.dart';
//import 'package:docusense_ai/Screens/signin_screen.dart';
import 'package:docusense_ai/utils/generate_color.dart';
import 'package:docusense_ai/utils/get_initial.dart';
import 'package:provider/provider.dart';
import 'package:docusense_ai/providers/auth_state.dart';

class ProfileAvatar extends StatelessWidget {
  final String? userName;
  final VoidCallback? onSignOut;
  const ProfileAvatar({super.key, this.userName, this.onSignOut});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthState>();
    final isSignedIn = authState.isUserSignedIn;
    final user = authState.user;

    return PopupMenuButton(
      offset: const Offset(0, 45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: isSignedIn ? 'Sign out' : 'Sign in',
          child: Text(isSignedIn ? 'Sign out' : 'Sign in'),
        ),
      ],
      //onSelected: (value) async {
      //try {
      //if (isSignedIn) {
      //await googleSignout();
      //context.read<AuthState>().signOut();
      //onSignOut?.call();
      //} else {
      // showSignInDialog(context);
      // }
      //} catch (e) {
      // ScaffoldMessenger.of(
      //  context,
      // ).showSnackBar(SnackBar(content: Text('Error: $e')));
      // }
      //},
      child: CircleAvatar(
        radius: 20,
        backgroundColor: generateColorFromString(
          user?.displayName ?? userName ?? "Guest",
        ),
        child: Text(
          isSignedIn
              ? getInitial(user?.displayName ?? userName ?? "Guest")
              : '?',
        ),
      ),
    );
  }
}
