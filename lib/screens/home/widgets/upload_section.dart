import 'package:docusense_ai/app_localization.dart';
import 'package:docusense_ai/providers/auth_state.dart';
import 'package:docusense_ai/screens/signin_screen.dart' as signin;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/pdf_provider.dart';
import '../../../providers/file_provider.dart';
import '../../../utils/constants.dart';

class UploadSection extends StatefulWidget {
  const UploadSection({super.key});

  @override
  State<UploadSection> createState() => _UploadSectionState();
}

class _UploadSectionState extends State<UploadSection> {
  @override
  Widget build(BuildContext context) {
    final pdfProvider = Provider.of<PdfProvider>(context);
    final fileProvider = Provider.of<FileProvider>(context);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppConstants.primaryColor.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(color: AppConstants.borderColor, width: 1),
          ),
          child: Column(
            children: [
              // Upload Area
              GestureDetector(
                onTap: () => _handleUpload(pdfProvider, context),
                child: Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppConstants.borderColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      // Simple loading icon
                      if (pdfProvider.isProcessingFile)
                        const SizedBox(
                          width: 48,
                          height: 48,
                          child: CircularProgressIndicator(),
                        )
                      else
                        Icon(
                          Icons.cloud_upload_outlined,
                          size: 48,
                          color: AppConstants.primaryColor,
                        ),
                      const SizedBox(height: 15),
                      Text(
                        pdfProvider.isProcessingFile
                            ? 'Uploading...'
                            : AppLocalizations.of(context).uploadPdf,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppConstants.textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        pdfProvider.isProcessingFile
                            ? 'Please wait'
                            : AppLocalizations.of(context).tapToSelectFile,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppConstants.subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Simple loading indicator
              if (pdfProvider.isProcessingFile) ...[
                const Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Loading your file...',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ],

              // Upload Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: pdfProvider.isProcessingFile
                      ? null
                      : () => _handleUpload(pdfProvider, context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                    shadowColor: AppConstants.primaryColor.withOpacity(0.3),
                  ),
                  child: pdfProvider.isProcessingFile
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Loading...',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_upload, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context).uploadPdf,
                              style: const TextStyle(
                                fontSize: 16,
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
        const SizedBox(height: 20),

        // File Status Section
        if (fileProvider.hasFile && !pdfProvider.isProcessingFile)
          _buildFileStatusSection(fileProvider),
      ],
    );
  }

  void _handleUpload(PdfProvider pdfProvider, BuildContext context) {
    final authState = Provider.of<AuthState>(context, listen: false);

    if (!authState.isUserSignedIn) {
      signin.showSignInDialog(context);
    } else {
      pdfProvider.selectAndUploadFile();
    }
  }

  Widget _buildFileStatusSection(FileProvider fileProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.lightPurple,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: AppConstants.primaryColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'File Selected',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  fileProvider.fileName!,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppConstants.subtitleColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (fileProvider.fileSize != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    fileProvider.formattedFileSize,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppConstants.subtitleColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              fileProvider.clearFile();
              fileProvider.clearSelection();
            },
            icon: Icon(Icons.close, color: AppConstants.subtitleColor),
          ),
        ],
      ),
    );
  }
}
