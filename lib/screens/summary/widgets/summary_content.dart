import 'package:docusense_ai/app_localization.dart';
import 'package:docusense_ai/providers/file_provider.dart';
import 'package:docusense_ai/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'summary_section.dart';
import 'key_findings_section.dart';
import 'main_topics_section.dart';
import 'summary_action_buttons.dart';

class SummaryContent extends StatelessWidget {
  final String summary;

  const SummaryContent({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final fileProvider = Provider.of<FileProvider>(context);
    final parsedSections = _parseSummarySections(summary);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildSummaryHeader(
            context,
            fileProvider.fileName ?? AppLocalizations.of(context).document,
          ),
          const SizedBox(height: 25),

          if (parsedSections['executive'] != null)
            SummarySection(
              icon: Icons.description,
              title: AppLocalizations.of(context).executiveSummary,
              content: parsedSections['executive']!,
            ),

          const SizedBox(height: 20),

          if (parsedSections['findings'] != null)
            KeyFindingsSection(content: parsedSections['findings']!),

          const SizedBox(height: 20),

          if (parsedSections['topics'] != null)
            MainTopicsSection(content: parsedSections['topics']!),

          const SizedBox(height: 20),

          if (parsedSections['conclusions'] != null)
            SummarySection(
              icon: Icons.lightbulb_outline,
              title: AppLocalizations.of(context).conclusionsRecommendations,
              content: parsedSections['conclusions']!,
            ),

          const SizedBox(height: 25),

          const SummaryActionButtons(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader(BuildContext context, String fileName) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context).documentSummary,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppConstants.textColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${AppLocalizations.of(context).aiGeneratedInsights} "$fileName"',
          style: const TextStyle(
            fontSize: 14,
            color: AppConstants.subtitleColor,
          ),
        ),
      ],
    );
  }

  Map<String, String> _parseSummarySections(String summary) {
    final sections = <String, String>{};

    try {
      final lines = summary.split('\n');
      String currentSection = '';
      StringBuffer currentContent = StringBuffer();

      for (final line in lines) {
        if (line.contains('EXECUTIVE SUMMARY:')) {
          _saveSection(sections, currentSection, currentContent);
          currentSection = 'executive';
          currentContent = StringBuffer();
        } else if (line.contains('KEY FINDINGS:')) {
          _saveSection(sections, currentSection, currentContent);
          currentSection = 'findings';
          currentContent = StringBuffer();
        } else if (line.contains('MAIN TOPICS COVERED:')) {
          _saveSection(sections, currentSection, currentContent);
          currentSection = 'topics';
          currentContent = StringBuffer();
        } else if (line.contains('CONCLUSIONS & RECOMMENDATIONS:')) {
          _saveSection(sections, currentSection, currentContent);
          currentSection = 'conclusions';
          currentContent = StringBuffer();
        } else if (currentSection.isNotEmpty) {
          currentContent.writeln(line);
        }
      }

      _saveSection(sections, currentSection, currentContent);
    } catch (e) {
      sections['executive'] = summary;
    }

    return sections;
  }

  void _saveSection(
    Map<String, String> sections,
    String section,
    StringBuffer content,
  ) {
    if (section.isNotEmpty && content.toString().trim().isNotEmpty) {
      sections[section] = content.toString().trim();
    }
  }
}
