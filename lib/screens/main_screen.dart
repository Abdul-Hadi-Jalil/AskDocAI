import 'package:docusense_ai/screens/chat_screen.dart';
import 'package:docusense_ai/screens/quiz_screen.dart';
import 'package:docusense_ai/screens/summay_screen.dart';
import 'package:flutter/material.dart';
//import 'package:docusense_ai/Screens/signin_screen.dart';
import 'package:docusense_ai/utils/file_helper.dart';
import 'package:docusense_ai/widgets/profile_avatar.dart';
import 'package:provider/provider.dart';
//import 'package:docusense_ai/providers/auth_state.dart';
import 'package:docusense_ai/providers/file_state.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf8f9fa),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: const Color(0xFF1a73e8),
        unselectedItemColor: Colors.grey[600],
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 12,
        iconSize: 28,
        selectedFontSize: 15,
        unselectedFontSize: 13,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.upload_file),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.summarize_outlined),
            label: 'Summary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz_outlined),
            label: 'Quiz',
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          UploadScreen(),
          ChatScreen(),
          SummaryScreen(),
          QuizScreen(),
        ],
      ),
    );
  }
}

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  bool isFileSelected = false;
  String? fileName;

  @override
  void initState() {
    super.initState();
    final fileState = context.read<FileState>();
    if (fileState.uploadedFileContent != null) {
      setState(() {
        isFileSelected = true;
        fileName = fileState.uploadedFileName ?? "File uploaded successfully";
      });
    }
  }

  void _resetToDefault() {
    //context.read<AuthState>().signOut();
    context.read<FileState>().clearFile();
    setState(() {
      isFileSelected = false;
      fileName = null;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Signed out successfully')));
  }

  Future<void> _handleFileUpload() async {
    //final authState = context.read<AuthState>();
    //if (authState.isUserSignedIn) {
    await FileHelper.pickAndReadFile(context);
    final fileState = context.read<FileState>();
    if (fileState.uploadedFileContent != null) {
      setState(() {
        isFileSelected = true;
        fileName = fileState.uploadedFileName ?? "File uploaded successfully";
      });
    } // else {
    setState(() {
      isFileSelected = false;
    });
    //}
    // } else {
    //ScaffoldMessenger.of(
    // context,
    //).showSnackBar(const SnackBar(content: Text('Please sign in first')));
    //}
  }

  @override
  Widget build(BuildContext context) {
    // final authState = context.watch<AuthState>();

    return Scaffold(
      backgroundColor: const Color(0xFFf8f9fa),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // --- Header ---
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1a73e8), Color(0xFF0d47a1)],
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 28,
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        children: const [
                          Text(
                            'DocuSense AI',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Your AI-powered document assistant',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Positioned(
                    // right: 0,
                    //top: 5,
                    //child: ProfileAvatar(
                    // userName: authState.user?.displayName,
                    //onSignOut: _resetToDefault,
                    //),
                    //),
                  ],
                ),
              ),

              // --- Upload Card Section ---
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 32),
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.blue[100]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.upload_file,
                            size: 70,
                            color: Color(0xFF1a73e8),
                          ),
                          const SizedBox(height: 10),
                          //Text(
                          // isFileSelected
                          //    ? 'File Uploaded Successfully!'
                          //   : 'Upload Your Document',
                          //style: TextStyle(
                          // fontSize: 20,
                          //fontWeight: FontWeight.bold,
                          //color: Colors.blue[800],
                          //),
                          //),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              //if (authState.isUserSignedIn) {
                              _handleFileUpload();
                              //} else {
                              //  showSignInDialog(context);
                              //}
                            },
                            icon: const Icon(Icons.folder_open),
                            label: Text(
                              // isFileSelected
                              'Choose Another File',
                              //  : 'Select File',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1a73e8),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //if (isFileSelected) ...[
                    // const SizedBox(height: 20),
                    //Text(
                    // '✅ $fileName',
                    // style: TextStyle(
                    //  fontSize: 16,
                    //  color: Colors.green[700],
                    //  fontWeight: FontWeight.w500,
                    //),
                    // ),
                    //],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
