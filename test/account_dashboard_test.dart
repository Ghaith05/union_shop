import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/account_dashboard.dart';
import 'package:union_shop/data/auth_service.dart';
import 'package:union_shop/data/user.dart';

void main() {
  testWidgets('AccountDashboard allows editing profile', (tester) async {
    // Set a starting user in the singleton service
    final auth = AuthenticationService();
    auth.currentUser.value = User(id: 'u1', email: 'a@b.com', name: 'Alice');

    await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: AccountDashboardBody())));
    await tester.pumpAndSettle();

    // Verify initial values
    expect(find.text('Name: Alice'), findsOneWidget);
    expect(find.text('Email: a@b.com'), findsOneWidget);

    // Tap Edit profile
    await tester.tap(find.text('Edit profile'));
    await tester.pumpAndSettle();

    // Enter new name and email
    await tester.enterText(find.byType(TextField).at(0), 'Bob');
    await tester.enterText(find.byType(TextField).at(1), 'bob@gmail.com');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));

    // Wait for dialog to close and UI update
    await tester.pumpAndSettle();

    // Expect updated values reflected in UI
    expect(find.text('Name: Bob'), findsOneWidget);
    expect(find.text('Email: bob@gmail.com'), findsOneWidget);
  });
}
