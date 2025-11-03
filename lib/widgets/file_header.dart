import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_localization.dart';
import '../providers/pdf_provider.dart';
import '../utils/constants.dart';

class FileHeader extends StatelessWidget {
  final bool showInfoButton;

  const FileHeader({super.key, this.showInfoButton = true});

  String _calculateFileSize(String? content) {
    if (content == null) return '0 KB';
    final sizeInBytes = content.length * 2;
    if (sizeInBytes < 1024) return '$sizeInBytes B';
    if (sizeInBytes < 1048576) {
      return '${(sizeInBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(sizeInBytes / 1048576).toStringAsFixed(1)} MB';
  }

  void _showFileInfo(BuildContext context) {
    final pdfProvider = context.read<PdfProvider>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).fileInformation),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${AppLocalizations.of(context).name}: ${pdfProvider.uploadedFileName ?? AppLocalizations.of(context).noFile}',
            ),
            Text(
              '${AppLocalizations.of(context).size}: ${_calculateFileSize(pdfProvider.uploadedFileContent)}',
            ),
            Text(AppLocalizations.of(context).fileTypePdf),
            Text(AppLocalizations.of(context).uploadedJustNow),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).ok),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pdfProvider = context.watch<PdfProvider>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.lightPurple,
        border: Border(
          bottom: BorderSide(color: AppConstants.borderColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          // File Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppConstants.primaryColor,
                  AppConstants.secondaryColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
            child: const Icon(
              Icons.picture_as_pdf,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // File Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pdfProvider.uploadedFileName ??
                      AppLocalizations.of(context).noFileSelected,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _calculateFileSize(pdfProvider.uploadedFileContent),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppConstants.subtitleColor,
                  ),
                ),
              ],
            ),
          ),

          // File Actions (optional)
          if (showInfoButton)
            IconButton(
              onPressed: () => _showFileInfo(context),
              icon: const Icon(
                Icons.info_outline,
                color: AppConstants.primaryColor,
              ),
              tooltip: AppLocalizations.of(context).fileInformation,
            ),
        ],
      ),
    );
  }
}
