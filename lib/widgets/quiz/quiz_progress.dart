// widgets/quiz/quiz_progress.dart
import 'package:flutter/material.dart';

class QuizProgress extends StatelessWidget {
  final int answeredCount;
  final int totalQuestions;
  final int score;
  final bool answersChecked;

  const QuizProgress({
    super.key,
    required this.answeredCount,
    required this.totalQuestions,
    required this.score,
    required this.answersChecked,
  });

  @override
  Widget build(BuildContext context) {
    final progress = answeredCount / totalQuestions;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Progress Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Questions: $totalQuestions',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
                Text(
                  'Answered: $answeredCount/$totalQuestions',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),

          // Progress Bar
          Expanded(
            flex: 2,
            child: Container(
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(3),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8A2BE2), Color(0xFF6A0DAD)],
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),

          // Score
          Text(
            answersChecked ? '$score/$totalQuestions' : '0/$totalQuestions',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF8A2BE2),
            ),
          ),
        ],
      ),
    );
  }
}
