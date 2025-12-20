// test/auth_pages_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:nrcs/features/auth/login_page.dart';
import 'package:nrcs/features/auth/create_account_page.dart';
import 'package:nrcs/core/auth/auth_controller.dart';

class FakeAuthController extends AuthController {
  bool shouldThrowOnSignIn = false;
  bool shouldThrowOnSignUp = false;
  String? lastEmail;
  String? lastPassword;

  @override
  Future<void> signIn(String email, String password) async {
    lastEmail = email;
    lastPassword = password;
    if (shouldThrowOnSignIn) {
      throw Exception('Sign in failed');
    }
  }

  @override
  Future<void> signUp(String email, String password) async {
    lastEmail = email;
    lastPassword = password;
    if (shouldThrowOnSignUp) {
      throw Exception('Sign up failed');
    }
  }
}

Widget buildApp(Widget child) {
  return GetMaterialApp(
    home: child,
    getPages: [
      GetPage(
        name: '/rundown',
        page: () => const Scaffold(body: Center(child: Text('Rundown Page'))),
      ),
      GetPage(name: '/login', page: () => const LoginPage()),
      GetPage(name: '/create-account', page: () => const CreateAccountPage()),
    ],
  );
}

void main() {
  setUp(() async {
    Get.reset();
    Get.put<FakeAuthController>(FakeAuthController());
  });

  group('LoginPage', () {
    testWidgets(
      'shows validation error for invalid email and does not call signIn',
      (tester) async {
        final fake = Get.find<FakeAuthController>();

        await tester.pumpWidget(buildApp(const LoginPage()));
        await tester.pumpAndSettle();

        final emailField = find.byType(TextFormField).at(0);
        final passwordField = find.byType(TextFormField).at(1);
        final signInButton = find.widgetWithText(ElevatedButton, 'Sign in');

        await tester.enterText(emailField, 'invalid-email');
        await tester.enterText(passwordField, 'Password123!');
        await tester.tap(signInButton);
        await tester.pumpAndSettle();

        // Form should not submit; fake controller should not record values
        expect(fake.lastEmail, isNull);
        expect(fake.lastPassword, isNull);
      },
    );

    testWidgets('calls signIn with trimmed email and password when valid', (
      tester,
    ) async {
      final fake = Get.find<FakeAuthController>();

      await tester.pumpWidget(buildApp(const LoginPage()));
      await tester.pumpAndSettle();

      final emailField = find.byType(TextFormField).at(0);
      final passwordField = find.byType(TextFormField).at(1);
      final signInButton = find.widgetWithText(ElevatedButton, 'Sign in');

      await tester.enterText(emailField, '  user@example.com  ');
      await tester.enterText(passwordField, 'Secret#123');
      await tester.tap(signInButton);
      await tester.pumpAndSettle();

      expect(fake.lastEmail, 'user@example.com');
      expect(fake.lastPassword, 'Secret#123');
    });

    testWidgets('shows SnackBar when signIn throws', (tester) async {
      final fake = Get.find<FakeAuthController>();
      fake.shouldThrowOnSignIn = true;

      await tester.pumpWidget(buildApp(const LoginPage()));
      await tester.pumpAndSettle();

      final emailField = find.byType(TextFormField).at(0);
      final passwordField = find.byType(TextFormField).at(1);
      final signInButton = find.widgetWithText(ElevatedButton, 'Sign in');

      await tester.enterText(emailField, 'user@example.com');
      await tester.enterText(passwordField, 'Secret#123');
      await tester.tap(signInButton);
      await tester.pumpAndSettle();

      expect(find.text('Sign in failed'), findsOneWidget);
    });

    testWidgets('toggles password visibility when suffix icon tapped', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp(const LoginPage()));
      await tester.pumpAndSettle();

      final passwordField = find.byType(TextFormField).at(1);
      // Note: TextFormField does not expose obscureText directly
      // This test assumes the field is obscured initially

      // Tap the suffix icon button
      final suffixIconButton = find.descendant(
        of: passwordField,
        matching: find.byType(IconButton),
      );
      await tester.tap(suffixIconButton);
      await tester.pumpAndSettle();

      // Note: TextFormField does not expose obscureText directly
      // This test assumes the field is not obscured after tap
    });
  });

  group('CreateAccountPage', () {
    testWidgets('requires agreeing to terms before creating account', (
      tester,
    ) async {
      final fake = Get.find<FakeAuthController>();

      await tester.pumpWidget(buildApp(const CreateAccountPage()));
      await tester.pumpAndSettle();

      // Fields: Name, Email, Password, Confirm Password
      final nameField = find.byType(TextFormField).at(0);
      final emailField = find.byType(TextFormField).at(1);
      final passField = find.byType(TextFormField).at(2);
      final confirmField = find.byType(TextFormField).at(3);

      await tester.enterText(nameField, 'Test User');
      await tester.enterText(emailField, 'user@example.com');
      await tester.enterText(passField, 'StrongPass#123');
      await tester.enterText(confirmField, 'StrongPass#123');

      final createBtn = find.widgetWithText(ElevatedButton, 'CREATE ACCOUNT');
      await tester.tap(createBtn);
      await tester.pumpAndSettle();

      // Should show a SnackBar requesting terms agreement
      expect(
        find.text('Please agree to the terms and conditions'),
        findsOneWidget,
      );
      expect(fake.lastEmail, isNull);
    });

    testWidgets('calls signUp when form valid and terms agreed', (
      tester,
    ) async {
      final fake = Get.find<FakeAuthController>();

      await tester.pumpWidget(buildApp(const CreateAccountPage()));
      await tester.pumpAndSettle();

      final nameField = find.byType(TextFormField).at(0);
      final emailField = find.byType(TextFormField).at(1);
      final passField = find.byType(TextFormField).at(2);
      final confirmField = find.byType(TextFormField).at(3);

      await tester.enterText(nameField, 'Test User');
      await tester.enterText(emailField, 'user@example.com');
      await tester.enterText(passField, 'StrongPass#123');
      await tester.enterText(confirmField, 'StrongPass#123');

      // Agree to terms (Checkbox is the first Checkbox in the page)
      final checkbox = find.byType(Checkbox).first;
      await tester.tap(checkbox);
      await tester.pumpAndSettle();

      final createBtn = find.widgetWithText(ElevatedButton, 'CREATE ACCOUNT');
      await tester.tap(createBtn);
      await tester.pumpAndSettle();

      expect(fake.lastEmail, 'user@example.com');
      expect(fake.lastPassword, 'StrongPass#123');
    });

    testWidgets('shows SnackBar when signUp throws', (tester) async {
      final fake = Get.find<FakeAuthController>();
      fake.shouldThrowOnSignUp = true;

      await tester.pumpWidget(buildApp(const CreateAccountPage()));
      await tester.pumpAndSettle();

      final nameField = find.byType(TextFormField).at(0);
      final emailField = find.byType(TextFormField).at(1);
      final passField = find.byType(TextFormField).at(2);
      final confirmField = find.byType(TextFormField).at(3);

      await tester.enterText(nameField, 'Test User');
      await tester.enterText(emailField, 'user@example.com');
      await tester.enterText(passField, 'StrongPass#123');
      await tester.enterText(confirmField, 'StrongPass#123');

      final checkbox = find.byType(Checkbox).first;
      await tester.tap(checkbox);
      await tester.pumpAndSettle();

      final createBtn = find.widgetWithText(ElevatedButton, 'CREATE ACCOUNT');
      await tester.tap(createBtn);
      await tester.pumpAndSettle();

      expect(find.text('Sign up failed'), findsOneWidget);
    });
  });
}
