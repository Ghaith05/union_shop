import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/data/auth_service.dart';

void main() {
  group('AuthenticationService email flows (fallback)', () {
    final auth = AuthenticationService();

    setUp(() {
      auth.currentUser.value = null;
    });

    test('signUpWithEmail fallback creates in-memory user', () async {
      final user = await auth.signUpWithEmail('joe@example.com', 'password');
      expect(user.email, 'joe@example.com');
      expect(auth.currentUser.value?.email, 'joe@example.com');
    });

    test('signInWithEmail fallback creates in-memory user', () async {
      final user = await auth.signInWithEmail('sue@example.com', 'password');
      expect(user.email, 'sue@example.com');
      expect(auth.currentUser.value?.email, 'sue@example.com');
    });

    test('invalid email throws', () async {
      expect(() => auth.signInWithEmail('not-an-email', 'pw'), throwsException);
      expect(() => auth.signUpWithEmail('bad', 'pw'), throwsException);
    });
  });
}
