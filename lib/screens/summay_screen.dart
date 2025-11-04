import 'package:docusense_ai/app_localization.dart';
import 'package:docusense_ai/models/app_state.dart';
import 'package:docusense_ai/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pdf_provider.dart';
import '../providers/file_provider.dart';
import '../providers/summary_provider.dart';
import '../widgets/app_bar.dart';
import '../widgets/file_header.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  @override
  void initState() {
    super.initState();
    // Remove the automatic summary generation
  }

  @override
  Widget build(BuildContext context) {
    final fileProvider = Provider.of<FileProvider>(context);
    final summaryProvider = Provider.of<SummaryProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          FileHeader(),
          Expanded(
            child: summaryProvider.isLoading
                ? _buildLoadingIndicator()
                : summaryProvider.error != null
                ? _buildErrorState(summaryProvider.error!, summaryProvider)
                : summaryProvider.summary != null
                ? _buildSummaryContent(summaryProvider.summary!, fileProvider)
                : _buildEmptyState(fileProvider, summaryProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppConstants.primaryColor,
              ),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).analyzingDocument,
            style: const TextStyle(
              color: AppConstants.subtitleColor,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).mayTakeFewMoments,
            style: const TextStyle(
              color: AppConstants.subtitleColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error, SummaryProvider summaryProvider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context).failedToGenerateSummary,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppConstants.textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: const TextStyle(
                color: AppConstants.subtitleColor,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: summaryProvider.generateSummary,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: Text(AppLocalizations.of(context).tryAgain),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    FileProvider fileProvider,
    SummaryProvider summaryProvider,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.description_outlined,
              color: AppConstants.primaryColor,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              fileProvider.hasFile
                  ? AppLocalizations.of(context).generateSummary
                  : AppLocalizations.of(context).noDocumentUploaded,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppConstants.textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              fileProvider.hasFile
                  ? AppLocalizations.of(context).tapToGenerateSummary
                  : AppLocalizations.of(context).uploadFirstForSummary,
              style: const TextStyle(
                color: AppConstants.subtitleColor,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (fileProvider.hasFile)
              ElevatedButton(
                onPressed: summaryProvider.generateSummary,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: Text(AppLocalizations.of(context).generateSummary),
              )
            else
              ElevatedButton(
                onPressed: _navigateToHome,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: Text(AppLocalizations.of(context).uploadDocument),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryContent(String summary, FileProvider fileProvider) {
    final parsedSections = _parseSummarySections(summary);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildSummaryHeader(
            fileProvider.fileName ?? AppLocalizations.of(context).document,
          ),
          const SizedBox(height: 25),

          if (parsedSections['executive'] != null)
            _buildSummarySection(
              icon: Icons.description,
              title: AppLocalizations.of(context).executiveSummary,
              content: parsedSections['executive']!,
            ),

          const SizedBox(height: 20),

          if (parsedSections['findings'] != null)
            _buildKeyFindingsSection(parsedSections['findings']!),

          const SizedBox(height: 20),

          if (parsedSections['topics'] != null)
            _buildMainTopicsSection(parsedSections['topics']!),

          const SizedBox(height: 20),

          if (parsedSections['conclusions'] != null)
            _buildSummarySection(
              icon: Icons.lightbulb_outline,
              title: AppLocalizations.of(context).conclusionsRecommendations,
              content: parsedSections['conclusions']!,
            ),

          const SizedBox(height: 25),

          _buildActionButtons(),
          const SizedBox(height: 20),
        ],
      ),
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

  Widget _buildSummaryHeader(String fileName) {
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

  Widget _buildSummarySection({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppConstants.lightPurple,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppConstants.primaryColor, size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.textColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: AppConstants.subtitleColor,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyFindingsSection(String findingsContent) {
    final points = _extractBulletPoints(findingsContent);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppConstants.lightPurple,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.flag_outlined,
                  color: AppConstants.primaryColor,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context).keyFindings,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ...points.map((point) => _KeyPoint(text: point)),
        ],
      ),
    );
  }

  Widget _buildMainTopicsSection(String topicsContent) {
    final topics = _extractBulletPoints(topicsContent);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppConstants.lightPurple,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.topic_outlined,
                  color: AppConstants.primaryColor,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context).mainTopics,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ...topics.map((topic) => _TopicItem(title: topic)),
        ],
      ),
    );
  }

  List<String> _extractBulletPoints(String content) {
    return content
        .split('\n')
        .where(
          (line) => line.trim().startsWith('-') || line.trim().startsWith('•'),
        )
        .map((line) => line.replaceFirst(RegExp(r'^[-\•]\s*'), '').trim())
        .where((point) => point.isNotEmpty)
        .toList();
  }

  Widget _buildActionButtons() {
    final summaryProvider = Provider.of<SummaryProvider>(
      context,
      listen: false,
    );

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: summaryProvider.generateSummary,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: const BorderSide(color: AppConstants.primaryColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.refresh,
                  color: AppConstants.primaryColor,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context).regenerate,
                  style: const TextStyle(
                    color: AppConstants.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: _shareSummary,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              backgroundColor: AppConstants.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 4,
              shadowColor: AppConstants.primaryColor.withOpacity(0.3),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.share, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context).shareSummary,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToHome() {
    final pdfProvider = Provider.of<PdfProvider>(context, listen: false);
    pdfProvider.changeTab(BottomNavItem.home);
  }

  void _shareSummary() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).shareFunctionality),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _KeyPoint extends StatelessWidget {
  final String text;

  const _KeyPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(
              Icons.circle,
              size: 8,
              color: AppConstants.primaryColor,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: AppConstants.subtitleColor,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopicItem extends StatelessWidget {
  final String title;

  const _TopicItem({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(
              Icons.circle,
              size: 8,
              color: AppConstants.primaryColor,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: AppConstants.subtitleColor,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
