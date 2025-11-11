import 'package:docusense_ai/models/app_state.dart';
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
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _bannerAd = AdManager.createBannerAd();
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const WelcomeSection(),
            const SizedBox(height: 30),

            // banner ad implementation
            if (_bannerAd != null)
              Container(
                alignment: Alignment.center,
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),

            const SizedBox(height: 20),
            const UploadSection(),
            const RecentFilesSection(),
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
    _bannerAd?.dispose();
    super.dispose();
  }
}
