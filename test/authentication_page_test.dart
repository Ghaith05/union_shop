import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/authentication_page.dart';

void main() {
  group('AuthenticationPage widget tests', () {
    testWidgets('scaffold shows tabs and login UI elements', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthenticationPage()));

      // Tabs present
      expect(find.byKey(const Key('tab_login')), findsOneWidget);
      expect(find.byKey(const Key('tab_signup')), findsOneWidget);

      // Login UI visible by default
      expect(find.byKey(const Key('login_email')), findsOneWidget);
      expect(find.byKey(const Key('login_password')), findsOneWidget);
      expect(find.byKey(const Key('login_button')), findsOneWidget);
    });

    testWidgets('signup tab shows signup UI elements', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthenticationPage()));

      // Switch to Signup tab
      await tester.tap(find.text('Signup'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('signup_name')), findsOneWidget);
      expect(find.byKey(const Key('signup_email')), findsOneWidget);
      expect(find.byKey(const Key('signup_password')), findsOneWidget);
      expect(find.byKey(const Key('signup_button')), findsOneWidget);

      // Tapping disabled button should not throw
      await tester.tap(find.byKey(const Key('signup_button')));
      await tester.pumpAndSettle();
    });
  });
}
