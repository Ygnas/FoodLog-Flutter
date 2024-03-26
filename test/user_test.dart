import 'package:flutter_test/flutter_test.dart';
import 'package:food_log/src/models/user.dart';

void main() {
  group('User Tests', () {
    test('User should be created from JSON', () {
      final Map<String, dynamic> userData = {
        'name': 'John Doe',
        'email': 'john@example.com',
        'token': 'example_token',
      };

      final User user = User.fromJson(userData);

      expect(user.name, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.token, 'example_token');
    });

    test('User should be created with default values', () {
      final User user = User();

      expect(user.name, '');
      expect(user.email, '');
      expect(user.token, '');
    });
  });
}
