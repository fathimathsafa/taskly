import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:taskly/features/auth/login_Screen/controller/login_screen_controller.dart';
import 'package:taskly/features/auth/login_Screen/view/login_screen.dart';

void main() {
  group('Login Screen Widget Tests', () {
    Widget buildTestableWidget() {
      return MaterialApp(
        home: ChangeNotifierProvider<LoginScreenController>(
          create: (_) => LoginScreenController(),
          child: const LoginScreen(),
        ),
      );
    }

    testWidgets('LoginScreen renders Email field, Password field, and Log In button', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Log In'), findsOneWidget);
    });

    testWidgets('Tapping Log In button with empty fields triggers controller validation', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      final loginBtn = find.text('Log In');
      await tester.tap(loginBtn);
      await tester.pumpAndSettle();

      final controller = tester.element(find.byType(LoginScreen)).read<LoginScreenController>();
      expect(controller.validateEmail(''), equals('Email address is required.'));
      expect(controller.validatePassword(''), equals('Password is required.'));
    });
  });
}
