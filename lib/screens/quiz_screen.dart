import 'package:docusense_ai/app_localization.dart'; // Add this import
import 'package:docusense_ai/utils/gemini_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pdf_provider.dart';
import '../models/mcq.dart';
import '../widgets/quiz/mcq_widget.dart';
import '../widgets/quiz/results_banner.dart';
import '../widgets/app_bar.dart';
import '../widgets/file_header.dart'; // Add this import

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<MCQ> _mcqs = [];
  final Map<int, String?> _userAnswers = {};
  bool _answersChecked = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final pdfProvider = Provider.of<PdfProvider>(context);

    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(),
        backgroundColor: Colors.white,
        body: _isLoading ? _buildLoading() : _buildQuizContent(pdfProvider),
      ),
    );
  }

  Widget _buildLoading() {
    return Column(
      children: [
        const FileHeader(showInfoButton: false),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8A2BE2)),
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context).generatingQuiz,
                  style: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuizContent(PdfProvider pdfProvider) {
    return Column(
      children: [
        // File Header - Using the shared widget
        const FileHeader(showInfoButton: false),

        // Scrollable Quiz Content
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Quiz Header
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context).documentQuiz,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _mcqs.isEmpty
                            ? AppLocalizations.of(
                                context,
                              ).generateQuizDescription
                            : AppLocalizations.of(context).testUnderstanding,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF777777),
                        ),
                      ),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),

                // Generate Quiz Button (when no quiz is generated)
                if (_mcqs.isEmpty && !_isLoading)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () => _generateQuiz(pdfProvider),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8A2BE2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.quiz, size: 20),
                          const SizedBox(width: 12),
                          Text(
                            AppLocalizations.of(
                              context,
                            ).generateQuizFromDocument,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Results Banner (scrolls with content)
                if (_answersChecked && _mcqs.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: ResultsBanner(
                      score: _score,
                      totalQuestions: _mcqs.length,
                    ),
                  ),

                // Questions List
                if (_mcqs.isNotEmpty)
                  ..._mcqs.asMap().entries.map((entry) {
                    final index = entry.key;
                    final mcq = entry.value;
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: MCQWidget(
                        mcq: mcq,
                        questionNumber: index + 1,
                        userAnswer: _userAnswers[index],
                        answersChecked: _answersChecked,
                        onAnswerSelected: (option) =>
                            _selectAnswer(index, option),
                      ),
                    );
                  }),

                // Action Buttons (placed at the end of content)
                if (_mcqs.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                    child: Row(
                      children: [
                        // Regenerate Quiz Button
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _generateQuiz(pdfProvider),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF8A2BE2),
                              side: const BorderSide(color: Color(0xFF8A2BE2)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.refresh, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  AppLocalizations.of(context).regenerateQuiz,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Check Answers Button
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _answersChecked
                                ? _tryAgain
                                : _checkAnswers,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8A2BE2),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 4,
                              shadowColor: const Color(
                                0xFF8A2BE2,
                              ).withOpacity(0.3),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _answersChecked
                                      ? Icons.refresh
                                      : Icons.check_circle,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _answersChecked
                                      ? AppLocalizations.of(context).tryAgain
                                      : AppLocalizations.of(
                                          context,
                                        ).checkAnswers,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
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
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _generateQuiz(PdfProvider pdfProvider) async {
    if (pdfProvider.uploadedFileContent == null ||
        pdfProvider.uploadedFileContent!.isEmpty) {
      setState(() {
        _errorMessage = AppLocalizations.of(context).uploadPdfFirstForQuiz;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _answersChecked = false;
      _userAnswers.clear();
      _errorMessage = null;
    });

    try {
      final quizResponse = await generateQuiz(
        fileContent: pdfProvider.uploadedFileContent,
      );

      if (quizResponse.contains('⚠️') || quizResponse.isEmpty) {
        throw Exception(AppLocalizations.of(context).failedToGenerateQuiz);
      }

      final List<MCQ> generatedMCQs = MCQ.listFromJson(quizResponse);

      if (generatedMCQs.isEmpty) {
        throw Exception(AppLocalizations.of(context).noValidQuizQuestions);
      }

      setState(() {
        _mcqs.clear();
        _mcqs.addAll(generatedMCQs);
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage =
            '${AppLocalizations.of(context).failedToGenerateQuiz}: ${e.toString()}';
        _mcqs.clear();
      });
      print('Error generating quiz: $e');
    }
  }

  void _selectAnswer(int questionIndex, String option) {
    if (_answersChecked) return;

    setState(() {
      _userAnswers[questionIndex] = option;
    });
  }

  void _checkAnswers() {
    final answeredCount = _userAnswers.length;
    final totalQuestions = _mcqs.length;

    if (answeredCount < totalQuestions) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).answerAllQuestions
                .replaceAll('%answered', answeredCount.toString())
                .replaceAll('%total', totalQuestions.toString()),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _answersChecked = true;
    });
  }

  void _tryAgain() {
    setState(() {
      _answersChecked = false;
      _userAnswers.clear();
    });
  }

  int get _score {
    return _userAnswers.entries.fold(0, (score, entry) {
      final questionIndex = entry.key;
      final userAnswer = entry.value;
      final correctAnswer = _mcqs[questionIndex].correctAnswer;
      return userAnswer == correctAnswer ? score + 1 : score;
    });
  }
}
