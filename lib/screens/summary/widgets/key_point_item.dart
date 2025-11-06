import 'package:docusense_ai/utils/constants.dart';
import 'package:flutter/material.dart';

class KeyPointItem extends StatelessWidget {
  final String text;

  const KeyPointItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(
              Icons.circle,
              size: 8,
              color: AppConstants.primaryColor,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: AppConstants.subtitleColor,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
