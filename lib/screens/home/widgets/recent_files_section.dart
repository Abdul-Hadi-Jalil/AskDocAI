import 'package:docusense_ai/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:docusense_ai/providers/file_provider.dart';

class RecentFilesSection extends StatelessWidget {
  const RecentFilesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FileProvider>(
      builder: (context, fileProvider, child) {
        final recentFiles = fileProvider.recentFiles;

        if (recentFiles.isEmpty) {
          return const SizedBox.shrink(); // Don't show if no recent files
        }

        return Container(
          margin: const EdgeInsets.only(top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Title
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  AppLocalizations.of(context).recentFiles,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
              ),

              // Recent Files List
              _RecentFilesList(recentFiles: recentFiles),
            ],
          ),
        );
      },
    );
  }
}

class _RecentFilesList extends StatelessWidget {
  final List<RecentFile> recentFiles;

  const _RecentFilesList({required this.recentFiles});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // For mobile, show in a column
        if (constraints.maxWidth < 600) {
          return Column(
            children: recentFiles
                .map((file) => _RecentFileItem(file: file))
                .toList(),
          );
        }
        // For larger screens, show in a wrap
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: recentFiles
              .map(
                (file) =>
                    SizedBox(width: 200, child: _RecentFileItem(file: file)),
              )
              .toList(),
        );
      },
    );
  }
}

class _RecentFileItem extends StatelessWidget {
  final RecentFile file;

  const _RecentFileItem({required this.file});

  @override
  Widget build(BuildContext context) {
    final fileProvider = Provider.of<FileProvider>(context, listen: false);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: file.isSelected
              ? const Color(0xFF8A2BE2)
              : const Color(0xFFF0EAFA),
          width: file.isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          fileProvider.selectRecentFile(file);
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // File Icon and Name
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8A2BE2).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.picture_as_pdf,
                      size: 20,
                      color: Color(0xFF8A2BE2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      file.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // File Size
              Text(
                _formatFileSize(file.size),
                style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
              ),
              const SizedBox(height: 4),

              // Upload Date
              Text(
                _formatDate(file.uploadDate),
                style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
              ),

              // Selected Indicator
              if (file.isSelected) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8A2BE2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Selected',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / 1048576).toStringAsFixed(1)} MB';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
