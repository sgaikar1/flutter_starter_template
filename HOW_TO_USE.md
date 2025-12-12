# How to Use This Template

This guide explains how to create a new Flutter app from this starter template.

## Quick Start (Automated)

The easiest way is to use the scaffold script:

```bash
# 1. Clone this repo (or use GitHub's "Use this template" button)
git clone https://github.com/yourorg/flutter-starter-template my_new_app
cd my_new_app

# 2. Run the scaffold script
./scripts/scaffold_new_app.sh \
  --name "My Awesome App" \
  --package "com.mycompany.awesomeapp" \
  --org "My Company" \
  --color "#FF5722"

# This will:
# - Copy template to new directory
# - Replace all {{TEMPLATE_VARS}}
# - Initialize new git repo
# - Set you up to start coding

# 3. Move to the new directory
cd ../my_awesome_app

# 4. Run development setup
./scripts/dev_setup.sh

# 5. Generate platform code
flutter create --platforms android,ios,web .

# 6. Run the app!
flutter run
```

## Manual Setup

If you prefer manual control:

### Step 1: Clone or Download

**Option A: GitHub Template**
1. Click "Use this template" on GitHub
2. Create your new repository
3. Clone your new repo

**Option B: Manual Clone**
```bash
git clone https://github.com/yourorg/flutter-starter-template my_new_app
cd my_new_app
rm -rf .git  # Remove template git history
git init     # Start fresh
```

### Step 2: Replace Template Variables

See [TEMPLATE_VARS.md](TEMPLATE_VARS.md) for detailed instructions.

**Find and replace:**
- `{{PROJECT_NAME}}` → "My Awesome App"
- `{{PACKAGE_NAME}}` → "com.mycompany.awesomeapp"  
- `{{ORG_NAME}}` → "My Company"
- `#6200EE` → Your brand color (in `lib/shared/theme/app_theme.dart`)
- `flutter_starter_template` → `my_awesome_app` (in pubspec.yaml)

**Platform-specific:**
- Android: Update `applicationId` in `android/app/build.gradle`
- iOS: Update `PRODUCT_BUNDLE_IDENTIFIER` in Xcode
- Web: Update `name` in `web/manifest.json`

### Step 3: Generate Platform Code

```bash
flutter create --platforms android,ios,web .
```

This generates the native Android/iOS/Web folders.

### Step 4: Install Dependencies

```bash
flutter pub get
```

### Step 5: Set Up Environment

```bash
# Copy environment template
cp .env.example .env

# Edit .env with your values
# Update API_BASE_URL, etc.
```

### Step 6: Run Code Generation

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Step 7: Set Up Git Hooks (Optional)

```bash
chmod +x scripts/pre-commit
cp scripts/pre-commit .git/hooks/pre-commit
```

### Step 8: Run the App

```bash
flutter run
```

## What to Customize Next

### 1. Theme & Branding

**Primary Color:**
- Edit `lib/shared/theme/app_theme.dart`
- Change `kSeedColor`

**App Icon:**
```bash
# Add your icon to assets/icons/app_icon.png
flutter pub run flutter_launcher_icons
```

**Fonts:**
- Add font files to `assets/fonts/`
- Update `pubspec.yaml`

### 2. Replace Mock Auth

Edit `lib/features/auth/data/services/auth_service_impl.dart`:

```dart
// Replace mock implementation with real API calls
final result = await _apiClient.post<LoginResponseDto>(
  '/auth/login',
  body: {'email': email, 'password': password},
  fromJson: LoginResponseDto.fromJson,
);
```

### 3. Update API Base URL

Edit `lib/core/config/env_config.dart`:

```dart
static const dev = EnvConfig._(
  apiBaseUrl: 'https://api-dev.yourcompany.com',  // Your API
  // ...
);
```

### 4. Add Your Features

Follow the pattern in `lib/features/auth/`:

```
my_new_feature/
├─ domain/          # Business logic
├─ data/            # API & storage
└─ presentation/    # UI & state
```

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

### 5. Configure CI/CD

1. Push to GitHub
2. The `.github/workflows/ci.yml` will run automatically
3. Update with your specific needs (e.g., deploy steps)

## Common Scenarios

### Changing Package Name After Setup

If you need to change the package name later:

1. **Android:**
   - `android/app/build.gradle` → `applicationId`
   - `android/app/src/main/AndroidManifest.xml` → `package`
   - Move `MainActivity.kt` to new package path

2. **iOS:**
   - Open `ios/Runner.xcworkspace` in Xcode
   - Update Bundle Identifier in project settings

3. **Flutter:**
   - `pubspec.yaml` → `name`
   - Update import statements

### Adding a New Locale

1. Create `lib/l10n/app_<locale>.arb`
2. Copy from `app_en.arb` and translate
3. Add to `supportedLocales` in `lib/app.dart`
4. Run: `flutter gen-l10n`

### Switching State Management

The template uses Riverpod with code generation by default.

**To use Bloc:**
1. Add `flutter_bloc` package
2. Replace providers with `BlocProvider`
3. Update widgets to use `BlocBuilder`/`BlocConsumer`

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed migration guide.

### Adding Firebase

1. Install FlutterFire CLI
2. Run: `flutterfire configure`
3. Add packages: `firebase_core`, `firebase_analytics`, etc.
4. Initialize in `main.dart`

## Troubleshooting

**"Package doesn't exist" errors:**
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

**Platform folders missing:**
```bash
flutter create --platforms android,ios,web,macos,windows,linux .
```

**Script not executable:**
```bash
chmod +x scripts/*.sh
```

**Pre-commit hook not running:**
```bash
chmod +x .git/hooks/pre-commit
```

## Support

- **Documentation:** Check all `.md` files in the repo
- **Issues:** Open a GitHub issue
- **Questions:** Start a GitHub discussion

## Next Steps

1. ✅ Set up the template (you're here!)
2. 🎨 Customize branding & theme
3. 🔗 Connect to your backend API
4. ✨ Add your features
5. 🧪 Write tests
6. 🚀 Deploy to stores

---

**Happy coding! 🎉**
