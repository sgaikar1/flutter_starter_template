# Template Variables Reference

This document lists all template variables used in this Flutter starter template and where to find/change them.

## Variables Overview

| Variable | Description | Example Value | Usage |
|----------|-------------|---------------|-------|
| `{{PROJECT_NAME}}` | Human-friendly app name | "AstroGuide" | Display name, titles |
| `{{PACKAGE_NAME}}` | Reverse-DNS package identifier | "com.company.astroguide" | Android/iOS bundle ID |
| `{{ORG_NAME}}` | Organization/company name | "ACME Corp" | About page, licenses |
| `{{PRIMARY_COLOR}}` | Theme seed color (hex) | "#6200EE" | App theming |
| `{{LOCALE_DEFAULT}}` | Default locale code | "en" | Localization |
| `{{SUPPORT_RTL}}` | Enable RTL support | true/false | Text direction |

## Using the Scaffold Script

The easiest way to replace variables is using the scaffold script:

```bash
./scripts/scaffold_new_app.sh \
  --name "My App" \
  --package "com.mycompany.myapp" \
  --org "My Company" \
  --color "#FF5722"
```

This automatically creates a new project with all variables replaced.

## Manual Replacement Guide

If you need to change variables manually after scaffolding:

### {{PROJECT_NAME}}

**Where it's used:**
- `pubspec.yaml` → `name:` and `description:`
- `lib/app.dart` → MaterialApp `title:`
- `lib/l10n/app_en.arb` → `appTitle` value
- `README.md` → Throughout documentation
- All localization files

**How to change:**
1. Search for `{{PROJECT_NAME}}` or the old name
2. Replace with your new app name
3. For `pubspec.yaml`, use snake_case: `my_app_name`

### {{PACKAGE_NAME}}

**Where it's used:**
- Android: `android/app/build.gradle` → `applicationId`
- Android: `android/app/src/main/AndroidManifest.xml` → `package`
- iOS: `ios/Runner.xcodeproj/project.pbxproj` → `PRODUCT_BUNDLE_IDENTIFIER`
- iOS: `ios/Runner/Info.plist` → `CFBundleIdentifier`
- Web: `web/manifest.json` → `name` and `short_name`

**How to change:**
1. Use reverse-DNS format: `com.company.appname`
2. Must be lowercase with no spaces
3. Update all platform-specific files listed above
4. For iOS, also update in Xcode: Open `ios/Runner.xcworkspace` → General → Bundle Identifier

### {{ORG_NAME}}

**Where it's used:**
- `LICENSE` → Copyright holder
- `README.md` → Footer attribution
- About page (if you create one)
- App Store/Play Store listings

**How to change:**
- Simple text replacement in relevant files

### {{PRIMARY_COLOR}}

**Where it's used:**
- `lib/shared/theme/app_theme.dart` → `kSeedColor` constant
- `flutter_launcher_icons.yaml` → `adaptive_icon_background`

**How to change:**
1. Edit `lib/shared/theme/app_theme.dart`:
   ```dart
   const Color kSeedColor = Color(0xFFYOURCOLOR);
   ```
2. Use hex format: `0xFF` + 6-digit hex (e.g., `0xFFFF5722`)
3. Update launcher icon background color if needed

### {{LOCALE_DEFAULT}}

**Where it's used:**
- `lib/app.dart` → `locale:` parameter
- `l10n.yaml` → `template-arb-file`

**How to change:**
1. Edit `lib/app.dart`:
   ```dart
   locale: const Locale('en'), // Change to your locale code
   ```
2. Ensure you have the corresponding ARB file: `lib/l10n/app_<locale>.arb`

### {{SUPPORT_RTL}}

**Where it's used:**
- Would be in MaterialApp configuration (currently defaults to false)

**How to enable RTL:**
1. Ensure your locale ARB files support RTL languages (ar, he, fa, ur)
2. Flutter automatically handles RTL for these locales
3. Test with: `flutter run --locale ar`

## Package Name Change Checklist

Changing the package name after initial setup requires updating multiple files:

### Android
- [ ] `android/app/build.gradle` → `defaultConfig.applicationId`
- [ ] `android/app/src/main/AndroidManifest.xml` → `<manifest package="...">`
- [ ] `android/app/src/main/kotlin/.../MainActivity.kt` → Package declaration
- [ ] Move MainActivity.kt to match new package structure

### iOS
- [ ] Open `ios/Runner.xcworkspace` in Xcode
- [ ] Select Runner → General → Bundle Identifier
- [ ] Update in both Debug and Release configurations
- [ ] `ios/Runner/Info.plist` → `CFBundleIdentifier`

### Flutter
- [ ] `pubspec.yaml` → `name:` (snake_case)
- [ ] Update import statements if you changed the package name

## Build Configuration Variables

These are set via command-line arguments, not in code:

### Environment
```bash
flutter run --dart-define=ENVIRONMENT=prod
```
Values: `dev`, `staging`, `prod`

Used in: `lib/core/config/env_config.dart`

### API Base URL
Set in `.env` file (not committed):
```env
API_BASE_URL=https://api.example.com
```

## Tips

1. **Use Search & Replace:** Use your IDE's find-and-replace (Cmd/Ctrl+Shift+F) to find all occurrences of a variable
2. **Test After Changes:** Run `flutter pub get` and `flutter analyze` after making changes
3. **Platform-Specific:** Remember to test on each platform after package name changes
4. **Git Commit:** Commit changes incrementally to track what you've updated

## Automated Tools

### VS Code Extension
You can create VS Code snippets for common replacements:
```json
{
  "Replace Package Name": {
    "scope": "dart",
    "prefix": "pkg",
    "body": ["com.yourcompany.${1:appname}"]
  }
}
```

### Rename Script
A more advanced `rename_package.sh` script could be added to automate package renaming across all files.

## Support

If you have questions about template variables:
1. Check this document first
2. See the main [README.md](README.md)
3. Open an issue on GitHub
