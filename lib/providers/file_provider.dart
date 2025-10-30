// providers/file_provider.dart
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FileProvider extends ChangeNotifier {
  String? _fileName;
  String? _fileContent;
  String? _filePath;
  int? _fileSize; // Add file size in bytes
  PlatformFile? _platformFile; // Store the actual platform file

  String? get fileName => _fileName;
  String? get fileContent => _fileContent;
  String? get filePath => _filePath;
  int? get fileSize => _fileSize; // Getter for file size
  PlatformFile? get platformFile => _platformFile;

  bool get hasFile => _fileName != null && _fileContent != null;

  // Format file size to human readable format
  String get formattedFileSize {
    if (_fileSize == null) return 'Unknown size';

    const units = ['B', 'KB', 'MB', 'GB'];
    double size = _fileSize!.toDouble();
    int unitIndex = 0;

    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }

    return '${size.toStringAsFixed(1)} ${units[unitIndex]}';
  }

  // Get page count (you can implement this later with PDF parsing)
  String get pageCount {
    // For now, return a placeholder. You can implement actual PDF page counting later.
    return 'Calculating pages...';
  }

  void setFile(
    String name,
    String content, {
    String? path,
    int? size,
    PlatformFile? platformFile,
  }) {
    _fileName = name;
    _fileContent = content;
    _filePath = path;
    _fileSize = size;
    _platformFile = platformFile;
    notifyListeners();
  }

  void clearFile() {
    _fileName = null;
    _fileContent = null;
    _filePath = null;
    _fileSize = null;
    _platformFile = null;
    notifyListeners();
  }

  // Helper to update file name if needed
  void updateFileName(String newName) {
    _fileName = newName;
    notifyListeners();
  }
}
