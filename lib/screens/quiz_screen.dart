// screens/quiz_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pdf_provider.dart';
import '../models/mcq.dart';
import '../widgets/quiz/mcq_widget.dart';
import '../widgets/quiz/results_banner.dart';

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

  @override
  void initState() {
    super.initState();
    _generateQuiz();
  }

  Future<void> _generateQuiz() async {
    setState(() {
      _isLoading = true;
      _answersChecked = false;
      _userAnswers.clear();
    });

    // Simulate API call to generate quiz
    await Future.delayed(const Duration(seconds: 1));

    // Sample quiz data - in real app, this would come from your AI service
    final sampleQuiz = [
      MCQ(
        question:
            "What is the primary benefit of AI-powered personalized learning mentioned in the document?",
        options: {
          "A": "Reduces educational costs",
          "B": "Increases student engagement",
          "C": "Eliminates the need for teachers",
          "D": "Standardizes curriculum globally",
        },
        correctAnswer: "B",
        hint:
            "The document mentions a specific percentage increase when discussing this benefit in section 3.2.",
        wrongReasons: {
          "A":
              "While cost reduction is mentioned as a secondary benefit, it's not highlighted as the primary advantage.",
          "C":
              "The document emphasizes that teachers remain essential, with AI serving as a tool to enhance their effectiveness.",
          "D":
              "Personalized learning customizes education to individual needs rather than standardizing it.",
        },
      ),
      MCQ(
        question:
            "According to the document, what percentage of teacher workload reduction is achieved through automated assessment tools?",
        options: {"A": "35%", "B": "47%", "C": "62%", "D": "75%"},
        correctAnswer: "C",
        hint:
            "This statistic is mentioned in the section discussing efficiency improvements for educators.",
        wrongReasons: {
          "A":
              "35% is mentioned as the average time savings for administrative tasks, not assessment specifically.",
          "B":
              "47% is the engagement increase from personalized learning, not workload reduction.",
          "D":
              "75% is not mentioned in the document; this appears to be an exaggerated figure.",
        },
      ),
      MCQ(
        question:
            "What is identified as the primary barrier to AI adoption in education?",
        options: {
          "A": "High implementation costs",
          "B": "Lack of technical expertise",
          "C": "Resistance from teachers",
          "D": "Ethical concerns around data privacy",
        },
        correctAnswer: "D",
        hint:
            "This barrier is discussed in the 'Challenges and Considerations' section.",
        wrongReasons: {
          "A":
              "While costs are mentioned as a challenge, they are secondary to ethical considerations.",
          "B":
              "Technical expertise is noted as a solvable problem through training.",
          "C":
              "Teacher resistance is mentioned but described as decreasing with proper training.",
        },
      ),
      MCQ(
        question:
            "How accurate are predictive analytics in identifying at-risk students according to the document?",
        options: {
          "A": "72% accuracy",
          "B": "89% accuracy",
          "C": "65% accuracy",
          "D": "95% accuracy",
        },
        correctAnswer: "B",
        hint:
            "This accuracy rate is specified in the section about early intervention systems.",
        wrongReasons: {
          "A":
              "72% is the accuracy rate mentioned for a different predictive model in an older study.",
          "C":
              "65% is below the documented accuracy and represents less reliable traditional methods.",
          "D":
              "95% is an exaggerated figure not supported by the research presented.",
        },
      ),
      MCQ(
        question:
            "What approach does the document recommend for AI implementation in education?",
        options: {
          "A": "Immediate full-scale implementation",
          "B": "Phased approach starting with pilot programs",
          "C": "Outsourcing to third-party vendors",
          "D": "Waiting for regulatory guidelines",
        },
        correctAnswer: "B",
        hint:
            "The recommendation appears in the 'Implementation Strategy' section.",
        wrongReasons: {
          "A":
              "Full-scale implementation is cautioned against due to complexity and potential disruption.",
          "C":
              "Outsourcing is mentioned as an option but not as the primary recommended approach.",
          "D":
              "Waiting for regulations is discouraged as the field is evolving rapidly.",
        },
      ),
    ];

    setState(() {
      _mcqs.clear();
      _mcqs.addAll(sampleQuiz);
      _isLoading = false;
    });
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
            'Please answer all $totalQuestions questions. You have answered $answeredCount.',
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

  @override
  Widget build(BuildContext context) {
    final pdfProvider = Provider.of<PdfProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading ? _buildLoading() : _buildQuizContent(pdfProvider),
    );
  }

  Widget _buildAppBar(PdfProvider pdfProvider) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          // Logo
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8A2BE2), Color(0xFF6A0DAD)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'P',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'ChatPDF',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF333333),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF8A2BE2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Sign In',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileHeader(PdfProvider pdfProvider) {
    return Container(
      color: const Color(0xFFF9F7FC),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          // File Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8A2BE2), Color(0xFF6A0DAD)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.picture_as_pdf,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          // File Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pdfProvider.uploadedFileName ?? 'research_paper.pdf',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                const Text(
                  '2.4 MB • 24 pages',
                  style: TextStyle(fontSize: 12, color: Color(0xFF777777)),
                ),
              ],
            ),
          ),
          // File Actions
          Row(
            children: [
              IconButton(
                onPressed: () {
                  // Change file action
                  _generateQuiz();
                },
                icon: const Icon(
                  Icons.swap_horiz,
                  color: Color(0xFF8A2BE2),
                  size: 20,
                ),
              ),
              IconButton(
                onPressed: () {
                  // File info action
                  _showFileInfo();
                },
                icon: const Icon(
                  Icons.info_outline,
                  color: Color(0xFF8A2BE2),
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return const Column(
      children: [
        // App Bar (fixed during loading)
        _QuizAppBar(),
        // Loading content
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8A2BE2)),
                ),
                SizedBox(height: 16),
                Text(
                  'Generating quiz...',
                  style: TextStyle(color: Color(0xFF666666), fontSize: 16),
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
        // Fixed App Bar
        _buildAppBar(pdfProvider),

        // Fixed File Header
        _buildFileHeader(pdfProvider),

        // Scrollable Quiz Content
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Quiz Header
                Container(
                  padding: const EdgeInsets.all(20),
                  child: const Column(
                    children: [
                      Text(
                        'Document Quiz',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF333333),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Test your understanding of the document',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF777777),
                        ),
                      ),
                    ],
                  ),
                ),

                // Results Banner (scrolls with content)
                if (_answersChecked)
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
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                  child: Row(
                    children: [
                      // Regenerate Quiz Button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _generateQuiz,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF8A2BE2),
                            side: const BorderSide(color: Color(0xFF8A2BE2)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.refresh, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Regenerate Quiz',
                                style: TextStyle(fontWeight: FontWeight.w600),
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
                                _answersChecked ? 'Try Again' : 'Check Answers',
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

  void _showFileInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('File Information'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: research_paper.pdf'),
            Text('Size: 2.4 MB'),
            Text('Author: Dr. Emily Johnson'),
            Text('Quiz Questions: 5'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// Separate app bar widget for loading state
class _QuizAppBar extends StatelessWidget {
  const _QuizAppBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8A2BE2), Color(0xFF6A0DAD)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'P',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'ChatPDF',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF333333),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF8A2BE2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Sign In',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
