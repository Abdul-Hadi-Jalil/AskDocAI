import 'package:flutter/foundation.dart';

class AdProvider with ChangeNotifier {
  int _availablePrompts = 3; // Start with 3 free prompts
  bool _isAdLoading = false;
  int _messageCount = 0;

  int get availablePrompts => _availablePrompts;
  bool get isAdLoading => _isAdLoading;
  int get messageCount => _messageCount;

  void addPrompts(int count) {
    _availablePrompts += count;
    notifyListeners();
  }

  void usePrompt() {
    if (_availablePrompts > 0) {
      _availablePrompts--;
      _messageCount++;
      notifyListeners();
    }
  }

  void setAdLoading(bool loading) {
    _isAdLoading = loading;
    notifyListeners();
  }

  void incrementMessageCount() {
    _messageCount++;
    notifyListeners();
  }

  void resetPrompts() {
    _availablePrompts = 3;
    _messageCount = 0;
    notifyListeners();
  }
}
