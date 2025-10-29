import 'package:flutter/material.dart';
import 'package:docusense_ai/utils/gemini_service.dart';
import 'package:provider/provider.dart';
import 'package:docusense_ai/providers/file_state.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  String? summaryText;
  bool isLoading = false;

  Future<void> _generateSummary() async {
    final fileState = context.read<FileState>();

    if (fileState.uploadedFileContent == null ||
        fileState.uploadedFileContent!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No file content available to summarize')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final result = await generateFileSummary(fileState.uploadedFileContent!);
      setState(() {
        summaryText = result;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error generating summary: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fileState = context.watch<FileState>();

    return Scaffold(
      backgroundColor: const Color(0xFFf8f9fa),
      appBar: AppBar(
        title: const Text('Document Summary'),
        backgroundColor: const Color(0xFF1a73e8),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: isLoading ? null : _generateSummary,
            tooltip: 'Regenerate Summary',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1a73e8), Color(0xFF0d47a1)],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      Text(
                        fileState.uploadedFileName ?? 'Document Summary',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'AI-Generated Summary',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: isLoading ? null : _generateSummary,
                        label: const Text('Generate Summary'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF1a73e8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 300,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: isLoading
                      ? const Center(
                          child: Column(
                            children: [
                              SizedBox(height: 30),
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text(
                                'Generating summary...',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF5f6368),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Text(
                          summaryText ??
                              "Tap 'Generate Summary' to create a summary of your uploaded document.",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF5f6368),
                            height: 1.5,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
