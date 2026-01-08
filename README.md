# EV - Student Management App

This is a Flutter app for managing students and classes.

Setup
------

1. Ensure you have Flutter SDK installed (Flutter 3.x or later).
2. From the project root, run:

```
flutter pub get
```

Run
---

- To run on a connected Android device or emulator:

```
flutter run
```

Build APK
---------

- To build a release APK for Android 10+:

```
flutter build apk --release
```

Notes
-----

- Some assets (app icons) referenced in `pubspec.yaml` may need to be added to `assets/icon/`.
- Fix the PIN validator regex in `lib/utils/validators.dart` if needed.

