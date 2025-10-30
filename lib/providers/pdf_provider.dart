import 'package:docusense_ai/providers/file_provider.dart';
import 'package:docusense_ai/utils/file_helper.dart';
import 'package:flutter/material.dart';
import '../models/app_state.dart';

class PdfProvider extends ChangeNotifier {
  AppState _state = const AppState();
  BuildContext? _context;
  final FileProvider _fileProvider; // Add file provider dependency

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

  // Updated method that works with your existing FileHelper
  Future<void> selectAndUploadFile() async {
    if (_context == null) return;

    try {
      final content = await FileHelper.pickAndReadFile(_context!);

      if (content != null && content.isNotEmpty) {
        // FileHelper doesn't return the file name, so we'll use a placeholder
        // You can modify this later if you update FileHelper
        _fileProvider.setFile(
          'uploaded_document.pdf', // Default name
          content,
          path: 'local_file',
        );

        // Show success message
        if (_context != null && _context!.mounted) {
          ScaffoldMessenger.of(_context!).showSnackBar(
            const SnackBar(
              content: Text('File loaded successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else if (content == null) {
        // User canceled
        if (_context != null && _context!.mounted) {
          ScaffoldMessenger.of(_context!).showSnackBar(
            const SnackBar(content: Text('File selection canceled')),
          );
        }
      } else {
        // Empty content
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
