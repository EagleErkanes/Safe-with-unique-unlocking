import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:local_auth/local_auth.dart'; 
import 'light_signal_page.dart';
import 'package:bio_app/styles.dart'; 

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _pinController = TextEditingController();
  final _safeIdController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _localAuth = LocalAuthentication();

  Future<void> _loginUser() async {
    final email = _emailController.text.trim();
    final pin = _pinController.text.trim();
    final safeId = _safeIdController.text.trim();

    if ([email, pin, safeId].any((field) => field.isEmpty)) {
      _showMessage('Моля, попълнете всички полета.');
      return;
    }

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(email: email, password: pin);
      final uid = userCredential.user?.uid;

      if (uid != null) {
        final event = await FirebaseDatabase.instance.ref("users/$uid").once();
        final userData = event.snapshot.value as Map<dynamic, dynamic>?;

        if (userData?['safeId'] == safeId) {
          await _authenticateBiometric(uid);
        } else {
          _showMessage('Грешен Safe ID.');
        }
      } else {
        _showMessage('Грешка при вход.');
      }
    } catch (e) {
      _showMessage('Грешка при вход: $e');
    }
  }

Future<void> _authenticateBiometric(String uid) async {
  try {
    if (await _localAuth.canCheckBiometrics) {
      if (await _localAuth.authenticate(
        localizedReason: 'Моля, удостоверете се с пръстов отпечатък.',
        options: const AuthenticationOptions(useErrorDialogs: true, stickyAuth: true),
      )) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LightSignalPage(uid: uid)),
        );
      } else {
        _showMessage('Биометричната верификация неуспешна.');
      }
    } else {
      _showMessage('На устройството няма настроен пръстов отпечатък. Настройте биометрия от настройките за устройсвто за да продължите.');
    }
  } catch (e) {
    _showMessage('Неуспешна опция за биометрия. Уверете се, че устройството поддържа и е настроено за биометрия.');
    print('Детайли за грешката: $e');
  }
}


  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вписване'),
        backgroundColor: AppStyles.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(Icons.login, size: 80, color: AppStyles.primaryColor),
            const SizedBox(height: 20),
            _buildTextField(_emailController, 'Имейл адрес', TextInputType.emailAddress),
            const SizedBox(height: 20),
            _buildTextField(_pinController, 'Пин код', TextInputType.number, obscureText: true),
            const SizedBox(height: 20),
            _buildTextField(_safeIdController, 'Safe ID', TextInputType.text),
            const SizedBox(height: 40),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: ElevatedButton(
                onPressed: _loginUser,
                style: AppStyles.elevatedButtonTheme.style,
                child: const Text('Влез', style: AppStyles.buttonTextStyle),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, TextInputType inputType, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      decoration: AppStyles.inputDecorationTheme.copyWith(labelText: label),
      keyboardType: inputType,
      obscureText: obscureText,
    );
  }
}
