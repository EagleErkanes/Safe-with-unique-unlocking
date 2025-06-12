import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bio_app/main.dart'; // Replace "bio_app" with your actual project name
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

void main() {
  // Initialize the integration test environment
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Firebase Auth and Database Tests', () {
    setUpAll(() async {
      // Initialize Firebase
      await Firebase.initializeApp();
      print('Firebase successfully initialized!');
    });

    testWidgets('Register user and save data in Firebase', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Test user registration
      const email = 'testuser2@example.com'; // Update this for unique test cases
      const password = 'securePassword123';
      const safeId = 'safe123';

      // Register the user in Firebase Auth
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
      );
      expect(userCredential.user, isNotNull);
      final uid = userCredential.user!.uid;
      print('User registered successfully: UID=$uid');

      // Generate hashed PIN for the database entry
      final hashedPin = sha256.convert(utf8.encode(password)).toString();

      // Save user details to Firebase Database
      await FirebaseDatabase.instance.ref('users/$uid').set({
        'email': email,
        'pin': hashedPin,
        'safeId': safeId,
        'lightSignal': '200,300,400,500,600' // Example signal
      });

      // Verify the database entry
      final snapshot = await FirebaseDatabase.instance.ref('users/$uid').once();
      expect(snapshot.snapshot.value, {
        'email': email,
        'pin': hashedPin,
        'safeId': safeId,
        'lightSignal': '200,300,400,500,600'
      });
      print('Data saved successfully in Firebase Database');
    });
  });
}
