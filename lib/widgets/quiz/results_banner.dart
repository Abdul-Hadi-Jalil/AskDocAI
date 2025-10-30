// widgets/quiz/results_banner.dart
import 'package:flutter/material.dart';

class ResultsBanner extends StatelessWidget {
  final int score;
  final int totalQuestions;

  const ResultsBanner({
    super.key,
    required this.score,
    required this.totalQuestions,
  });

  String get _resultsText {
    final percentage = (score / totalQuestions) * 100;
    if (percentage >= 80) {
      return "Excellent! You have a strong understanding of the document.";
    } else if (percentage >= 60) {
      return "Good job! You have a decent understanding of the document.";
    } else {
      return "Keep studying! Review the document and try again.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8A2BE2), Color(0xFF6A0DAD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            '$score/$totalQuestions',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            _resultsText,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
