import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_starter_template/shared/widgets/loading_indicator.dart';

void main() {
  group('LoadingIndicator Widget', () {
    testWidgets('renders CircularProgressIndicator', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingIndicator(),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('respects custom size', (tester) async {
      // Arrange
      const customSize = 48.0;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingIndicator(size: customSize),
          ),
        ),
      );

      // Assert
      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byType(CircularProgressIndicator),
          matching: find.byType(SizedBox),
        ).first,
      );
      expect(sizedBox.width, customSize);
      expect(sizedBox.height, customSize);
    });

    testWidgets('uses custom color when provided', (tester) async {
      // Arrange
      const customColor = Colors.red;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingIndicator(color: customColor),
          ),
        ),
      );

      // Assert
      final indicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      final valueColor = indicator.valueColor as AlwaysStoppedAnimation<Color>;
      expect(valueColor.value, customColor);
    });
  });

  group('LoadingOverlay Widget', () {
    testWidgets('shows loading when isLoading is true', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: LoadingOverlay(
            isLoading: true,
            child: Text('Content'),
          ),
        ),
      );

      // Assert
      expect(find.text('Content'), findsOneWidget);
      expect(find.byType(LoadingIndicator), findsOneWidget);
    });

    testWidgets('hides loading when isLoading is false', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: LoadingOverlay(
            isLoading: false,
            child: Text('Content'),
          ),
        ),
      );

      // Assert
      expect(find.text('Content'), findsOneWidget);
      expect(find.byType(LoadingIndicator), findsNothing);
    });

    testWidgets('displays custom message when provided', (tester) async {
      // Arrange
      const message = 'Loading data...';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: LoadingOverlay(
            isLoading: true,
            message: message,
            child: Text('Content'),
          ),
        ),
      );

      // Assert
      expect(find.text(message), findsOneWidget);
    });
  });
}
