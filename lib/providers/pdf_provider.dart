// providers/pdf_provider.dart
import 'package:docusense_ai/providers/file_provider.dart';
import 'package:docusense_ai/utils/file_helper.dart';
import 'package:flutter/material.dart';
import '../models/app_state.dart';

class PdfProvider extends ChangeNotifier {
  AppState _state = const AppState();
  BuildContext? _context;
  final FileProvider _fileProvider;

  PdfProvider({required FileProvider fileProvider})
    : _fileProvider = fileProvider;

  AppState get state => _state;

  void setContext(BuildContext context) {
    _context = context;
  }

  BuildContext? get context => _context;

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
    if (_context == null) return;

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

        // Show success message with real file name
        if (_context != null && _context!.mounted) {
          ScaffoldMessenger.of(_context!).showSnackBar(
            SnackBar(
              content: Text('$fileName loaded successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else if (fileInfo == null) {
        // User canceled
        if (_context != null && _context!.mounted) {
          ScaffoldMessenger.of(_context!).showSnackBar(
            const SnackBar(content: Text('File selection canceled')),
          );
        }
      } else {
        // Empty content or read error
        if (_context != null && _context!.mounted) {
          ScaffoldMessenger.of(_context!).showSnackBar(
            const SnackBar(content: Text('Could not read file content')),
          );
        }
      }
    } catch (e) {
      if (_context != null && _context!.mounted) {
        ScaffoldMessenger.of(
          _context!,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  void resetUpload() {
    _fileProvider.clearFile();
    notifyListeners();
  }
}
