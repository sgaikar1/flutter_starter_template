# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- Home feature with list and detail pages
- Settings feature with theme and locale switching
- Onboarding flow
- Integration tests
- Example unit tests
- Example widget tests

## [0.1.0] - 2024-12-12

### Added
- Initial Flutter starter template
- Feature-first architecture with presentation/domain/data layers
- Material 3 theming with ColorScheme.fromSeed
- Dark mode support
- Custom theme extension for semantic colors
- English and Hindi localization (ARB files)
- RTL support infrastructure
- go_router configuration with auth guards
- Authentication feature with mock implementation
- Login page with form validation
- Token management and storage
- API client with retry logic and error handling
- Sealed ApiResult type for type-safe error handling
- Service locator for dependency injection
- Riverpod state management with code generation
- Environment configuration (dev/staging/prod)
- Comprehensive error types
- Structured logging
- Reusable widgets (AppScaffold, LoadingIndicator, ErrorView, etc.)
- Strict linting rules (analysis_options.yaml)
- GitHub Actions CI workflow
- Development setup script
- Pre-commit hooks
- Scaffold script for creating new apps from template
- Comprehensive documentation (README, CONTRIBUTING, SECURITY, etc.)
- Template variables guide
- MIT License

### Dependencies
- go_router: ^13.0.0
- flutter_riverpod: ^2.5.1
- riverpod_annotation: ^2.3.5
- http: ^1.1.0
- json_annotation: ^4.8.1
- json_serializable: ^6.7.1
- shared_preferences: ^2.2.2
- sqflite: ^2.3.0
- cached_network_image: ^3.3.0
- flutter_launcher_icons: ^0.13.1
- flutter_lints: ^3.0.1
- build_runner: ^2.4.7
- riverpod_generator: ^2.4.0
- riverpod_lint: ^2.3.10

[Unreleased]: https://github.com/yourorg/yourrepo/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/yourorg/yourrepo/releases/tag/v0.1.0
