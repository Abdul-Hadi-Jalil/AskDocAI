// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'DocuSense AI';

  @override
  String get tagline => 'مساعدك الذكي للمستندات';

  @override
  String get loadingApplication => 'جاري تحميل التطبيق';

  @override
  String get pleaseUploadPdfFirst =>
      'يرجى تحميل ملف PDF أولاً للبدء في الدردشة';

  @override
  String get home => 'الرئيسية';

  @override
  String get chat => 'الدردشة';

  @override
  String get quiz => 'الاختبار';

  @override
  String get summary => 'ملخص';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get uploadFile => 'رفع ملف';

  @override
  String get startQuiz => 'بدء الاختبار';

  @override
  String get next => 'التالي';

  @override
  String get previous => 'السابق';

  @override
  String get submit => 'إرسال';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get error => 'حدث خطأ';

  @override
  String get copyright => '© 2025 DocuSense AI';
}
