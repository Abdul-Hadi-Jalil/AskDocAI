// widgets/quiz/mcq_widget.dart
import 'package:flutter/material.dart';
import '../../models/mcq.dart';

class MCQWidget extends StatefulWidget {
  final MCQ mcq;
  final int questionNumber;
  final String? userAnswer;
  final bool answersChecked;
  final Function(String) onAnswerSelected;

  const MCQWidget({
    super.key,
    required this.mcq,
    required this.questionNumber,
    required this.userAnswer,
    required this.answersChecked,
    required this.onAnswerSelected,
  });

  @override
  State<MCQWidget> createState() => _MCQWidgetState();
}

class _MCQWidgetState extends State<MCQWidget> {
  bool _showHint = false;

  @override
  Widget build(BuildContext context) {
    final isCorrect = widget.userAnswer == widget.mcq.correctAnswer;
    final showResults = widget.answersChecked && widget.userAnswer != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Question ${widget.questionNumber}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF8A2BE2),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.mcq.question,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _showHint = !_showHint;
                  });
                },
                icon: const Icon(
                  Icons.lightbulb_outline,
                  color: Color(0xFF8A2BE2),
                  size: 20,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // Options
          Column(
            children: widget.mcq.options.entries.map((entry) {
              final optionLetter = entry.key;
              final optionText = entry.value;
              final isSelected = widget.userAnswer == optionLetter;
              final isCorrectOption = optionLetter == widget.mcq.correctAnswer;

              Color borderColor = const Color(0xFFF0F0F0);
              Color backgroundColor = Colors.transparent;
              Color letterColor = const Color(0xFF666666);
              Color textColor = const Color(0xFF333333);

              if (showResults) {
                if (isCorrectOption) {
                  borderColor = const Color(0xFF4CAF50);
                  backgroundColor = const Color(0xFFE8F5E8);
                  letterColor = Colors.white;
                } else if (isSelected && !isCorrect) {
                  borderColor = const Color(0xFFF44336);
                  backgroundColor = const Color(0xFFFFEBEE);
                  letterColor = Colors.white;
                }
              } else if (isSelected) {
                borderColor = const Color(0xFF8A2BE2);
                backgroundColor = const Color(0xFFF0EAFA);
                letterColor = Colors.white;
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Material(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: () => widget.onAnswerSelected(optionLetter),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: borderColor, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          // Option Letter
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: letterColor == Colors.white
                                  ? borderColor
                                  : const Color(0xFFF0F0F0),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: Text(
                                optionLetter,
                                style: TextStyle(
                                  color: letterColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Option Text
                          Expanded(
                            child: Text(
                              optionText,
                              style: TextStyle(fontSize: 14, color: textColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          // Hint
          if (_showHint) ...[
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFF0EAFA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hint',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8A2BE2),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.mcq.hint,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF555555),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Explanation (shown when answers are checked)
          if (showResults) ...[
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Explanation',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Why correct answer is correct
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Why ${widget.mcq.correctAnswer} is correct:',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF8A2BE2),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _getCorrectExplanation(),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF555555),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // Why other options are incorrect
                  const Text(
                    'Why other options are incorrect:',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8A2BE2),
                    ),
                  ),
                  const SizedBox(height: 5),
                  ...widget.mcq.options.entries
                      .where((entry) => entry.key != widget.mcq.correctAnswer)
                      .map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '• ',
                                style: TextStyle(
                                  color: Color(0xFF8A2BE2),
                                  fontSize: 12,
                                ),
                              ),
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${entry.key}: ',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF555555),
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            widget.mcq.wrongReasons[entry
                                                .key] ??
                                            '',
                                        style: const TextStyle(
                                          color: Color(0xFF555555),
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getCorrectExplanation() {
    // In a real app, you might have this stored in the MCQ model
    // For now, return a generic explanation
    return "This is the correct answer based on the information provided in the document. "
        "The other options contain inaccuracies or misinterpretations of the content.";
  }
}
