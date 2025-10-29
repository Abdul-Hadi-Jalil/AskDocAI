import 'dart:async';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:doc_text_extractor/doc_text_extractor.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:docusense_ai/providers/file_state.dart';

class FileHelper {
  // this function will allow user to select a file from device and extract the text from it
  static Future<String?> pickAndReadFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['txt', 'docx', 'doc', 'pdf', 'md'],
      type: FileType.custom,
    );

    if (result == null) {
      return null; // User canceled
    }

    final file = result.files.first;
    String? content;

    if (file.extension == "txt" && file.bytes != null) {
      content = utf8.decode(file.bytes!);
    } else if (file.extension == "pdf" && file.path != null) {
      try {
        final extractor = TextExtractor();
        final result = await extractor.extractText(file.path!, isUrl: false);
        content = result.text;
      } catch (e) {
        print('Failed to read PDF: $e');
      }
    } else if (file.extension == "docx" || file.extension == "doc") {
      final extractor = TextExtractor();
      final result = await extractor.extractText(file.path!, isUrl: false);
      content = result.text;
    }

    if (content != null && content.isNotEmpty) {
      // Update FileState using Provider
      context.read<FileState>().setFile(file.name, content);
    }

    return content;
  }

  // Function to create chunks of the file content
  // Function to create chunks of ~100 words ending at full stops
  static List<String> createChunks(String content, {int wordsPerChunk = 100}) {
    if (content.trim().isEmpty) return [];

    // Normalize text and split into sentences
    final cleaned = content.replaceAll(RegExp(r'\s+'), ' ').trim();
    final sentences = cleaned.split(
      RegExp(r'(?<=[.!?])\s+'),
    ); // split by punctuation + space

    List<String> chunks = [];
    List<String> currentWords = [];

    for (var sentence in sentences) {
      final words = sentence.split(' ');

      // Add sentence words
      currentWords.addAll(words);

      // If current chunk exceeds limit, close it here
      if (currentWords.length >= wordsPerChunk) {
        chunks.add(currentWords.join(' ').trim());
        currentWords.clear();
      }
    }

    // Add remaining words as the final chunk
    if (currentWords.isNotEmpty) {
      chunks.add(currentWords.join(' ').trim());
    }

    return chunks;
  }
}
