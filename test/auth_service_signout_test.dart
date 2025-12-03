import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/data/auth_service.dart';
import 'package:union_shop/data/user.dart';

void main() {
  group('AuthenticationService.signOut', () {
    final auth = AuthenticationService();

    setUp(() {
      auth.currentUser.value = User(id: 'u2', email: 'z@b.com', name: 'Zed');
    });

    test('clears currentUser', () async {
      await auth.signOut();
      expect(auth.currentUser.value, isNull);
    });
  });
}
