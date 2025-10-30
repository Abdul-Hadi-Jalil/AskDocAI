import 'package:flutter/material.dart';

class FileProvider extends ChangeNotifier {
  String? _fileName;
  String? _fileContent;
  String? _filePath;

  String? get fileName => _fileName;
  String? get fileContent => _fileContent;
  String? get filePath => _filePath;

  bool get hasFile => _fileName != null && _fileContent != null;

  void setFile(String name, String content, {String? path}) {
    _fileName = name;
    _fileContent = content;
    _filePath = path;
    notifyListeners();
  }

  void clearFile() {
    _fileName = null;
    _fileContent = null;
    _filePath = null;
    notifyListeners();
  }

  // Helper to update file name if needed
  void updateFileName(String newName) {
    _fileName = newName;
    notifyListeners();
  }
}
