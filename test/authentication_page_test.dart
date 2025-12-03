import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/authentication_page.dart';

void main() {
  group('AuthenticationPage widget tests', () {
    testWidgets('scaffold shows sign-in UI elements', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthenticationPage()));

      // Google sign-in button present
      expect(find.text('Sign in with Google'), findsOneWidget);

      // Two text fields (email and password) are present
      expect(find.byType(TextField), findsNWidgets(2));

      // Sign in and Sign up buttons exist
      expect(find.widgetWithText(ElevatedButton, 'Sign in'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Sign up'), findsOneWidget);
    });
  });
}
