// providers/pdf_provider.dart
import 'package:docusense_ai/providers/file_provider.dart';
import 'package:docusense_ai/utils/file_helper.dart';
import 'package:flutter/material.dart';
import '../models/app_state.dart';
import "package:docusense_ai/main.dart";

class PdfProvider extends ChangeNotifier {
  AppState _state = const AppState();
  final FileProvider _fileProvider;
  bool _isProcessingFile = false;

  PdfProvider({required FileProvider fileProvider})
    : _fileProvider = fileProvider;

  AppState get state => _state;
  bool get isProcessingFile => _isProcessingFile;

  // Get file info from file provider
  String? get uploadedFileName => _fileProvider.fileName;
  String? get uploadedFileContent => _fileProvider.fileContent;
  String? get uploadedPdfPath => _fileProvider.filePath;

  BottomNavItem get currentTab => _state.currentTab;

  void changeTab(BottomNavItem tab) {
    _state = _state.copyWith(
      currentTab: tab,
      isChatVisible: tab == BottomNavItem.chat,
    );
    notifyListeners();
  }

  Future<void> selectAndUploadFile() async {
    if (_isProcessingFile) return;

    _setState(isProcessingFile: true);

    try {
      // Use the method that returns both content and file info
      final fileInfo = await FileHelper.pickAndReadFileWithInfo();

      if (fileInfo != null && fileInfo['content'] != null) {
        // Extract values with proper type handling
        final String fileName = fileInfo['name']?.toString() ?? 'document.pdf';
        final String fileContent = fileInfo['content']?.toString() ?? '';
        final String? filePath = fileInfo['path']?.toString();
        final int? fileSize = fileInfo['size'] is int
            ? fileInfo['size'] as int
            : (fileInfo['size'] != null
                  ? int.tryParse(fileInfo['size'].toString())
                  : null);

        // Set file with real metadata
        _fileProvider.setFile(
          fileName, // Real file name
          fileContent, // File content
          path: filePath, // Real file path
          size: fileSize, // Real file size in bytes
        );

        // Show success message using global key
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text('$fileName loaded successfully!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      } else if (fileInfo == null) {
        // User canceled
        scaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(
            content: Text('File selection canceled'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        // Empty content or read error
        scaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(
            content: Text('Could not read file content'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      _setState(isProcessingFile: false);
    }
  }

  void resetUpload() {
    _fileProvider.clearFile();
    notifyListeners();
  }

  void _setState({bool? isProcessingFile}) {
    if (isProcessingFile != null) _isProcessingFile = isProcessingFile;
    notifyListeners();
  }
}
