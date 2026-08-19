import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/features/auth/login_Screen/controller/login_screen_controller.dart';

void main() {
  group('Login Validation Unit Tests', () {
    late LoginScreenController controller;

    setUp(() {
      controller = LoginScreenController();
    });

    test('Empty email validation returns error message', () {
      final result = controller.validateEmail('');
      expect(result, equals('Email address is required.'));
    });

    test('Null email validation returns error message', () {
      final result = controller.validateEmail(null);
      expect(result, equals('Email address is required.'));
    });

    test('Invalid email format returns invalid email error message', () {
      final result = controller.validateEmail('invalid-email-address');
      expect(result, equals('Please enter a valid email address.'));
    });

    test('Valid email returns null (no error)', () {
      final result = controller.validateEmail('admin@example.com');
      expect(result, isNull);
    });

    test('Empty password validation returns error message', () {
      final result = controller.validatePassword('');
      expect(result, equals('Password is required.'));
    });

    test('Password shorter than 6 characters returns minimum length error', () {
      final result = controller.validatePassword('12345');
      expect(result, equals('Password must be at least 6 characters.'));
    });

    test('Valid password returns null (no error)', () {
      final result = controller.validatePassword('123456');
      expect(result, isNull);
    });

    test('Password visibility toggle toggles obscure flag', () {
      expect(controller.obscurePassword, isTrue);
      controller.togglePasswordVisibility();
      expect(controller.obscurePassword, isFalse);
    });
  });
}
