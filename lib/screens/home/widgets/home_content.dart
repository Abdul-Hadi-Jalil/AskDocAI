import 'package:flutter/material.dart';
import 'package:docusense_ai/screens/home/widgets/recent_files_section.dart';
import 'package:docusense_ai/screens/home/widgets/upload_section.dart';
import 'welcome_section.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            WelcomeSection(),
            SizedBox(height: 30),
            UploadSection(),
            RecentFilesSection(),
          ],
        ),
      ),
    );
  }
}
