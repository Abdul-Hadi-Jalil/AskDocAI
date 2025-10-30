import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pdf_provider.dart';
import '../models/app_state.dart';
import '../utils/constants.dart';

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final pdfProvider = Provider.of<PdfProvider>(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -2),
            blurRadius: 10,
            color: Colors.black.withOpacity(0.05),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home,
                label: 'Home',
                isActive: pdfProvider.state.currentTab == BottomNavItem.home,
                onTap: () => pdfProvider.changeTab(BottomNavItem.home),
              ),
              _NavItem(
                icon: Icons.chat,
                label: 'Chat',
                isActive: pdfProvider.state.currentTab == BottomNavItem.chat,
                onTap: () => pdfProvider.changeTab(BottomNavItem.chat),
              ),
              _NavItem(
                icon: Icons.summarize,
                label: 'Summarize',
                isActive:
                    pdfProvider.state.currentTab == BottomNavItem.summarize,
                onTap: () => pdfProvider.changeTab(BottomNavItem.summarize),
              ),
              _NavItem(
                icon: Icons.quiz,
                label: 'Quiz',
                isActive: pdfProvider.state.currentTab == BottomNavItem.quiz,
                onTap: () => pdfProvider.changeTab(BottomNavItem.quiz),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppConstants.lightPurple : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 26, color: AppConstants.primaryColor),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive
                    ? AppConstants.primaryColor
                    : AppConstants.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
