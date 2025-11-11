import 'package:docusense_ai/providers/file_provider.dart';
import 'package:docusense_ai/providers/summary_provider.dart';
import 'package:docusense_ai/utils/ads_manager.dart';
import 'package:docusense_ai/widgets/file_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import summary widgets
import 'widgets/summary_content.dart';
import 'widgets/summary_loading.dart';
import 'widgets/summary_error.dart';
import 'widgets/summary_empty.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  @override
  void initState() {
    super.initState();
    AdManager.loadRewardedAd(); // ✅ preload
  }

  @override
  Widget build(BuildContext context) {
    final fileProvider = Provider.of<FileProvider>(context);
    final summaryProvider = Provider.of<SummaryProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const FileHeader(),
          Expanded(
            child: summaryProvider.isLoading
                ? const SummaryLoading()
                : summaryProvider.error != null
                ? SummaryError(error: summaryProvider.error!)
                : summaryProvider.summary != null
                ? SummaryContent(summary: summaryProvider.summary!)
                : SummaryEmpty(fileProvider: fileProvider),
          ),
        ],
      ),
    );
  }
}
