import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_name': 'EV',
      'home': 'Home',
      'settings': 'Settings',
      'students': 'Students',
      'roll_number': 'Roll Number',
      'name': 'Name',
      'father_name': 'Father Name',
      'contact': 'Contact',
      'address': 'Address',
      'comments': 'Comments',
      'behavior': 'Behavior',
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'edit': 'Edit',
      'export': 'Export',
      'share': 'Share',
      'filter': 'Filter',
      'all': 'All',
      'excellent': 'Excellent',
      'good': 'Good',
      'average': 'Average',
      'needs_improvement': 'Needs Improvement',
      'critical': 'Critical',
      'call': 'Call',
      'sms': 'SMS',
      'whatsapp': 'WhatsApp',
      'enter_pin': 'Enter PIN',
      'confirm_pin': 'Confirm PIN',
      'set_pin': 'Set PIN',
      'wrong_pin': 'Wrong PIN',
      'pin_mismatch': 'PIN does not match',
      'language': 'Language',
      'theme': 'Theme',
      'dark_mode': 'Dark Mode',
      'light_mode': 'Light Mode',
      'system': 'System',
      'english': 'English',
      'urdu': 'اردو',
      'roman_urdu': 'Roman Urdu',
      'export_student': 'Export Student',
      'export_class': 'Export Class',
      'export_all': 'Export All Data',
      'add_roll': 'Add Roll Number',
      'custom_roll': 'Custom Roll Number',
      'delete_roll': 'Delete Roll Number',
      'confirm_delete': 'Are you sure you want to delete?',
      'yes': 'Yes',
      'no': 'No',
      'success': 'Success',
      'error': 'Error',
      'saved': 'Saved successfully',
      'deleted': 'Deleted successfully',
      'exported': 'Exported successfully',
      'no_data': 'No data found',
      'security': 'Security',
      'change_pin': 'Change PIN',
      'about': 'About',
      'version': 'Version',
      'student_info': 'Student Information',
      'class_list': 'Class List',
      'search': 'Search',
      'no_students': 'No students found',
      'tap_to_add': 'Tap to add student info',
    },
    'ur': {
      'app_name': 'ای وی',
      'home': 'ہوم',
      'settings': 'ترتیبات',
      'students': 'طلباء',
      'roll_number': 'رول نمبر',
      'name': 'نام',
      'father_name': 'والد کا نام',
      'contact': 'رابطہ',
      'address': 'پتہ',
      'comments': 'تبصرے',
      'behavior': 'رویہ',
      'save': 'محفوظ کریں',
      'cancel': 'منسوخ',
      'delete': 'حذف کریں',
      'edit': 'ترمیم',
      'export': 'برآمد',
      'share': 'شیئر کریں',
      'filter': 'فلٹر',
      'all': 'تمام',
      'excellent': 'بہترین',
      'good': 'اچھا',
      'average': 'اوسط',
      'needs_improvement': 'بہتری کی ضرورت',
      'critical': 'تشویشناک',
      'call': 'کال کریں',
      'sms': 'پیغام',
      'whatsapp': 'واٹس ایپ',
      'enter_pin': 'پن درج کریں',
      'confirm_pin': 'پن کی تصدیق کریں',
      'set_pin': 'پن سیٹ کریں',
      'wrong_pin': 'غلط پن',
      'pin_mismatch': 'پن مماثل نہیں ہے',
      'language': 'زبان',
      'theme': 'تھیم',
      'dark_mode': 'ڈارک موڈ',
      'light_mode': 'لائٹ موڈ',
      'system': 'سسٹم',
      'english': 'English',
      'urdu': 'اردو',
      'roman_urdu': 'رومن اردو',
      'export_student': 'طالب علم برآمد کریں',
      'export_class': 'کلاس برآمد کریں',
      'export_all': 'تمام ڈیٹا برآمد کریں',
      'add_roll': 'رول نمبر شامل کریں',
      'custom_roll': 'کسٹم رول نمبر',
      'delete_roll': 'رول نمبر حذف کریں',
      'confirm_delete': 'کیا آپ واقعی حذف کرنا چاہتے ہیں؟',
      'yes': 'ہاں',
      'no': 'نہیں',
      'success': 'کامیابی',
      'error': 'خرابی',
      'saved': 'کامیابی سے محفوظ',
      'deleted': 'کامیابی سے حذف',
      'exported': 'کامیابی سے برآمد',
      'no_data': 'کوئی ڈیٹا نہیں ملا',
      'security': 'سیکیورٹی',
      'change_pin': 'پن تبدیل کریں',
      'about': 'بارے میں',
      'version': 'ورژن',
      'student_info': 'طالب علم کی معلومات',
      'class_list': 'کلاس کی فہرست',
      'search': 'تلاش',
      'no_students': 'کوئی طالب علم نہیں ملا',
      'tap_to_add': 'معلومات شامل کرنے کے لیے ٹیپ کریں',
    },
    'ur_Roman': {
      'app_name': 'EV',
      'home': 'Home',
      'settings': 'Settings',
      'students': 'Students',
      'roll_number': 'Roll Number',
      'name': 'Naam',
      'father_name': 'Walid ka Naam',
      'contact': 'Rabta',
      'address': 'Pata',
      'comments': 'Comments',
      'behavior': 'Rawayya',
      'save': 'Save Karein',
      'cancel': 'Cancel',
      'delete': 'Delete Karein',
      'edit': 'Edit',
      'export': 'Export',
      'share': 'Share Karein',
      'filter': 'Filter',
      'all': 'Sab',
      'excellent': 'Behtareen',
      'good': 'Acha',
      'average': 'Ausat',
      'needs_improvement': 'Behtari Ki Zaroorat',
      'critical': 'Tashweeshnak',
      'call': 'Call Karein',
      'sms': 'SMS',
      'whatsapp': 'WhatsApp',
      'enter_pin': 'PIN Darj Karein',
      'confirm_pin': 'PIN Ki Tasdeeq Karein',
      'set_pin': 'PIN Set Karein',
      'wrong_pin': 'Ghalat PIN',
      'pin_mismatch': 'PIN Match Nahi',
      'language': 'Zuban',
      'theme': 'Theme',
      'dark_mode': 'Dark Mode',
      'light_mode': 'Light Mode',
      'system': 'System',
      'english': 'English',
      'urdu': 'اردو',
      'roman_urdu': 'Roman Urdu',
      'export_student': 'Student Export Karein',
      'export_class': 'Class Export Karein',
      'export_all': 'Sab Data Export Karein',
      'add_roll': 'Roll Number Add Karein',
      'custom_roll': 'Custom Roll Number',
      'delete_roll': 'Roll Number Delete Karein',
      'confirm_delete': 'Kya Aap Waqai Delete Karna Chahtey Hain?',
      'yes': 'Haan',
      'no': 'Nahi',
      'success': 'Kamyabi',
      'error': 'Kharabi',
      'saved': 'Kamyabi Se Save',
      'deleted': 'Kamyabi Se Delete',
      'exported': 'Kamyabi Se Export',
      'no_data': 'Koi Data Nahi Mila',
      'security': 'Security',
      'change_pin': 'PIN Tabdeel Karein',
      'about': 'About',
      'version': 'Version',
      'student_info': 'Student Ki Maloomat',
      'class_list': 'Class Ki List',
      'search': 'Talash',
      'no_students': 'Koi Student Nahi Mila',
      'tap_to_add': 'Maloomat Add Karne Ke Liye Tap Karein',
    },
  };

  String translate(String key) {
    String langCode = locale.languageCode;
    if (locale.countryCode == 'Roman') {
      langCode = 'ur_Roman';
    }
    return _localizedValues[langCode]?[key] ?? _localizedValues['en']![key] ?? key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ur'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension LocalizationExtension on BuildContext {
  String tr(String key) {
    return AppLocalizations.of(this)?.translate(key) ?? key;
  }
}
