import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

List<int> _generateUniqueLightSignal(String email) {
  const uuid = Uuid();
  final digest = sha256.convert(utf8.encode(uuid.v5(Uuid.NAMESPACE_URL, email)));

  final random = Random();
  final generatedValues = <int>{};
  return List.generate(5, (i) {
    try {
      int signalValue = (int.parse(digest.toString().substring(i * 8, (i + 1) * 8), radix: 16) % 1100) + 200;
      while (!generatedValues.add(signalValue)) {
        signalValue = ((signalValue + random.nextInt(100)) % 1100) + 200;
      }
      return signalValue;
    } catch (_) {
      return 200 + i * 200;
    }
  });
}

void main() {
  group('Light Signal Generation Tests', () {
    test('Генериране на уникални светлинни сигнали', () {
      const email = 'example@domain.com';
      final signals = _generateUniqueLightSignal(email);

      expect(signals.length, 5);
      expect(signals.toSet().length, 5);

      for (final signal in signals) {
        expect(signal >= 200 && signal <= 1300, true, reason: 'Signal out of range');
      }
    });
  });
}
