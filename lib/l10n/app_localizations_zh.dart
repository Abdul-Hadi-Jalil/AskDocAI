// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'DocuSense AI';

  @override
  String get tagline => '您的AI驱动文档助手';

  @override
  String get loadingApplication => '正在加载应用程序';

  @override
  String get pleaseUploadPdfFirst => '请先上传PDF文件开始聊天';

  @override
  String get home => '首页';

  @override
  String get chat => '聊天';

  @override
  String get quiz => '测验';

  @override
  String get summary => '摘要';

  @override
  String get signIn => '登录';

  @override
  String get signOut => '退出';

  @override
  String get uploadFile => '上传文件';

  @override
  String get startQuiz => '开始测验';

  @override
  String get next => '下一步';

  @override
  String get previous => '上一步';

  @override
  String get submit => '提交';

  @override
  String get loading => '加载中...';

  @override
  String get error => '发生错误';

  @override
  String get copyright => '© 2025 DocuSense AI';
}
