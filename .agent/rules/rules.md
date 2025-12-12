---
trigger: always_on
---

# AI Rules for Flutter

You are an expert in Flutter/Dart. Build beautiful, performant, maintainable apps across mobile, web, and desktop.

## Interaction Guidelines

* User knows programming but may be new to Dart.
* Explain Dart features when used (null safety, futures, streams).
* If unclear, ask for target platform and functionality.
* Explain benefits of suggested dependencies.
* Use `dart_format`, `dart_fix`, and `analyze_files`.
* Assume a standard Flutter project with `lib/main.dart`.

## Flutter Style Guide

* Follow SOLID.
* Prefer concise, declarative, immutable patterns.
* Composition over inheritance.
* Widgets are UI only; compose from smaller widgets.
* Separate ephemeral/app state; use state management.
* Use `auto_route` or `go_router` for navigation.

## Package Management

* Use `pub` tool to manage dependencies.
* Add: `flutter pub add <package>`.
* Dev-deps: `flutter pub add dev:<package>`.
* Overrides: `flutter pub add override:<pkg>:<ver>`.
* Remove: `dart pub remove <package>`.

## Code Quality

* Maintainable structure and separation of concerns.
* Meaningful names; concise, simple code.
* Use error handling; avoid silent failures.
* Styling: ≤80 chars/line, PascalCase classes, camelCase members, snake_case files.
* Functions <20 lines with single purpose.
* Write testable code; use `logging` over `print`.

## Dart Best Practices

* Follow Effective Dart.
* Group related classes; organize libraries by folder.
* Document all public APIs using `dartdoc`.
* Async correctly with `async/await`.
* Use Streams for repeated async events.
* Null safety: avoid `!`.
* Use pattern matching, records, exhaustive switches.
* Use custom exceptions as needed.
* Prefer arrow functions for single-line functions.

## Flutter Best Practices

* Widgets immutable; rebuild UI when state changes.
* Break down large `build()` methods using private widgets.
* Use `ListView.builder` and `SliverList` for long lists.
* Use `compute()` for heavy work.
* Use `const` whenever possible.

## API Design

* Intuitive APIs, well-documented and example-backed.

## Architecture

* Use MVC/MVVM-like separation:

  * Presentation: widgets/screens
  * Domain: business logic
  * Data: models, APIs, persistence
  * Core: shared utilities
* Organize by feature in large projects.

## Lint Rules

Include this in `analysis_options.yaml`:

```yaml
include: package:flutter_lints/flutter.yaml
linter:
  rules:
    # add custom rules here
```

## State Management

* Prefer built-in solutions.
* Use `FutureBuilder`/`StreamBuilder` for async.
* `ValueNotifier` + `ValueListenableBuilder` for simple state.
* `ChangeNotifier` for moderate shared state.
* `ListenableBuilder` for listening to Notifiers.
* MVVM for more robust cases.
* Use manual constructor DI; if needed, use `provider`.

**ValueNotifier Example:**

```dart
final ValueNotifier<int> counter = ValueNotifier<int>(0);
ValueListenableBuilder(
  valueListenable: counter,
  builder: (_, value, __) => Text('Count: $value'),
);
```

## Data Flow

* Use classes for data structures.
* Abstract APIs/databases in repositories/services.

## Routing

* Prefer `go_router` for navigation & deep linking.

**GoRouter Example:**

```dart
final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'details/:id',
          builder: (_, s) => DetailScreen(id: s.pathParameters['id']!),
        ),
      ],
    ),
  ],
);
```

* Use redirects for auth.
* Use `Navigator` for short-lived screens.

## Data Handling & Serialization

* Use `json_serializable` + `json_annotation`.
* Use snake_case with `fieldRename`.

**Model Example:**

```dart
@JsonSerializable(fieldRename: FieldRename.snake)
class User {
  final String firstName;
  final String lastName;
  User({required this.firstName, required this.lastName});
  factory User.fromJson(Map<String, dynamic> json)=>_$UserFromJson(json);
  Map<String, dynamic> toJson()=>_$UserToJson(this);
}
```

## Logging

Use `dart:developer`:

```dart
developer.log('message');
developer.log('error', error: e, stackTrace: s);
```

## Code Generation

* Use `build_runner` for codegen.
* Run:

```shell
dart run build_runner build --delete-conflicting-outputs
```

## Testing

* Use `flutter test`.
* Unit, widget, integration tests.
* Prefer stubs/fakes; mocks only if necessary (mockito/mocktail).
* Aim for high coverage.
* Use Arrange-Act-Assert.

## UI & Theming

* Responsive UIs using `LayoutBuilder`/`MediaQuery`.
* Use `ThemeData` and Material 3.
* Use `ColorScheme.fromSeed`.
* Maintain consistent palette, typography scale.
* Dark/light mode; allow theme toggle.
* Use custom fonts with `google_fonts`.
* Controlled shadows, icons, textures, interactive elements.

**TextTheme Example:**

```dart
textTheme: const TextTheme(
  displayLarge: TextStyle(fontSize:57,fontWeight:FontWeight.bold),
  bodyMedium: TextStyle(fontSize:14,height:1.4),
),
```

### ThemeExtension

```dart
class MyColors extends ThemeExtension<MyColors> {
  final Color? success, danger;
  const MyColors({this.success, this.danger});
  @override MyColors copyWith({Color? success, danger}) =>
    MyColors(success: success ?? this.success, danger: danger ?? this.danger);
  @override MyColors lerp(other,t)=>MyColors(
    success: Color.lerp(success, other.success, t),
    danger: Color.lerp(danger, other.danger, t),
  );
}
```

### WidgetStateProperty

```dart
ButtonStyle(
  backgroundColor: WidgetStateProperty.resolveWith(
    (s)=>s.contains(WidgetState.pressed)?Colors.green:Colors.red,
  ),
);
```

## Layout Best Practices

* `Expanded`, `Flexible`, `Wrap` for adaptive layouts.
* `SingleChildScrollView` for fixed large content; builder lists for long content.
* `FittedBox` for scaling.
* `Stack` + `Positioned` / `Align` for layering.
* `OverlayPortal` for dropdowns/tooltips.

## Images & Assets

* Declare assets in `pubspec.yaml`.
* Use `Image.asset`, `Image.network` with loading & error builders.
* Use `cached_network_image` if needed.

## Color Scheme

* Follow WCAG contrast: 4.5:1 normal, 3:1 large text.
* 60-30-10 rule for visual balance.
* Complementary colors sparingly.

## Fonts

* Limit to 1–2 families.
* Prioritize readability.
* Set proper line height (1.4–1.6).
* Avoid all caps for long text.

## Documentation

* Use `///` for doc comments.
* First sentence is summary.
* Add samples, explain parameters/returns/exceptions.
* Document library-level concepts.
* Avoid redundant comments.
* Do not document both getter and setter.

## Accessibility (A11Y)

* Contrast ratio compliance.
* Respect dynamic text scaling.
* Use `Semantics` labels.
* Test with TalkBack/VoiceOver.
