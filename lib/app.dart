import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'config/themes.dart';
import 'config/localization.dart';
import 'providers/theme_provider.dart';
import 'providers/language_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/lock_screen.dart';
import 'screens/home_screen.dart';
import 'screens/class_screen.dart';
import 'screens/student_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/export_screen.dart';
import 'screens/filter_screen.dart';

class EVApp extends StatelessWidget {
  const EVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, langProvider, child) {
        return MaterialApp(
          title: 'EV',
          debugShowCheckedModeBanner: false,
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: themeProvider.themeMode,
          locale: langProvider.locale,
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ur', 'PK'),
            Locale('ur', 'Roman'),
          ],
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          initialRoute: '/splash',
          routes: {
            '/splash': (context) => const SplashScreen(),
            '/lock': (context) => const LockScreen(),
            '/home': (context) => const HomeScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/export': (context) => const ExportScreen(),
            '/filter': (context) => const FilterScreen(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/class') {
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (context) => ClassScreen(
                  className: args['className'],
                  classId: args['classId'],
                ),
              );
            }
            if (settings.name == '/student') {
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (context) => StudentScreen(
                  rollNumber: args['rollNumber'],
                  classId: args['classId'],
                  className: args['className'],
                  studentId: args['studentId'],
                ),
              );
            }
            return null;
          },
        );
      },
    );
  }
}
