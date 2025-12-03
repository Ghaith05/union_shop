import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/data/user.dart';

void main() {
  test('User toJson and fromJson round-trip', () {
    final user = User(id: 'u1', email: 'test@example.com', name: 'Test Name');
    final json = user.toJson();
    expect(json['id'], 'u1');
    expect(json['email'], 'test@example.com');
    expect(json['name'], 'Test Name');

    final parsed = User.fromJson(json);
    expect(parsed.id, user.id);
    expect(parsed.email, user.email);
    expect(parsed.name, user.name);
  });
}
