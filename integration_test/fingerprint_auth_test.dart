import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  group('Fingerprint Authentication Tests', () {
    final localAuth = LocalAuthentication();

    test('Проверка дали устройството поддържа биометрия', () async {
      final isSupported = await localAuth.isDeviceSupported();
      expect(isSupported, true, reason: 'Устройството не поддържа биометрия.');
    });

    test('Проверка на наличието на записани пръстови отпечатъци', () async {
      final canCheckBiometrics = await localAuth.canCheckBiometrics;
      expect(canCheckBiometrics, true, reason: 'Няма налични биометрични данни на устройството.');
    });

    test('Успешно удостоверяване чрез пръстов отпечатък', () async {
      final authenticated = await localAuth.authenticate(
        localizedReason: 'Моля, използвайте пръстов отпечатък за удостоверяване.',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );
      expect(authenticated, true, reason: 'Удостоверяването чрез пръстов отпечатък се провали.');
    });
  });
}
