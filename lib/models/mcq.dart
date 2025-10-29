import 'dart:convert';

import 'package:flutter/material.dart';

class MCQ {
  final String question;
  final Map<String, String> options;
  final String correctAnswer;
  final String hint;
  final Map<String, String> wrongReasons;

  MCQ({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.hint,
    required this.wrongReasons,
  });

  factory MCQ.fromJson(Map<String, dynamic> json) {
    return MCQ(
      question: json['question'] ?? 'No question',
      options: Map<String, String>.from(json['options'] ?? {}),
      correctAnswer: json['correct_answer'] ?? 'A',
      hint: json['hint'] ?? 'No hint available',
      wrongReasons: Map<String, String>.from(json['wrong_reasons'] ?? {}),
    );
  }

  static List<MCQ> listFromJson(String jsonString) {
    try {
      // Clean the response - remove markdown code blocks
      String cleanJson = jsonString.trim();

      // Remove ```json and ``` markers
      if (cleanJson.startsWith('```json')) {
        cleanJson = cleanJson.substring(7); // Remove ```json
      }
      if (cleanJson.endsWith('```')) {
        cleanJson = cleanJson.substring(0, cleanJson.length - 3); // Remove ```
      }
      cleanJson = cleanJson.trim();

      debugPrint('🧹 Cleaned JSON: $cleanJson');

      final data = jsonDecode(cleanJson);
      final List quizList = data['quiz'] ?? [];

      debugPrint('📊 Found ${quizList.length} questions');

      return quizList.map((e) => MCQ.fromJson(e)).toList();
    } catch (e) {
      debugPrint('❌ JSON parsing error: $e');
      debugPrint('🚨 Raw response was: $jsonString');
      rethrow;
    }
  }
}
