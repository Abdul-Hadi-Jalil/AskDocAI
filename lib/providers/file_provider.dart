import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class RecentFile {
  final String name;
  final String path;
  final int size;
  final DateTime uploadDate;
  bool isSelected;

  RecentFile({
    required this.name,
    required this.path,
    required this.size,
    required this.uploadDate,
    this.isSelected = false,
  });

  RecentFile copyWith({
    String? name,
    String? path,
    int? size,
    DateTime? uploadDate,
    bool? isSelected,
  }) {
    return RecentFile(
      name: name ?? this.name,
      path: path ?? this.path,
      size: size ?? this.size,
      uploadDate: uploadDate ?? this.uploadDate,
      isSelected: isSelected ?? this.isSelected,
    );
  }
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
    if (path != null && size != null) {
      addToRecentFiles(name, path, size);
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

  // Recent Files Management
  void addToRecentFiles(String name, String path, int size) {
    // Remove if already exists (to update position)
    _recentFiles.removeWhere((file) => file.path == path);

    // Add new file to beginning
    final newFile = RecentFile(
      name: name,
      path: path,
      size: size,
      uploadDate: DateTime.now(),
    );

    _recentFiles.insert(0, newFile);

    // Keep only last 5 files
    if (_recentFiles.length > 5) {
      _recentFiles = _recentFiles.sublist(0, 5);
    }

    notifyListeners();
  }

  void selectRecentFile(RecentFile file) {
    // Deselect all files
    for (var recentFile in _recentFiles) {
      recentFile.isSelected = false;
    }

    // Select the clicked file
    final selectedIndex = _recentFiles.indexWhere((f) => f.path == file.path);
    if (selectedIndex != -1) {
      _recentFiles[selectedIndex] = _recentFiles[selectedIndex].copyWith(
        isSelected: true,
      );
      _selectedFile = _recentFiles[selectedIndex];

      // Set this as the current file
      _fileName = file.name;
      _filePath = file.path;
      _fileSize = file.size;
      // Note: We don't have the file content, but PDF provider will handle loading
    }

    notifyListeners();
  }

  void clearRecentFiles() {
    _recentFiles.clear();
    _selectedFile = null;
    notifyListeners();
  }

  void clearSelection() {
    for (var file in _recentFiles) {
      file.isSelected = false;
    }
    _selectedFile = null;
    notifyListeners();
  }
}
