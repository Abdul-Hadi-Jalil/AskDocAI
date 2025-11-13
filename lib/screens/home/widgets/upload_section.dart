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
  bool _isLocalLoading = false;
  bool _showFileStatus = false;

  @override
  Widget build(BuildContext context) {
    final pdfProvider = Provider.of<PdfProvider>(context);
    final fileProvider = Provider.of<FileProvider>(context);

    // Combine both loading states
    final bool isLoading = pdfProvider.isProcessingFile || _isLocalLoading;

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
                      color: isLoading
                          ? AppConstants.primaryColor.withOpacity(0.5)
                          : AppConstants.borderColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: isLoading
                        ? AppConstants.primaryColor.withOpacity(0.05)
                        : Colors.white,
                  ),
                  child: Column(
                    children: [
                      // Animated loading icon
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: isLoading
                            ? const SizedBox(
                                width: 48,
                                height: 48,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppConstants.primaryColor,
                                  ),
                                ),
                              )
                            : Icon(
                                Icons.cloud_upload_outlined,
                                size: 48,
                                color: AppConstants.primaryColor,
                              ),
                      ),
                      const SizedBox(height: 15),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          isLoading
                              ? 'Uploading...'
                              : AppLocalizations.of(context).uploadPdf,
                          key: ValueKey(isLoading),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppConstants.textColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          isLoading
                              ? 'Processing your file...'
                              : AppLocalizations.of(context).tapToSelectFile,
                          key: ValueKey(isLoading),
                          style: TextStyle(
                            fontSize: 14,
                            color: AppConstants.subtitleColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Loading indicator with better animation
              if (isLoading) ...[
                AnimatedOpacity(
                  opacity: isLoading ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppConstants.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Loading your file...',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],

              // Upload Button
              AnimatedOpacity(
                opacity: isLoading ? 0.7 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () => _handleUpload(pdfProvider, context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: isLoading ? 2 : 4,
                      shadowColor: AppConstants.primaryColor.withOpacity(0.3),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: isLoading
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
                                  'Processing...',
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
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // File Status Section with smooth appearance
        if (_showFileStatus && fileProvider.hasFile && !isLoading)
          _buildFileStatusSection(fileProvider),
      ],
    );
  }

  Future<void> _handleUpload(
    PdfProvider pdfProvider,
    BuildContext context,
  ) async {
    final authState = Provider.of<AuthState>(context, listen: false);

    if (!authState.isUserSignedIn) {
      signin.showSignInDialog(context);
    } else {
      // Set local loading state first for immediate feedback
      setState(() {
        _isLocalLoading = true;
        _showFileStatus = false; // Hide file status while loading
      });

      // Add a small delay to ensure loading state is visible
      await Future.delayed(const Duration(milliseconds: 50));

      try {
        // Start both the file processing and a 5-second delay
        final processingFuture = pdfProvider.selectAndUploadFile();
        final fiveSecondDelay = Future.delayed(const Duration(seconds: 5));

        // Wait for both to complete (whichever takes longer)
        await Future.wait([processingFuture, fiveSecondDelay]);

        // After 5 seconds, show the file status
        if (mounted) {
          setState(() {
            _showFileStatus = true;
          });
        }
      } finally {
        // Ensure loading state is cleared even if there's an error
        if (mounted) {
          setState(() {
            _isLocalLoading = false;
          });
        }
      }
    }
  }

  Widget _buildFileStatusSection(FileProvider fileProvider) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
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
              setState(() {
                _showFileStatus = false; // Hide file status when cleared
              });
            },
            icon: Icon(Icons.close, color: AppConstants.subtitleColor),
          ),
        ],
      ),
    );
  }
}
