import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class RecentFile {
  final String name;
  final String path;
  final int size;
  final DateTime uploadDate;
  final String content; // Add content to store file content
  bool isSelected;

  RecentFile({
    required this.name,
    required this.path,
    required this.size,
    required this.uploadDate,
    required this.content, // Add content parameter
    this.isSelected = false,
  });

  RecentFile copyWith({
    String? name,
    String? path,
    int? size,
    DateTime? uploadDate,
    String? content,
    bool? isSelected,
  }) {
    return RecentFile(
      name: name ?? this.name,
      path: path ?? this.path,
      size: size ?? this.size,
      uploadDate: uploadDate ?? this.uploadDate,
      content: content ?? this.content, // Include content in copyWith
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentFile &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          size == other.size;

  @override
  int get hashCode => name.hashCode ^ size.hashCode;
}

class FileProvider extends ChangeNotifier {
  String? _fileName;
  String? _fileContent;
  String? _filePath;
  int? _fileSize;
  PlatformFile? _platformFile;

  // Add recent files list
  List<RecentFile> _recentFiles = [];
  RecentFile? _selectedFile;

  String? get fileName => _fileName;
  String? get fileContent => _fileContent;
  String? get filePath => _filePath;
  int? get fileSize => _fileSize;
  PlatformFile? get platformFile => _platformFile;

  // Add getters for recent files
  List<RecentFile> get recentFiles => _recentFiles;
  RecentFile? get selectedFile => _selectedFile;

  bool get hasFile => _fileName != null && _fileContent != null;

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

  String get pageCount {
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

    // Add to recent files when a new file is set
    if (name.isNotEmpty && size != null) {
      addToRecentFiles(name, path ?? '', size, content);
    }

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

  void updateFileName(String newName) {
    _fileName = newName;
    notifyListeners();
  }

  // Recent Files Management - UPDATED to include content
  void addToRecentFiles(String name, String path, int size, String content) {
    // Create the new file object
    final newFile = RecentFile(
      name: name,
      path: path,
      size: size,
      uploadDate: DateTime.now(),
      content: content, // Store the file content
    );

    // Remove any existing file with the same name AND size
    _recentFiles.removeWhere((file) => file.name == name && file.size == size);

    // Add new file to beginning
    _recentFiles.insert(0, newFile);

    // Keep only last 5 files
    if (_recentFiles.length > 5) {
      _recentFiles = _recentFiles.sublist(0, 5);
    }

    notifyListeners();
  }

  void selectRecentFile(RecentFile file) {
    // Create a new list to ensure proper state updates
    final updatedFiles = <RecentFile>[];

    // Deselect all files and add to new list
    for (var recentFile in _recentFiles) {
      updatedFiles.add(
        recentFile.copyWith(
          isSelected:
              recentFile.name == file.name && recentFile.size == file.size,
        ),
      );
    }

    _recentFiles = updatedFiles;

    // Find the selected file
    final selectedIndex = _recentFiles.indexWhere(
      (f) => f.name == file.name && f.size == file.size,
    );

    if (selectedIndex != -1) {
      _selectedFile = _recentFiles[selectedIndex];

      // Set this as the current file WITH CONTENT
      _fileName = file.name;
      _filePath = file.path;
      _fileSize = file.size;
      _fileContent = file.content; // THIS IS THE KEY - set the file content
    }

    notifyListeners();
  }

  void clearRecentFiles() {
    _recentFiles.clear();
    _selectedFile = null;
    notifyListeners();
  }

  void clearSelection() {
    // Create a new list with all files deselected
    _recentFiles = _recentFiles
        .map((file) => file.copyWith(isSelected: false))
        .toList();

    _selectedFile = null;
    notifyListeners();
  }

  // Helper method to get unique recent files
  List<RecentFile> get uniqueRecentFiles {
    final uniqueFiles = <String, RecentFile>{};
    for (var file in _recentFiles) {
      uniqueFiles['${file.name}_${file.size}'] = file;
    }
    return uniqueFiles.values.toList();
  }
}
