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
      // Clean the response - remove markdown code blocks and extra whitespace
      String cleanJson = jsonString.trim();

      // Remove ```json and ``` markers if present
      if (cleanJson.startsWith('```json')) {
        cleanJson = cleanJson.substring(7);
      } else if (cleanJson.startsWith('```')) {
        cleanJson = cleanJson.substring(3);
      }

      if (cleanJson.endsWith('```')) {
        cleanJson = cleanJson.substring(0, cleanJson.length - 3);
      }

      cleanJson = cleanJson.trim();

      debugPrint('🧹 Cleaned JSON: $cleanJson');

      final data = jsonDecode(cleanJson);
      final List quizList = data['quiz'] ?? [];

      if (quizList.isEmpty) {
        throw Exception('No quiz questions found in response');
      }

      debugPrint('📊 Found ${quizList.length} questions');

      return quizList.map((e) => MCQ.fromJson(e)).toList();
    } catch (e) {
      debugPrint('❌ JSON parsing error: $e');
      debugPrint('🚨 Raw response was: $jsonString');
      rethrow;
    }
  }
}
