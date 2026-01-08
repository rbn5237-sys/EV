class AppSettings {
  String language;
  String themeMode;
  bool isFirstRun;
  String pinHash;

  AppSettings({
    this.language = 'en',
    this.themeMode = 'system',
    this.isFirstRun = true,
    this.pinHash = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'language': language,
      'theme_mode': themeMode,
      'is_first_run': isFirstRun ? 1 : 0,
      'pin_hash': pinHash,
    };
  }

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      language: map['language'] ?? 'en',
      themeMode: map['theme_mode'] ?? 'system',
      isFirstRun: map['is_first_run'] == 1,
      pinHash: map['pin_hash'] ?? '',
    );
  }
}
