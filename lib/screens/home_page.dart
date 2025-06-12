import 'package:flutter/material.dart';
import 'package:bio_app/styles.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добре дошли'),
        backgroundColor: AppStyles.primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, size: 100, color: AppStyles.primaryColor),
            const SizedBox(height: 40),
            _buildButton(context, 'Регистрация', '/registration', Icons.person_add),
            const SizedBox(height: 30),
            _buildButton(context, 'Вписване', '/login', Icons.login),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, String route, IconData icon) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: ElevatedButton.icon(
        style: AppStyles.elevatedButtonTheme.style,
        onPressed: () => Navigator.pushNamed(context, route),
        icon: Icon(icon),
        label: Text(text, style: AppStyles.buttonTextStyle),
      ),
    );
  }
}
