import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:bio_app/styles.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _emailController = TextEditingController();
  final _pinController = TextEditingController();
  final _safeIdController = TextEditingController();
  final _database = FirebaseDatabase.instance;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

List<int> _generateUniqueLightSignal(String email) {
  const uuid = Uuid();
  final digest = sha256.convert(utf8.encode(uuid.v5(Uuid.NAMESPACE_URL, email)));

  final random = Random();
  final generatedValues = <int>{};
  return List.generate(5, (i) {
    try {
      // Ограничаване на стойностите до рамките 200–1300
      int signalValue = (int.parse(digest.toString().substring(i * 8, (i + 1) * 8), radix: 16) % 1100) + 200;
      while (!generatedValues.add(signalValue)) {
        signalValue = ((signalValue + random.nextInt(100)) % 1100) + 200;
      }
      return signalValue;
    } catch (_) {
      // Фиксирани стойности при грешка
      return 200 + i * 200;
    }
  });
}




  bool _validateEmail(String email) => RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email);

  Future<void> _registerUser() async {
    final email = _emailController.text.trim();
    final pin = _pinController.text.trim();
    final safeId = _safeIdController.text.trim();

    if ([email, pin, safeId].any((field) => field.isEmpty)) {
      _showSnackBar('Моля, попълнете всички полета.');
      return;
    }

    if (!_validateEmail(email)) {
      _showSnackBar('Моля, въведете валиден имейл адрес.');
      return;
    }

    try {
      final usersRef = _database.ref('users');
      final userEvent = await usersRef.orderByChild('safeId').equalTo(safeId).once();
      final usersForSafe = userEvent.snapshot.value as Map<dynamic, dynamic>?;

      if (usersForSafe != null && usersForSafe.length >= 3) {
        _showSnackBar('Safe ID вече има 3 регистрирани акаунта.');
        return;
      }

      final userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: pin);
      final uid = userCredential.user!.uid;

      await usersRef.child(uid).set({
        'email': email,
        'pin': sha256.convert(utf8.encode(pin)).toString(),
        'lightSignal': _generateUniqueLightSignal(email).join(','),
        'safeId': safeId,
      });

      _clearControllers();
      _showDialog('Успех!', 'Регистрацията е успешна!', () {
        Navigator.pop(context);
        Navigator.pushNamed(context, '/login');
      });
    } catch (e) {
      _showSnackBar('Грешка при регистрация: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showDialog(String title, String content, VoidCallback onPressed) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(onPressed: onPressed, child: const Text('OK')),
        ],
      ),
    );
  }

  void _clearControllers() {
    _emailController.clear();
    _pinController.clear();
    _safeIdController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация'),
        backgroundColor: AppStyles.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(Icons.person_add, size: 80, color: AppStyles.primaryColor),
            const SizedBox(height: 40),
            _buildTextField(controller: _emailController, label: 'Имейл адрес', keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 20),
            _buildTextField(controller: _pinController, label: 'Пин код', obscureText: true, keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            _buildTextField(controller: _safeIdController, label: 'Safe ID', keyboardType: TextInputType.text),
            const SizedBox(height: 40),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: ElevatedButton(
                onPressed: _registerUser,
                style: AppStyles.elevatedButtonTheme.style,
                child: const Text('Регистрирай се', style: AppStyles.buttonTextStyle),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      decoration: AppStyles.inputDecorationTheme.copyWith(labelText: label),
      obscureText: obscureText,
      keyboardType: keyboardType,
    );
  }
}
