// providers/summary_provider.dart
import 'package:docusense_ai/utils/gemini_service.dart';
import 'package:flutter/material.dart';
import './file_provider.dart';

class SummaryProvider extends ChangeNotifier {
  final FileProvider _fileProvider;

  String? _summary;
  bool _isLoading = false;
  String? _error;

  SummaryProvider({required FileProvider fileProvider})
    : _fileProvider = fileProvider;

  String? get summary => _summary;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> generateSummary() async {
    if (_fileProvider.fileContent == null ||
        _fileProvider.fileContent!.isEmpty) {
      _error = 'No file content available to summarize';
      notifyListeners();
      return;
    }

    // Set loading state
    _isLoading = true;
    _error = null;
    _summary = null;
    notifyListeners();

    try {
      final summaryContent = await generateFileSummary(
        _fileProvider.fileContent!,
      );

      // Set success state
      _summary = summaryContent;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      // Set error state
      _error = 'Failed to generate summary: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSummary() {
    _summary = null;
    _error = null;
    notifyListeners();
  }

  // Remove the setState method since we don't need it in the provider
  // void setState({
  //   bool? isLoading,
  //   String? summary,
  //   String? error,
  // }) {
  //   if (isLoading != null) _isLoading = isLoading;
  //   if (summary != null) _summary = summary;
  //   if (error != null) _error = error;
  //   notifyListeners();
  // }
}
