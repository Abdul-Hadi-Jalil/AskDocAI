import 'package:flutter/material.dart';
import 'package:docusense_ai/widgets/features_section.dart';
import 'package:docusense_ai/widgets/recent_files_section.dart';
import 'package:docusense_ai/widgets/upload_section.dart';

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
