import 'package:flutter/material.dart';
import 'package:docusense_ai/widgets/feature_card.dart';
import 'package:docusense_ai/Screens/main_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf8f9fa),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1a73e8), Color(0xFF0d47a1)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    const Text(
                      'Smart Document Assistant',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 80,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Your AI-Powered Document Companion',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Upload your documents and chat with them, get instant summaries, and create quizzes to test your knowledge. Transform your static files into interactive conversations.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Core Features Section
            const Padding(
              padding: EdgeInsets.all(40.0),
              child: Column(
                children: [
                  Text(
                    'Core Features',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0d47a1),
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),

            // Features Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: _getCrossAxisCount(context),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  FeatureCard(
                    icon: Icons.chat,
                    title: 'Chat with AI',
                    description:
                        'Have interactive conversations with your documents. Ask questions and get intelligent answers based on the content.',
                  ),
                  FeatureCard(
                    icon: Icons.summarize,
                    title: 'Get Summary',
                    description:
                        'Instantly generate concise summaries of lengthy documents to grasp key points quickly and efficiently.',
                  ),
                  FeatureCard(
                    icon: Icons.quiz,
                    title: 'Generate Quiz',
                    description:
                        'Create custom quizzes from your document content to test your knowledge and reinforce learning.',
                  ),
                ],
              ),
            ),

            // CTA Section
            Container(
              margin: const EdgeInsets.all(40),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border(
                  left: BorderSide(color: const Color(0xFF34a853), width: 4),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    '📍 Upload Your First Document',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0d47a1),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Get started in seconds. Upload any document and unlock its full potential with our AI-powered tools.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF5f6368),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => MainScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1a73e8),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      elevation: 4,
                      shadowColor: const Color(0xFF1a73e8).withOpacity(0.3),
                    ),
                    child: const Text(
                      'Upload Document',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // How It Works Section
            const Padding(
              padding: EdgeInsets.all(40.0),
              child: Column(
                children: [
                  Text(
                    'How It Works',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0d47a1),
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),

            // Footer
            Container(
              margin: const EdgeInsets.only(top: 40),
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(
                color: Color(0xFF0d47a1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: const Text(
                'Smart Document Assistant © 2023 | Transform Your Documents into Interactive Conversations',
                style: TextStyle(color: Colors.white, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 800) return 3;
    if (width > 600) return 2;
    return 1;
  }
}
