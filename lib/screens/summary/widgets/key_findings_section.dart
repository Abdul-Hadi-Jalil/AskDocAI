import 'package:docusense_ai/app_localization.dart';
import 'package:docusense_ai/utils/constants.dart';
import 'package:flutter/material.dart';
import 'key_point_item.dart';

class KeyFindingsSection extends StatelessWidget {
  final String content;

  const KeyFindingsSection({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final points = _extractBulletPoints(content);

    return Container(
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
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppConstants.lightPurple,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.flag_outlined,
                  color: AppConstants.primaryColor,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context).keyFindings,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ...points.map((point) => KeyPointItem(text: point)),
        ],
      ),
    );
  }

  List<String> _extractBulletPoints(String content) {
    return content
        .split('\n')
        .where(
          (line) => line.trim().startsWith('-') || line.trim().startsWith('•'),
        )
        .map((line) => line.replaceFirst(RegExp(r'^[-\•]\s*'), '').trim())
        .where((point) => point.isNotEmpty)
        .toList();
  }
}
