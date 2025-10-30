// Updated App.dart
import 'package:docusense_ai/models/app_state.dart';
import 'package:docusense_ai/screens/summay_screen.dart';
import 'package:docusense_ai/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/pdf_provider.dart';
import 'screens/home_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/quiz_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PdfProvider>(
      builder: (context, pdfProvider, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: _buildCurrentScreen(context, pdfProvider),
          bottomNavigationBar: const CustomBottomNav(),
        );
      },
    );
  }

  Widget _buildCurrentScreen(BuildContext context, PdfProvider pdfProvider) {
    // Use the currentTab from state for navigation
    switch (pdfProvider.state.currentTab) {
      case BottomNavItem.home:
        return const HomeScreen();
      case BottomNavItem.chat:
        if (pdfProvider.uploadedFileName != null) {
          return const ChatScreen();
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showNoPdfMessage(context, pdfProvider);
          });
          return const HomeScreen();
        }
      case BottomNavItem.summarize:
        if (pdfProvider.uploadedFileName != null) {
          return const SummaryScreen(); // Replace Placeholder with SummaryScreen
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showNoPdfMessage(context, pdfProvider);
          });
          return const HomeScreen();
        }
      case BottomNavItem.quiz:
        return const QuizScreen(); // Add this case
    }
  }

  void _showNoPdfMessage(BuildContext context, PdfProvider pdfProvider) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please upload a PDF first to start chatting'),
        duration: Duration(seconds: 2),
      ),
    );
    // Switch back to home tab
    pdfProvider.changeTab(BottomNavItem.home);
  }
}
