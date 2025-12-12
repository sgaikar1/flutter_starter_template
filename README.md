# {{PROJECT_NAME}} — Flutter App Starter Template

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.16%2B-02569B?logo=flutter)](https://flutter.dev)

A production-ready Flutter starter template with feature-first architecture, comprehensive tooling, and complete documentation. Clone, customize, and ship faster.

## ✨ Features

- 🏗️ **Feature-first architecture** with presentation/domain/data separation
- 🎨 **Material 3 theming** with ColorScheme.fromSeed and dark mode
- 🌍 **Internationalization** (i18n) with ARB files and RTL support
- 🧭 **Declarative routing** with go_router and auth guards
- 🔐 **Authentication example** with token management
- 💾 **Local storage** with SharedPreferences and repository pattern
- 🔄 **State management** using Riverpod (type-safe, code generation)
- 🌐 **HTTP client** with retry logic and error handling
- 📝 **Strict linting** with comprehensive analysis_options.yaml
- 🧪 **Testing setup** with unit, widget, and integration tests
- 🚀 **CI/CD ready** with GitHub Actions workflows
- 📚 **Comprehensive documentation** and code examples

## 🚀 Quick Start

### Prerequisites

- Flutter SDK 3.16.0 or higher
- Dart SDK 3.2.0 or higher
- Your favorite IDE (VS Code, Android Studio, or IntelliJ)

### Option 1: Clone and Rename

1. **Clone this repository:**
   ```bash
   git clone <template-url> my_awesome_app
   cd my_awesome_app
   ```

2. **Run the scaffold script:**
   ```bash
   ./scripts/scaffold_new_app.sh \
     --name "My Awesome App" \
     --package "com.company.myawesomeapp" \
     --org "My Company" \
     --color "#6200EE"
   ```

4. **Run developer setup:**
   ```bash
   ./scripts/dev_setup.sh
   ```

5. **Run the app:**
   ```bash
   flutter run
   ```

### Option 2: Use as GitHub Template

1. Click "Use this template" button on GitHub
2. Clone your new repository
3. Follow steps 2-4 from Option 1

## 📁 Project Structure

```
lib/
├─ main.dart                    # App entry point
├─ app.dart                     # Main app widget
├─ core/                        # Core functionality
│  ├─ config/                   # Environment configuration
│  ├─ di/                       # Dependency injection
│  ├─ errors/                   # Error types
│  ├─ network/                  # API client
│  ├─ router/                   # App routing
│  ├─ storage/                  # Local storage
│  └─ utils/                    # Utilities
├─ features/                    # Feature modules
│  ├─ auth/
│  │  ├─ data/                  # Data layer (DTOs, repos)
│  │  ├─ domain/                # Domain layer (models, interfaces)
│  │  └─ presentation/          # UI layer (pages, widgets, notifiers)
│  ├─ home/
│  └─ settings/
├─ shared/                      # Shared resources
│  ├─ theme/                    # App theming
│  └─ widgets/                  # Reusable widgets
└─ l10n/                        # Localization files
```

## 🔧 Configuration

### Environment Variables

Copy `.env.example` to `.env` and update with your values:

```bash
cp .env.example .env
```

Key variables:
- `API_BASE_URL`: Your backend API URL
- `ENVIRONMENT`: dev, staging, or prod
- `ENABLE_ANALYTICS`: Enable/disable analytics

### Changing App Name and Package

See [TEMPLATE_VARS.md](TEMPLATE_VARS.md) for details on all template variables and where to change them manually.

### Adding New Locales

1. Create `lib/l10n/app_<locale>.arb` (e.g., `app_es.arb`)
2. Copy content from `app_en.arb` and translate
3. Add locale to `supportedLocales` in `app.dart`

## 🏗️ Development

### Running the App

```bash
# Development
flutter run

# Specific flavor
flutter run --dart-define=ENVIRONMENT=dev

# Release build
flutter build apk --release
flutter build ios --release
flutter build web --release
```

### Code Generation

Run this after modifying JSON-serializable classes:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Testing

```bash
# All tests
flutter test

# With coverage
flutter test --coverage

# Integration tests
flutter test integration_test/
```

### Linting and Formatting

```bash
# Format code
dart format lib/ test/

# Analyze
flutter analyze

# Both (run by pre-commit hook)
./scripts/run_checks.sh
```

## 🎨 Theming

### Changing Primary Color

1. Edit `lib/shared/theme/app_theme.dart`
2. Update `kSeedColor` constant:
   ```dart
   const Color kSeedColor = Color(0xFF6200EE); // Your hex color
   ```

### Custom Theme Colors

Add colors to `AppColors` ThemeExtension:

```dart
class AppColors extends ThemeExtension<AppColors> {
  final Color customColor;
  // ...
}
```

Access in widgets:
```dart
context.appColors.customColor
```

## 🔐 Authentication

The template includes a mock authentication service. To integrate with your backend:

1. Open `lib/features/auth/data/services/auth_service_impl.dart`
2. Replace mock implementation with actual API calls:
   ```dart
   final result = await _apiClient.post<LoginResponseDto>(
     '/auth/login',
     body: {'email': email, 'password': password},
     fromJson: LoginResponseDto.fromJson,
   );
   ```

## 🧩 Adding a New Feature

1. Create feature folder: `lib/features/my_feature/`
2. Create layers:
   ```
   my_feature/
   ├─ data/
   │  ├─ models/          # DTOs with json_serializable
   │  └─ repositories/    # Repository implementations
   ├─ domain/
   │  ├─ models/          # Business models
   │  └─ repositories/    # Repository interfaces
   └─ presentation/
      ├─ pages/           # Screens
      ├─ widgets/         # Feature-specific widgets
      └─ notifiers/       # State management
   ```
3. Register routes in `lib/core/router/app_router.dart`
4. Wire dependencies in `lib/core/di/service_locator.dart`

## 📦 Adding Dependencies

```bash
flutter pub add <package_name>

# Development dependencies
flutter pub add dev:<package_name>
```

Update `pubspec.yaml` and run:
```bash
flutter pub get
```

## 🔄 Changing State Management

This template uses Riverpod with code generation.

### Using Riverpod Providers

```dart
// Define a provider
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;
  
  void increment() => state++;
}

// Use in widget
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return Text('$count');
  }
}
```

### Switching to Bloc

See [CONTRIBUTING.md](CONTRIBUTING.md) for migration guide.

## 🚀 CI/CD

GitHub Actions workflows are included:

- **CI** (`.github/workflows/ci.yml`): Lint, test, and build on every push
- **Release** (`.github/workflows/release.yml`): Create releases from tags

To enable:
1. Push to GitHub
2. Workflows run automatically
3. Check the "Actions" tab

## 📱 Building Releases

### Android

```bash
flutter build apk --release
# Or for app bundle
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

Then open `ios/Runner.xcworkspace` in Xcode and archive.

### Web

```bash
flutter build web --release
```

Deploy the `build/web` directory to your hosting provider.

## 🐛 Troubleshooting

### Common Issues

**"Command not found: flutter"**
- Ensure Flutter is in your PATH
- Run `flutter doctor` to verify installation

**"Target of URI doesn't exist" errors**
- Run `flutter pub get`
- Run `dart run build_runner build --delete-conflicting-outputs`

**Pre-commit hooks not running**
- Make hooks executable: `chmod +x .git/hooks/pre-commit`
-Or run `./scripts/dev_setup.sh` again

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for development workflow and coding standards.

## 📞 Support

For issues and questions:
- Open an issue on GitHub
- Check existing documentation in `/docs`

---

**Made with ❤️ by {{ORG_NAME}}**
