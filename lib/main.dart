import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/registration_page.dart';
import 'screens/login_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/registration': (context) => const RegistrationPage(),
        '/login': (context) => const LoginPage(),
        
      },
    );
  }
}