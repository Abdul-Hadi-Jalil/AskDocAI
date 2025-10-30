import 'package:docusense_ai/providers/file_provider.dart';
import 'package:docusense_ai/utils/file_helper.dart';
import 'package:file_picker/file_picker.dart';
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
  // In PdfProvider - update the selectAndUploadFile method
  Future<void> selectAndUploadFile() async {
    if (_context == null) return;

    try {
      // Use FilePicker to get the actual file with metadata
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'txt', 'doc', 'docx', 'md'],
      );

      if (result != null && result.files.single.path != null) {
        PlatformFile file = result.files.first;

        // Extract text content using your existing FileHelper
        final content = await FileHelper.pickAndReadFile(_context!);

        if (content != null && content.isNotEmpty) {
          // Set file with real metadata
          _fileProvider.setFile(
            file.name, // Real file name
            content,
            path: file.path,
            size: file.size, // Real file size in bytes
            platformFile: file, // Store the platform file
          );

          // Show success message
          if (_context != null && _context!.mounted) {
            ScaffoldMessenger.of(_context!).showSnackBar(
              SnackBar(
                content: Text('${file.name} loaded successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else if (content == null) {
          // User canceled or error reading
          if (_context != null && _context!.mounted) {
            ScaffoldMessenger.of(_context!).showSnackBar(
              const SnackBar(content: Text('Could not read file content')),
            );
          }
        }
      } else {
        // User canceled file selection
        if (_context != null && _context!.mounted) {
          ScaffoldMessenger.of(_context!).showSnackBar(
            const SnackBar(content: Text('File selection canceled')),
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
