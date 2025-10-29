import 'package:docusense_ai/screens/landing_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:docusense_ai/providers/auth_state.dart';
import 'package:docusense_ai/providers/file_state.dart';
//import 'package:docusense_ai/providers/quiz_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const SecureVault());
}

class SecureVault extends StatelessWidget {
  const SecureVault({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthState()),
        ChangeNotifierProvider(create: (_) => FileState()),
        //ChangeNotifierProvider(create: (_) => QuizState()),
      ],
      child: MaterialApp(
        title: 'Smart Document Assistant',
        theme: ThemeData(
          primaryColor: const Color(0xFF1a73e8),
          primaryColorDark: const Color(0xFF0d47a1),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: const Color(0xFF4285f4),
          ),
          fontFamily: 'Segoe UI',
        ),
        home: const LandingScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
