// screens/summary_screen.dart
import 'package:docusense_ai/models/app_state.dart';
import 'package:docusense_ai/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pdf_provider.dart';
import '../providers/file_provider.dart';
import '../providers/summary_provider.dart';
import '../widgets/app_bar.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  @override
  void initState() {
    super.initState();
    // Auto-generate summary when screen loads if file exists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final fileProvider = Provider.of<FileProvider>(context, listen: false);
      final summaryProvider = Provider.of<SummaryProvider>(
        context,
        listen: false,
      );

      if (fileProvider.hasFile && summaryProvider.summary == null) {
        summaryProvider.generateSummary();
      }
    });
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
          // File Header
          _buildFileHeader(fileProvider),
          // Summary Content
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

  Widget _buildFileHeader(FileProvider fileProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      color: AppConstants.lightPurple,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // File Info
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppConstants.primaryColor,
                      AppConstants.secondaryColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.picture_as_pdf,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileProvider.fileName ?? 'No file uploaded',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.textColor,
                    ),
                  ),
                  Text(
                    fileProvider.hasFile
                        ? fileProvider.formattedFileSize
                        : 'Upload a file to generate summary',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppConstants.subtitleColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // File Actions
          if (fileProvider.hasFile)
            Row(
              children: [
                IconButton(
                  onPressed: _changeFile,
                  icon: const Icon(
                    Icons.swap_horiz,
                    color: AppConstants.primaryColor,
                    size: 20,
                  ),
                ),
                IconButton(
                  onPressed: () => _showFileInfo(fileProvider),
                  icon: const Icon(
                    Icons.info_outline,
                    color: AppConstants.primaryColor,
                    size: 20,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppConstants.primaryColor,
              ),
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Analyzing document and generating summary...',
            style: TextStyle(color: AppConstants.subtitleColor, fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'This may take a few moments',
            style: TextStyle(color: AppConstants.subtitleColor, fontSize: 12),
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
              'Failed to generate summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppConstants.textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: TextStyle(color: AppConstants.subtitleColor, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: summaryProvider.generateSummary,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Try Again'),
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
                  ? 'Generate Summary'
                  : 'No Document Uploaded',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppConstants.textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              fileProvider.hasFile
                  ? 'Tap below to analyze your document and generate a comprehensive summary'
                  : 'Upload a document first to generate an AI-powered summary',
              style: TextStyle(color: AppConstants.subtitleColor, fontSize: 14),
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
                child: const Text('Generate Summary'),
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
                child: const Text('Upload Document'),
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
          // Summary Header
          _buildSummaryHeader(fileProvider.fileName ?? 'Document'),
          const SizedBox(height: 25),

          // Executive Summary Section
          if (parsedSections['executive'] != null)
            _buildSummarySection(
              icon: Icons.description,
              title: 'Executive Summary',
              content: parsedSections['executive']!,
            ),

          const SizedBox(height: 20),

          // Key Findings Section
          if (parsedSections['findings'] != null)
            _buildKeyFindingsSection(parsedSections['findings']!),

          const SizedBox(height: 20),

          // Main Topics Section
          if (parsedSections['topics'] != null)
            _buildMainTopicsSection(parsedSections['topics']!),

          const SizedBox(height: 20),

          // Conclusions Section
          if (parsedSections['conclusions'] != null)
            _buildSummarySection(
              icon: Icons.lightbulb_outline,
              title: 'Conclusions & Recommendations',
              content: parsedSections['conclusions']!,
            ),

          const SizedBox(height: 25),

          // Action Buttons
          _buildActionButtons(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Map<String, String> _parseSummarySections(String summary) {
    final sections = <String, String>{};

    try {
      // Simple parsing logic - you can enhance this based on your actual response format
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
      // If parsing fails, show the entire summary in executive section
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
          'Document Summary',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppConstants.textColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'AI-generated insights from "$fileName"',
          style: TextStyle(fontSize: 14, color: AppConstants.subtitleColor),
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
          // Section Header
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
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Content
          Text(
            content,
            style: TextStyle(
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
          // Section Header
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
              const Text(
                'Key Findings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Key Points
          ...points.map((point) => _KeyPoint(text: point)).toList(),
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
          // Section Header
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
              const Text(
                'Main Topics',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Topics
          ...topics.map((topic) => _TopicItem(title: topic)).toList(),
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
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh, color: AppConstants.primaryColor, size: 16),
                SizedBox(width: 8),
                Text(
                  'Regenerate',
                  style: TextStyle(
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
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.share, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text(
                  'Share Summary',
                  style: TextStyle(
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

  void _changeFile() {
    final pdfProvider = Provider.of<PdfProvider>(context, listen: false);
    final summaryProvider = Provider.of<SummaryProvider>(
      context,
      listen: false,
    );

    pdfProvider.selectAndUploadFile().then((_) {
      summaryProvider.clearSummary();
    });
  }

  void _navigateToHome() {
    final pdfProvider = Provider.of<PdfProvider>(context, listen: false);
    pdfProvider.changeTab(BottomNavItem.home);
  }

  void _shareSummary() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality would open here'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showFileInfo(FileProvider fileProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('File Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${fileProvider.fileName ?? 'Unknown'}'),
            Text('Size: ${fileProvider.formattedFileSize}'),
            Text(
              'Type: ${fileProvider.fileName?.split('.').last ?? 'Unknown'}',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// _KeyPoint widget
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

// _TopicItem widget
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
