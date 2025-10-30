// lib/app_localization.dart

mixin AppLocale {
  static const String appTitle = 'appTitle';
  static const String welcome = 'welcome';

  // We'll add more strings as we progress
  static const Map<String, dynamic> EN = {
    appTitle: 'Smart Document Assistant',
    welcome: 'Welcome',
  };

  static const Map<String, dynamic> KM = {
    appTitle: 'ជំនួយការគ្រប់គ្រងឯកសារ',
    welcome: 'សូមស្វាគមន៍',
  };

  static const Map<String, dynamic> JA = {
    appTitle: 'スマート文書アシスタント',
    welcome: 'ようこそ',
  };
}
