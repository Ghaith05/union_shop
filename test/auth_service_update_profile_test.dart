import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/data/auth_service.dart';
import 'package:union_shop/data/user.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  setUpAll(() async {
    try {
      await Firebase.initializeApp();
    } catch (_) {}
  });

  group('AuthenticationService.updateProfile', () {
    final auth = AuthenticationService();

    setUp(() {
      auth.currentUser.value = User(id: 'u1', email: 'a@b.com', name: 'Alice');
    });

    test('updates name in-memory when no Firebase', () async {
      await auth.updateProfile(name: 'Alice Smith');
      expect(auth.currentUser.value?.name, 'Alice Smith');
      expect(auth.currentUser.value?.email, 'a@b.com');
    });

    test('rejects non-gmail email updates', () async {
      expect(() => auth.updateProfile(email: 'user@notgmail.com'),
          throwsException);
      // ensure email unchanged
      expect(auth.currentUser.value?.email, 'a@b.com');
    });

    test('accepts gmail updates', () async {
      await auth.updateProfile(email: 'alice@gmail.com');
      expect(auth.currentUser.value?.email, 'alice@gmail.com');
    });
  });
}
