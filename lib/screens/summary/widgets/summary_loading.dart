import 'package:docusense_ai/app_localization.dart';
import 'package:docusense_ai/utils/constants.dart';
import 'package:flutter/material.dart';

class SummaryLoading extends StatelessWidget {
  const SummaryLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppConstants.primaryColor,
              ),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).analyzingDocument,
            style: const TextStyle(
              color: AppConstants.subtitleColor,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).mayTakeFewMoments,
            style: const TextStyle(
              color: AppConstants.subtitleColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
