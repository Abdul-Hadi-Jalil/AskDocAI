import 'package:docusense_ai/app_localization.dart';
import 'package:flutter/material.dart';

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              AppLocalizations.of(context).whatYouCanDo,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF333333),
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Features Cards
          const _FeaturesGrid(),
        ],
      ),
    );
  }
}

class _FeaturesGrid extends StatelessWidget {
  const _FeaturesGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // For mobile devices, use a single column
        if (constraints.maxWidth < 600) {
          return const _FeaturesColumn();
        }
        // For larger screens, use a row
        return const _FeaturesRow();
      },
    );
  }
}

class _FeaturesColumn extends StatelessWidget {
  const _FeaturesColumn();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _FeatureCard(
          icon: Icons.chat_bubble_outline,
          titleKey: 'chat',
          descriptionKey: 'chatDescription',
          color: Color(0xFF8A2BE2),
        ),
        SizedBox(height: 16),
        _FeatureCard(
          icon: Icons.summarize_outlined,
          titleKey: 'summary',
          descriptionKey: 'summaryDescription',
          color: Color(0xFF6A0DAD),
        ),
        SizedBox(height: 16),
        _FeatureCard(
          icon: Icons.quiz_outlined,
          titleKey: 'quiz',
          descriptionKey: 'quizDescription',
          color: Color(0xFF9C4DF4),
        ),
      ],
    );
  }
}

class _FeaturesRow extends StatelessWidget {
  const _FeaturesRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _FeatureCard(
            icon: Icons.chat_bubble_outline,
            titleKey: 'chat',
            descriptionKey: 'chatDescription',
            color: Color(0xFF8A2BE2),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _FeatureCard(
            icon: Icons.summarize_outlined,
            titleKey: 'summary',
            descriptionKey: 'summaryDescription',
            color: Color(0xFF6A0DAD),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _FeatureCard(
            icon: Icons.quiz_outlined,
            titleKey: 'quiz',
            descriptionKey: 'quizDescription',
            color: Color(0xFF9C4DF4),
          ),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String titleKey;
  final String descriptionKey;
  final Color color;

  const _FeatureCard({
    required this.icon,
    required this.titleKey,
    required this.descriptionKey,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFF0EAFA), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 32, color: color),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            _getLocalizedText(context, titleKey),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Description
          Text(
            _getLocalizedText(context, descriptionKey),
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getLocalizedText(BuildContext context, String key) {
    final appLocalizations = AppLocalizations.of(context);
    switch (key) {
      case 'chat':
        return appLocalizations.chat;
      case 'chatDescription':
        return appLocalizations.chatDescription;
      case 'summary':
        return appLocalizations.summary;
      case 'summaryDescription':
        return appLocalizations.summaryDescription;
      case 'quiz':
        return appLocalizations.quiz;
      case 'quizDescription':
        return appLocalizations.quizDescription;
      case 'whatYouCanDo':
        return appLocalizations.whatYouCanDo;
      default:
        return key;
    }
  }
}
