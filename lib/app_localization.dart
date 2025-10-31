import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'DocuSense AI',
      'tagline': 'Your AI-Powered Document Assistant',
      'loadingApplication': 'Loading application',
      'pleaseUploadPdfFirst': 'Please upload a PDF first to start chatting',
      'home': 'Home',
      'chat': 'Chat',
      'quiz': 'Quiz',
      'summary': 'Summary',
      'signIn': 'Sign In',
      'signOut': 'Sign Out',
      'uploadFile': 'Upload File',
      'startQuiz': 'Start Quiz',
      'next': 'Next',
      'previous': 'Previous',
      'submit': 'Submit',
      'loading': 'Loading...',
      'error': 'An error occurred',
      'copyright': '© 2025 DocuSense AI',
      'selectLanguage': 'Select Language',
    },
    'es': {
      'appTitle': 'DocuSense AI',
      'tagline': 'Tu Asistente de Documentos con IA',
      'loadingApplication': 'Cargando aplicación',
      'pleaseUploadPdfFirst': 'Por favor, sube un PDF primero para chatear',
      'home': 'Inicio',
      'chat': 'Chat',
      'quiz': 'Cuestionario',
      'summary': 'Resumen',
      'signIn': 'Iniciar Sesión',
      'signOut': 'Cerrar Sesión',
      'uploadFile': 'Subir Archivo',
      'startQuiz': 'Comenzar Quiz',
      'next': 'Siguiente',
      'previous': 'Anterior',
      'submit': 'Enviar',
      'loading': 'Cargando...',
      'error': 'Ocurrió un error',
      'copyright': '© 2025 DocuSense AI',
      'selectLanguage': 'Seleccionar idioma',
    },
    'fr': {
      'appTitle': 'DocuSense AI',
      'tagline': 'Votre Assistant Documentaire IA',
      'loadingApplication': 'Chargement de l\'application',
      'pleaseUploadPdfFirst':
          'Veuillez d\'abord télécharger un PDF pour chatter',
      'home': 'Accueil',
      'chat': 'Chat',
      'quiz': 'Quiz',
      'summary': 'Résumé',
      'signIn': 'Se Connecter',
      'signOut': 'Se Déconnecter',
      'uploadFile': 'Télécharger Fichier',
      'startQuiz': 'Commencer le Quiz',
      'next': 'Suivant',
      'previous': 'Précédent',
      'submit': 'Soumettre',
      'loading': 'Chargement...',
      'error': 'Une erreur est survenue',
      'copyright': '© 2025 DocuSense AI',
      'selectLanguage': 'Choisir la langue',
    },
    'de': {
      'appTitle': 'DocuSense AI',
      'tagline': 'Ihr KI-gestützter Dokumentenassistent',
      'loadingApplication': 'Anwendung wird geladen',
      'pleaseUploadPdfFirst':
          'Bitte laden Sie zuerst eine PDF hoch, um zu chatten',
      'home': 'Startseite',
      'chat': 'Chat',
      'quiz': 'Quiz',
      'summary': 'Zusammenfassung',
      'signIn': 'Anmelden',
      'signOut': 'Abmelden',
      'uploadFile': 'Datei Hochladen',
      'startQuiz': 'Quiz Starten',
      'next': 'Weiter',
      'previous': 'Zurück',
      'submit': 'Einreichen',
      'loading': 'Lädt...',
      'error': 'Ein Fehler ist aufgetreten',
      'copyright': '© 2025 DocuSense AI',
      'selectLanguage': 'Sprache auswählen',
    },
    'nl': {
      'appTitle': 'DocuSense AI',
      'tagline': 'Uw AI-aangedreven Documentassistent',
      'loadingApplication': 'Applicatie laden',
      'pleaseUploadPdfFirst': 'Upload eerst een PDF om te chatten',
      'home': 'Home',
      'chat': 'Chat',
      'quiz': 'Quiz',
      'summary': 'Samenvatting',
      'signIn': 'Inloggen',
      'signOut': 'Uitloggen',
      'uploadFile': 'Bestand Uploaden',
      'startQuiz': 'Start Quiz',
      'next': 'Volgende',
      'previous': 'Vorige',
      'submit': 'Indienen',
      'loading': 'Laden...',
      'error': 'Er is een fout opgetreden',
      'copyright': '© 2025 DocuSense AI',
      'selectLanguage': 'Selecteer taal',
    },
    'ar': {
      'appTitle': 'DocuSense AI',
      'tagline': 'مساعدك الذكي للمستندات',
      'loadingApplication': 'جاري تحميل التطبيق',
      'pleaseUploadPdfFirst': 'يرجى تحميل ملف PDF أولاً للبدء في الدردشة',
      'home': 'الرئيسية',
      'chat': 'الدردشة',
      'quiz': 'الاختبار',
      'summary': 'ملخص',
      'signIn': 'تسجيل الدخول',
      'signOut': 'تسجيل الخروج',
      'uploadFile': 'رفع ملف',
      'startQuiz': 'بدء الاختبار',
      'next': 'التالي',
      'previous': 'السابق',
      'submit': 'إرسال',
      'loading': 'جاري التحميل...',
      'error': 'حدث خطأ',
      'copyright': '© 2025 DocuSense AI',
      'selectLanguage': 'اختر اللغة',
    },
    'zh': {
      'appTitle': 'DocuSense AI',
      'tagline': '您的AI驱动文档助手',
      'loadingApplication': '正在加载应用程序',
      'pleaseUploadPdfFirst': '请先上传PDF文件开始聊天',
      'home': '首页',
      'chat': '聊天',
      'quiz': '测验',
      'summary': '摘要',
      'signIn': '登录',
      'signOut': '退出',
      'uploadFile': '上传文件',
      'startQuiz': '开始测验',
      'next': '下一步',
      'previous': '上一步',
      'submit': '提交',
      'loading': '加载中...',
      'error': '发生错误',
      'copyright': '© 2025 DocuSense AI',
      'selectLanguage': '选择语言',
    },
  };

  String get appTitle {
    return _localizedValues[locale.languageCode]!['appTitle']!;
  }

  String get tagline {
    return _localizedValues[locale.languageCode]!['tagline']!;
  }

  String get loadingApplication {
    return _localizedValues[locale.languageCode]!['loadingApplication']!;
  }

  String get pleaseUploadPdfFirst {
    return _localizedValues[locale.languageCode]!['pleaseUploadPdfFirst']!;
  }

  String get home {
    return _localizedValues[locale.languageCode]!['home']!;
  }

  String get chat {
    return _localizedValues[locale.languageCode]!['chat']!;
  }

  String get quiz {
    return _localizedValues[locale.languageCode]!['quiz']!;
  }

  String get summary {
    return _localizedValues[locale.languageCode]!['summary']!;
  }

  String get signIn {
    return _localizedValues[locale.languageCode]!['signIn']!;
  }

  String get signOut {
    return _localizedValues[locale.languageCode]!['signOut']!;
  }

  String get uploadFile {
    return _localizedValues[locale.languageCode]!['uploadFile']!;
  }

  String get startQuiz {
    return _localizedValues[locale.languageCode]!['startQuiz']!;
  }

  String get next {
    return _localizedValues[locale.languageCode]!['next']!;
  }

  String get previous {
    return _localizedValues[locale.languageCode]!['previous']!;
  }

  String get submit {
    return _localizedValues[locale.languageCode]!['submit']!;
  }

  String get loading {
    return _localizedValues[locale.languageCode]!['loading']!;
  }

  String get error {
    return _localizedValues[locale.languageCode]!['error']!;
  }

  String get copyright {
    return _localizedValues[locale.languageCode]!['copyright']!;
  }

  String get selectLanguage {
    return _localizedValues[locale.languageCode]!['selectLanguage']!;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return [
      'en',
      'es',
      'fr',
      'de',
      'nl',
      'ar',
      'zh',
    ].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
