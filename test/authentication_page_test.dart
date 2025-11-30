import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/authentication_page.dart';

void main() {
  group('AuthenticationPage widget tests', () {
    testWidgets('scaffold shows tabs and login form by default',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthenticationPage()));

      // Tabs present
      expect(find.byKey(const Key('tab_login')), findsOneWidget);
      expect(find.byKey(const Key('tab_signup')), findsOneWidget);

      // Login form visible by default
      expect(find.byKey(const Key('login_email')), findsOneWidget);
      expect(find.byKey(const Key('login_password')), findsOneWidget);
      expect(find.byKey(const Key('login_button')), findsOneWidget);
    });

    testWidgets('login form validation and submit shows SnackBar',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthenticationPage()));

      // Tap login without input -> validation messages
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();
      expect(find.text('Enter email'), findsOneWidget);

      // Fill valid credentials and submit
      await tester.enterText(find.byKey(const Key('login_email')), 'a@b.com');
      await tester.enterText(find.byKey(const Key('login_password')), '123456');
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      // SnackBar shown
      expect(find.text('Login submitted'), findsOneWidget);
    });

    testWidgets('signup tab shows signup form and validates', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthenticationPage()));

      // Switch to Signup tab
      await tester.tap(find.text('Signup'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('signup_name')), findsOneWidget);
      expect(find.byKey(const Key('signup_email')), findsOneWidget);
      expect(find.byKey(const Key('signup_password')), findsOneWidget);

      // Attempt submit without filling -> validation
      await tester.tap(find.byKey(const Key('signup_button')));
      await tester.pumpAndSettle();
      expect(find.text('Enter name'), findsOneWidget);

      // Fill and submit
      await tester.enterText(find.byKey(const Key('signup_name')), 'Test User');
      await tester.enterText(find.byKey(const Key('signup_email')), 'u@u.com');
      await tester.enterText(
          find.byKey(const Key('signup_password')), 'abcdef');
      await tester.tap(find.byKey(const Key('signup_button')));
      await tester.pump();
      expect(find.text('Signup submitted'), findsOneWidget);
    });
  });
}
