import 'dart:math';
import 'package:docusense_ai/models/mcq.dart';
import 'package:docusense_ai/utils/gemini_service.dart';
import 'package:flutter/material.dart';
import 'package:docusense_ai/providers/file_state.dart';
import 'package:provider/provider.dart';
import '../utils/file_helper.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<MCQ>? _mcqs;
  Map<int, String?> _selectedAnswers = {};
  bool _showResults = false;
  bool _isGenerating = false;

  // function to handle the quiz generation logic.
  Future<void> handleQuizGeneration(BuildContext context) async {
    setState(() {
      _isGenerating = true;
      _mcqs = null;
      _selectedAnswers = {};
      _showResults = false;
    });

    final fileState = context.read<FileState>();
    final fileContent = fileState.uploadedFileContent;

    // Ensure file is available
    if (fileContent == null || fileContent.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a file first')),
      );
      setState(() {
        _isGenerating = false;
      });
      return;
    }

    // Create chunks from file
    final List<String> chunks = FileHelper.createChunks(fileContent);

    if (chunks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No readable content found in file')),
      );
      setState(() {
        _isGenerating = false;
      });
      return;
    }

    // Pick a random chunk
    final randomChunk = chunks[Random().nextInt(chunks.length)];

    try {
      // Send chunk to Gemini
      debugPrint('🚀 Sending request to Gemini...');
      final quizResponse = await generateQuiz(fileContent: randomChunk);

      //debugPrint("📥 Raw quiz response: ${quizResponse.toString()}");
      //debugPrint('📏 Response length: ${quizResponse.length}');

      // Check if response contains error markers
      if (quizResponse.contains('Sorry, I couldn\'t process that request') ||
          quizResponse.contains('GenerativeAIException')) {
        throw Exception('Gemini API returned an error: $quizResponse');
      }

      if (quizResponse.isEmpty) {
        throw Exception('Empty response from Gemini API');
      }

      // Decode JSON and map to MCQ objects
      debugPrint('🔄 Parsing JSON response...');
      final List<MCQ> mcqs = MCQ.listFromJson(quizResponse);

      if (mcqs.isEmpty) {
        throw Exception('No valid questions found in response');
      }

      setState(() {
        _mcqs = mcqs;
        _selectedAnswers = {};
        _showResults = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Generated ${mcqs.length} questions successfully!'),
        ),
      );
    } catch (e) {
      //debugPrint('❌ Quiz generation failed: $e');
      //debugPrint('🚨 Error type: ${e.runtimeType}');

      String errorMessage = 'Failed to generate quiz';
      if (e is FormatException) {
        errorMessage = 'Invalid response format from AI service';
      } else if (e.toString().contains('GenerativeAIException')) {
        errorMessage = 'AI service error - please check your API configuration';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  void _checkAnswers() {
    setState(() {
      _showResults = true;
    });
  }

  void _resetQuiz() {
    setState(() {
      _selectedAnswers = {};
      _showResults = false;
    });
  }

  bool get _allQuestionsAnswered {
    if (_mcqs == null) return false;
    return _selectedAnswers.length == _mcqs!.length &&
        _selectedAnswers.values.every((answer) => answer != null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Generator'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Generate Quiz Button
            ElevatedButton(
              onPressed: _isGenerating
                  ? null
                  : () => handleQuizGeneration(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isGenerating
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text('Generating Quiz...'),
                      ],
                    )
                  : const Text(
                      'Generate Quiz',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),

            const SizedBox(height: 20),

            // Quiz Content
            if (_mcqs == null && !_isGenerating)
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.quiz, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No quiz generated yet',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Click "Generate Quiz" to create questions from your document',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              )
            else if (_mcqs != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Quiz Questions
                      ..._mcqs!.asMap().entries.map((entry) {
                        final index = entry.key;
                        final mcq = entry.value;
                        return _MCQCard(
                          mcq: mcq,
                          index: index,
                          selectedAnswer: _selectedAnswers[index],
                          showResults: _showResults,
                          onAnswerSelected: (answer) {
                            setState(() {
                              _selectedAnswers[index] = answer;
                            });
                          },
                        );
                      }),

                      const SizedBox(height: 20),

                      // Check Answers Button
                      if (!_showResults && _mcqs != null)
                        ElevatedButton(
                          onPressed: _allQuestionsAnswered
                              ? _checkAnswers
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Check Answers',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                      // Show Results and Regenerate Button
                      if (_showResults) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _resetQuiz,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Try Again'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => handleQuizGeneration(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Regenerate Quiz'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MCQCard extends StatefulWidget {
  final MCQ mcq;
  final int index;
  final String? selectedAnswer;
  final bool showResults;
  final Function(String) onAnswerSelected;

  const _MCQCard({
    required this.mcq,
    required this.index,
    required this.selectedAnswer,
    required this.showResults,
    required this.onAnswerSelected,
  });

  @override
  State<_MCQCard> createState() => _MCQCardState();
}

class _MCQCardState extends State<_MCQCard> {
  bool _showHint = false;

  Color _getOptionColor(String optionKey) {
    if (!widget.showResults) {
      return widget.selectedAnswer == optionKey
          ? Colors.blue[100]!
          : Colors.grey[100]!;
    }

    if (optionKey == widget.mcq.correctAnswer) {
      return Colors.green[100]!;
    } else if (optionKey == widget.selectedAnswer &&
        widget.selectedAnswer != widget.mcq.correctAnswer) {
      return Colors.red[100]!;
    }
    return Colors.grey[100]!;
  }

  Color _getOptionTextColor(String optionKey) {
    if (!widget.showResults) {
      return Colors.black;
    }

    if (optionKey == widget.mcq.correctAnswer) {
      return Colors.green[800]!;
    } else if (optionKey == widget.selectedAnswer &&
        widget.selectedAnswer != widget.mcq.correctAnswer) {
      return Colors.red[800]!;
    }
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Q${widget.index + 1}. ${widget.mcq.question}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // Hint Button
                IconButton(
                  icon: Icon(
                    Icons.lightbulb_outline,
                    color: _showHint ? Colors.orange : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _showHint = !_showHint;
                    });
                  },
                  tooltip: 'Show Hint',
                ),
              ],
            ),

            // Hint Section
            if (_showHint)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(top: 8, bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Text(
                  widget.mcq.hint,
                  style: TextStyle(
                    color: Colors.orange[800],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),

            const SizedBox(height: 12),

            // Options
            ...widget.mcq.options.entries.map((option) {
              final optionKey = option.key;
              final optionValue = option.value;
              final isCorrect = optionKey == widget.mcq.correctAnswer;
              final isSelected = widget.selectedAnswer == optionKey;
              final isWrongSelected = isSelected && !isCorrect;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: _getOptionColor(optionKey),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: widget.showResults && isCorrect
                        ? Colors.green
                        : widget.showResults && isWrongSelected
                        ? Colors.red
                        : Colors.grey[300]!,
                    width: widget.showResults && (isCorrect || isWrongSelected)
                        ? 2
                        : 1,
                  ),
                ),
                child: RadioListTile<String>(
                  title: Text(
                    optionValue,
                    style: TextStyle(
                      color: _getOptionTextColor(optionKey),
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  value: optionKey,
                  groupValue: widget.selectedAnswer,
                  onChanged: widget.showResults
                      ? null
                      : (value) {
                          widget.onAnswerSelected(value!);
                        },
                  activeColor: widget.showResults
                      ? (isCorrect ? Colors.green : Colors.red)
                      : Colors.blue,
                ),
              );
            }),

            // Wrong Reason
            if (widget.showResults &&
                widget.selectedAnswer != null &&
                widget.selectedAnswer != widget.mcq.correctAnswer)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Why this is wrong:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.mcq.wrongReasons[widget.selectedAnswer] ??
                          'No explanation available',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),

            // Correct Answer Explanation
            if (widget.showResults)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Correct Answer:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.mcq.options[widget.mcq.correctAnswer] ??
                          widget.mcq.correctAnswer,
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
