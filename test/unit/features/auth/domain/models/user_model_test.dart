import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_starter_template/features/auth/domain/models/user_model.dart';

void main() {
  group('User Model', () {
    test('creates user with required fields', () {
      // Arrange & Act
      const user = User(
        id: '123',
        email: 'test@example.com',
        name: 'Test User',
      );

      // Assert
      expect(user.id, '123');
      expect(user.email, 'test@example.com');
      expect(user.name, 'Test User');
      expect(user.avatar, isNull);
    });

    test('creates user with optional avatar', () {
      // Arrange & Act
      const user = User(
        id: '123',
        email: 'test@example.com',
        name: 'Test User',
        avatar: 'https://example.com/avatar.jpg',
      );

      // Assert
      expect(user.avatar, 'https://example.com/avatar.jpg');
    });

    test('two users with same data are equal', () {
      // Arrange
      const user1 = User(
        id: '123',
        email: 'test@example.com',
        name: 'Test User',
      );
      const user2 = User(
        id: '123',
        email: 'test@example.com',
        name: 'Test User',
      );

      // Assert
      expect(user1, equals(user2));
      expect(user1.hashCode, equals(user2.hashCode));
    });

    test('two users with different data are not equal', () {
      // Arrange
      const user1 = User(
        id: '123',
        email: 'test@example.com',
        name: 'Test User',
      );
      const user2 = User(
        id: '456',
        email: 'other@example.com',
        name: 'Other User',
      );

      // Assert
      expect(user1, isNot(equals(user2)));
    });

    test('toString returns correct format', () {
      // Arrange
      const user = User(
        id: '123',
        email: 'test@example.com',
        name: 'Test User',
      );

      // Act
      final result = user.toString();

      // Assert
      expect(result, contains('User('));
      expect(result, contains('id: 123'));
      expect(result, contains('email: test@example.com'));
    });
  });
}
