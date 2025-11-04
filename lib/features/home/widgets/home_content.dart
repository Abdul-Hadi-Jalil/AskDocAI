import 'package:flutter/material.dart';
import 'package:docusense_ai/features/home/widgets/features_section.dart';
import 'package:docusense_ai/features/home/widgets/recent_files_section.dart';
import 'package:docusense_ai/features/home/widgets/upload_section.dart';

import 'welcome_section.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const WelcomeSection(),
            const SizedBox(height: 30),
            FeaturesSection(),
            const SizedBox(height: 30),
            const UploadSection(),
            const RecentFilesSection(),
          ],
        ),
      ),
    );
  }
}
