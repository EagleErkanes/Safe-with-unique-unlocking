import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:bio_app/main.dart'; 

void main() {
  group('Application Health Check', () {
    testWidgets('Проверка дали приложението се стартира без проблеми', (WidgetTester tester) async {
      // Стартираме приложението
      await tester.pumpWidget(const MyApp()); 

      // Проверяваме дали основният екран е зареден
      expect(find.byType(MaterialApp), findsOneWidget, reason: 'MaterialApp не е намерен');
      expect(find.byType(Scaffold), findsOneWidget, reason: 'Основният Scaffold не е намерен');

      print('Приложението стартира без проблеми!');
    });

    testWidgets('Проверка на основни интерактивни елементи', (WidgetTester tester) async {
      // Стартираме приложението
      await tester.pumpWidget(const MyApp());

      // Проверяваме дали бутонът за регистрация се появява
      expect(find.text('Регистрация'), findsOneWidget, reason: 'Бутонът "Регистрация" липсва');
      expect(find.text('Вписване'), findsOneWidget, reason: 'Бутонът "Вписване" липсва');
      
      // Проверка за други основни елементи (например, заглавие или меню)
      expect(find.text('Добре дошли'), findsOneWidget, reason: 'Заглавието "Добре дошли" липсва');
      
      print('Всички основни интерактивни елементи са заредени!');
    });
  });
}
