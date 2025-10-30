import 'package:flutter/material.dart';

@immutable
class AppState {
  final BottomNavItem currentTab;
  final String? uploadedPdfPath;
  final String? uploadedFileName;
  final String? uploadedFileContent;
  final bool isChatVisible; // Keep your existing field

  const AppState({
    this.currentTab = BottomNavItem.home,
    this.uploadedPdfPath,
    this.uploadedFileName,
    this.uploadedFileContent,
    this.isChatVisible = false, // Default value
  });

  AppState copyWith({
    BottomNavItem? currentTab,
    String? uploadedPdfPath,
    String? uploadedFileName,
    String? uploadedFileContent,
    bool? isChatVisible,
  }) {
    return AppState(
      currentTab: currentTab ?? this.currentTab,
      uploadedPdfPath: uploadedPdfPath ?? this.uploadedPdfPath,
      uploadedFileName: uploadedFileName ?? this.uploadedFileName,
      uploadedFileContent: uploadedFileContent ?? this.uploadedFileContent,
      isChatVisible: isChatVisible ?? this.isChatVisible,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppState &&
        other.currentTab == currentTab &&
        other.uploadedPdfPath == uploadedPdfPath &&
        other.uploadedFileName == uploadedFileName &&
        other.uploadedFileContent == uploadedFileContent &&
        other.isChatVisible == isChatVisible;
  }

  @override
  int get hashCode {
    return Object.hash(
      currentTab,
      uploadedPdfPath,
      uploadedFileName,
      uploadedFileContent,
      isChatVisible,
    );
  }
}

enum BottomNavItem { home, chat, summarize, quiz }
