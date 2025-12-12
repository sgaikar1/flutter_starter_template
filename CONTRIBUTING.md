# Contributing to {{PROJECT_NAME}}

Thank you for your interest in contributing! This document provides guidelines and workflows for contributing to this project.

## 🚀 Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork:**
   ```bash
   git clone https://github.com/yourusername/{{PROJECT_NAME}}.git
   cd {{PROJECT_NAME}}
   ```
3. **Set up development environment:**
   ```bash
   ./scripts/dev_setup.sh
   ```
4. **Create a feature branch:**
   ```bash
   git checkout -b feature/my-new-feature
   ```

## 📝 Development Workflow

### Before Making Changes

1. Ensure you're on the latest `main` branch:
   ```bash
   git checkout main
   git pull origin main
   ```
2. Create a new branch for your changes
3. Run existing tests to ensure everything works:
   ```bash
   flutter test
   ```

### While Making Changes

1. **Follow the code style** (see below)
2. **Write tests** for new functionality
3. **Update documentation** if you change APIs or add features
4. **Run checks frequently:**
   ```bash
   dart format lib/ test/
   flutter analyze
   flutter test
   ```

### After Making Changes

1. **Format your code:**
   ```bash
   dart format lib/ test/
   ```
2. **Ensure all tests pass:**
   ```bash
   flutter test --coverage
   ```
3. **Check analysis:**
   ```bash
   flutter analyze
   ```
4. **Commit with a meaningful message** (see Commit Guidelines below)

## 💻 Code Style

### Dart Code Style

- **Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)**
- **Use the included linter rules** (`analysis_options.yaml`)
- **Maximum line length:** 80 characters
- **Use `const` wherever possible**
- **Prefer `final` over `var`**

### Naming Conventions

- **Classes**: `PascalCase`
- **Files**: `snake_case.dart`
- **Functions/Variables**: `camelCase`
- **Constants**: `camelCase` or `kCamelCase` for app-wide constants
- **Private members**: `_leadingUnderscore`

### File Organization

Place files in the appropriate layer:

```
feature_name/
├─ domain/          # Business logic, models, interfaces (no Flutter imports)
├─ data/            # Implementation details, API calls, DTOs
└─ presentation/    # UI code, widgets, state management
```

### Documentation

- **Document all public APIs** with `///` doc comments
- **Explain WHY, not WHAT** in comments
- **Include examples** for complex functions:
  ```dart
  /// Fetches user profile by ID.
  /// 
  /// Example:
  /// ```dart
  /// final result = await userRepository.getById('user_123');
  /// ```
  Future<ApiResult<User>> getById(String id);
  ```

## 🧪 Testing Guidelines

### Test Coverage

- **Aim for >80% code coverage** for domain and data layers
- **Write unit tests** for business logic
- **Write widget tests** for custom widgets
- **Write integration tests** for critical user flows

### Test Structure

Use the **Arrange-Act-Assert** pattern:

```dart
test('login succeeds with valid credentials', () async {
  // Arrange
  final authService = MockAuthService();
  when(authService.login(...)).thenReturn(...);
  
  // Act
  final result = await authService.login(email: '...', password: '...');
  
  // Assert
  expect(result, isA<Success>());
});
```

### Test File Organization

- Place tests in `test/` mirroring `lib/` structure
- Name test files: `<filename>_test.dart`
- Example: `lib/features/auth/domain/models/user.dart` → `test/unit/features/auth/domain/models/user_test.dart`

## 📦 Adding Dependencies

1. **Check if the dependency is necessary**
2. **Prefer well-maintained packages** with good documentation
3. **Add to pubspec.yaml:**
   ```bash
   flutter pub add package_name
   ```
4. **Update README** if it's a significant dependency
5. **Consider impact on app size and performance**

## 🔀 Branch Strategy

- `main` — Production-ready code
- `develop` — Integration branch (if using GitFlow)
- `feature/*` — New features
- `bugfix/*` — Bug fixes
- `hotfix/*` — Urgent production fixes

## 📬 Commit Guidelines

### Commit Message Format

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, semicolons, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks (dependencies, configs, etc.)
- `perf`: Performance improvements

### Examples

```
feat(auth): add password reset functionality

Implemented password reset flow with email verification.
Users can now reset their password using a magic link.

Closes #123
```

```
fix(home): resolve list refresh issue

Fixed a bug where the home list wouldn't refresh after
pulling down. The issue was caused by not resetting the
refresh indicator state.

Fixes #456
```

## 🔍 Pull Request Process

### Before Submitting

- [ ] All tests pass
- [ ] Code is formatted
- [ ] No analyzer warnings
- [ ] Documentation updated
- [ ] CHANGELOG.md updated (for significant changes)

### PR Title

Use the same format as commit messages:
```
feat(auth): add biometric authentication support
```

### PR Description Template

```markdown
## Description
Brief description of what this PR does.

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
Describe how you tested this.

## Screenshots (if applicable)
Add screenshots for UI changes.

## Checklist
- [ ] Code follows style guidelines
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] No new warnings
```

### Review Process

1. **At least one approval required** before merging
2. **Address all comments** before merging
3. **Keep PRs focused** — one feature/fix per PR
4. **Rebase if requested** to keep history clean

## 🏗️ Architecture Guidelines

### Feature-First Structure

Organize by feature, not by layer:

✅ Good:
```
features/
  auth/
    domain/
    data/
    presentation/
```

❌ Bad:
```
domain/
  auth/
data/
  auth/
presentation/
  auth/
```

### Dependency Rules

- **Presentation** → depends on → **Domain**
- **Data** → depends on → **Domain**
- **Domain** → depends on → **Nothing** (pure Dart, no Flutter)

### State Management

- **Use ValueNotifier** for simple state
- **Use ChangeNotifier** for complex state
- **Can be swapped** for Provider/Riverpod/Bloc

### Error Handling

- **Use `ApiResult<T>`** for operations that can fail
- **Create specific error types** (don't use generic `Exception`)
- **Handle errors at presentation layer**

## 📚 Adding a New Feature

Step-by-step guide:

1. **Create feature folder:**
   ```
   lib/features/my_feature/
   ```

2. **Start with domain layer:**
   - Create model classes
   - Define repository interfaces
   - NO implementation details

3. **Implement data layer:**
   - Create DTOs with`json_serializable`
   - Implement repositories
   - Add data sources (API, local storage)

4. **Build presentation layer:**
   - Create pages/screens
   - Create widgets
   - Create notifiers for state

5. **Add routes:**
   - Update `lib/core/router/app_router.dart`

6. **Wire dependencies:**
   - Update `lib/core/di/service_locator.dart`

7. **Write tests**

8. **Update documentation**

## 🐛 Reporting Bugs

Use the **bug report template** when creating issues:

- **Description:** What happened?
- **Expected behavior:** What should happen?
- **Steps to reproduce**
- **Flutter version:** `flutter --version`
- **Device/Platform:** Android 12, iOS 16, Web, etc.
- **Screenshots/Logs if applicable**

## 💡 Suggesting Features

Use the **feature request template**:

- **Problem:** What problem does this solve?
- **Proposed solution**
- **Alternatives considered**
- **Additional context**

## 🔐 Security

- **DO NOT commit secrets** or API keys
- **Use `.env` files** (which are gitignored)
- **Report security issues privately** (see SECURITY.md)

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

## ❓ Questions

- **Open an issue** for general questions
- **Join discussions** for broader topics
- **Check existing documentation** first

---

**Thank you for contributing! 🎉**
