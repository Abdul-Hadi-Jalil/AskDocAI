// screens/summary_screen.dart
import 'package:docusense_ai/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pdf_provider.dart';
import '../widgets/app_bar.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final pdfProvider = Provider.of<PdfProvider>(context);
    final fileName = pdfProvider.uploadedFileName ?? 'document.pdf';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(), // Use the shared CustomAppBar
      body: Column(
        children: [
          // File Header only (remove the custom app bar from here)
          _buildFileHeader(fileName, pdfProvider),
          // Summary Content
          Expanded(
            child: _isLoading
                ? _buildLoadingIndicator()
                : _buildSummaryContent(fileName),
          ),
        ],
      ),
    );
  }

  Widget _buildFileHeader(String fileName, PdfProvider pdfProvider) {
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
                    fileName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.textColor,
                    ),
                  ),
                  const Text(
                    '2.4 MB • 24 pages',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppConstants.subtitleColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // File Actions
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
                onPressed: _showFileInfo,
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

  Widget _buildSummaryContent(String fileName) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Summary Header
          _buildSummaryHeader(),
          const SizedBox(height: 25),
          // Stats Cards
          _buildStatsCards(),
          const SizedBox(height: 25),
          // Executive Summary
          _buildSummarySection(
            icon: Icons.description,
            title: 'Executive Summary',
            content:
                'This document explores the transformative impact of artificial intelligence on modern education systems. It examines how AI technologies are reshaping teaching methodologies, student assessment, and administrative processes in educational institutions worldwide.',
          ),
          const SizedBox(height: 20),
          // Key Findings
          _buildKeyFindingsSection(),
          const SizedBox(height: 20),
          // Main Topics
          _buildMainTopicsSection(),
          const SizedBox(height: 20),
          // Recommendations
          _buildSummarySection(
            icon: Icons.lightbulb_outline,
            title: 'Recommendations',
            content:
                'The document recommends a phased approach to AI implementation, starting with pilot programs. It emphasizes teacher training and developing clear ethical guidelines before full-scale implementation.',
          ),
          const SizedBox(height: 25),
          // Action Buttons
          _buildActionButtons(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader() {
    return const Column(
      children: [
        Text(
          'Document Summary',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppConstants.textColor,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Key insights from your document',
          style: TextStyle(fontSize: 14, color: AppConstants.subtitleColor),
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    return const Row(
      children: [
        Expanded(
          child: _StatCard(value: '24', label: 'Pages'),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _StatCard(value: '5', label: 'Key Topics'),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _StatCard(value: '12', label: 'Main Points'),
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
                style: const TextStyle(
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

  Widget _buildKeyFindingsSection() {
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
          const _KeyPoint(
            text:
                'AI-powered personalized learning increases student engagement by 47% compared to traditional methods',
          ),
          const _KeyPoint(
            text:
                'Automated assessment tools reduce teacher workload by 62% while improving feedback quality',
          ),
          const _KeyPoint(
            text:
                'Predictive analytics can identify at-risk students with 89% accuracy 6 weeks before traditional methods',
          ),
          const _KeyPoint(
            text:
                'Ethical concerns around data privacy remain the primary barrier to AI adoption in education',
          ),
        ],
      ),
    );
  }

  Widget _buildMainTopicsSection() {
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
          const _TopicItem(
            title: 'Personalized Learning',
            description:
                'Adaptive algorithms that tailor educational content to individual student needs',
          ),
          const _TopicItem(
            title: 'Intelligent Tutoring',
            description:
                'AI systems that provide real-time feedback and guidance to students',
          ),
          const _TopicItem(
            title: 'Administrative Automation',
            description:
                'Streamlining administrative tasks through AI-powered systems',
          ),
          const _TopicItem(
            title: 'Data Analytics',
            description:
                'Using student data to improve educational outcomes and institutional efficiency',
          ),
          const _TopicItem(
            title: 'Ethical Considerations',
            description:
                'Addressing privacy, bias, and accessibility concerns in AI implementation',
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _regenerateSummary,
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

  Widget _buildLoadingIndicator() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppConstants.primaryColor,
              ),
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Generating summary...',
            style: TextStyle(color: AppConstants.subtitleColor),
          ),
        ],
      ),
    );
  }

  void _regenerateSummary() {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Summary regenerated with latest AI analysis'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  void _shareSummary() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality would open here'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _changeFile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Change file functionality would open here'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showFileInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('File Information'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: research_paper.pdf'),
            Text('Size: 2.4 MB'),
            Text('Pages: 24'),
            Text('Last Modified: 2 days ago'),
            Text('Word Count: 12,450'),
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

// Stat Card Widget
class _StatCard extends StatelessWidget {
  final String value;
  final String label;

  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
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
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppConstants.primaryColor,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppConstants.subtitleColor,
            ),
          ),
        ],
      ),
    );
  }
}

// Key Point Widget
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

// Topic Item Widget
class _TopicItem extends StatelessWidget {
  final String title;
  final String description;

  const _TopicItem({required this.title, required this.description});

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppConstants.subtitleColor,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
