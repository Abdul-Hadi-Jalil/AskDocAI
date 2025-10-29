import 'package:flutter/material.dart';

class FileState with ChangeNotifier {
  String? _uploadedFileName;
  String? _uploadedFileContent;

  String? get uploadedFileName => _uploadedFileName;
  String? get uploadedFileContent => _uploadedFileContent;

  void setFile(String? fileName, String? fileContent) {
    _uploadedFileName = fileName;
    _uploadedFileContent = fileContent;
    notifyListeners();
  }

  void clearFile() {
    _uploadedFileName = null;
    _uploadedFileContent = null;
    notifyListeners();
  }
}
