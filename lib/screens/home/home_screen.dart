import 'package:docusense_ai/models/app_state.dart';
import 'package:docusense_ai/providers/auth_state.dart';
import 'package:docusense_ai/providers/pdf_provider.dart';
import 'package:docusense_ai/screens/quiz/quiz_screen.dart';
import 'package:docusense_ai/widgets/app_bar.dart';
import 'package:docusense_ai/widgets/bottom_nav.dart';
import 'package:docusense_ai/utils/ads_manager.dart';
import 'package:docusense_ai/screens/home/widgets/welcome_section.dart';
import 'package:docusense_ai/screens/home/widgets/upload_section.dart';
import 'package:docusense_ai/screens/home/widgets/recent_files_section.dart';
import 'package:docusense_ai/screens/chat/chat_screen.dart';
import 'package:docusense_ai/screens/summary/summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NativeAd? _nativeAd;

  @override
  void initState() {
    super.initState();
    _nativeAd = AdManager.createNativeAd();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PdfProvider>(
      builder: (context, pdfProvider, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.grey[50]!],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: const CustomAppBar(),
            body: _buildCurrentScreen(context, pdfProvider),
            bottomNavigationBar: const CustomBottomNav(),
          ),
        );
      },
    );
  }

  Widget _buildCurrentScreen(BuildContext context, PdfProvider pdfProvider) {
    switch (pdfProvider.state.currentTab) {
      case BottomNavItem.home:
        return _buildHomeContent();
      case BottomNavItem.chat:
        if (pdfProvider.hasFileLoaded) {
          return const ChatScreen();
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showNoPdfMessage(context, pdfProvider);
          });
          return _buildHomeContent();
        }
      case BottomNavItem.summarize:
        if (pdfProvider.hasFileLoaded) {
          return const SummaryScreen();
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showNoPdfMessage(context, pdfProvider);
          });
          return _buildHomeContent();
        }
      case BottomNavItem.quiz:
        if (pdfProvider.hasFileLoaded) {
          return const QuizScreen();
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showNoPdfMessage(context, pdfProvider);
          });
          return _buildHomeContent();
        }
    }
  }

  Widget _buildHomeContent() {
    // auth state to check if user is signed in then display the recent files section.
    final authState = Provider.of<AuthState>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const WelcomeSection(),
            const SizedBox(height: 30),

            // native ad implementation
            if (_nativeAd != null)
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 100, // Small size for native ad
                child: AdWidget(ad: _nativeAd!),
              ),

            const SizedBox(height: 20),
            const UploadSection(),
            if (authState.isUserSignedIn) const RecentFilesSection(),
          ],
        ),
      ),
    );
  }

  void _showNoPdfMessage(BuildContext context, PdfProvider pdfProvider) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please upload a PDF first to access this feature'),
        duration: Duration(seconds: 2),
      ),
    );
    pdfProvider.changeTab(BottomNavItem.home);
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }
}
