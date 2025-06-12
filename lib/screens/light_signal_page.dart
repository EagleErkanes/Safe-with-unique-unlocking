import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:torch_light/torch_light.dart';
import 'dart:math';
import 'package:bio_app/styles.dart'; // Импортирайте AppStyles

class LightSignalPage extends StatefulWidget {
  final String uid;

  const LightSignalPage({required this.uid, super.key});

  @override
  _LightSignalPageState createState() => _LightSignalPageState();
}

class _LightSignalPageState extends State<LightSignalPage> {
  List<int>? _lightSignalPattern;
  final DatabaseReference _userRef = FirebaseDatabase.instance.ref("users");
  bool _isLoading = true;

  @override 
  void initState() {
    super.initState();
    _loadLightSignalPattern();
  }

  Future<void> _loadLightSignalPattern() async {
    DatabaseReference userRef = _userRef.child(widget.uid);
    DatabaseEvent event = await userRef.once();

    if (event.snapshot.exists &&
        (event.snapshot.value as Map).containsKey('lightSignal')) {
      setState(() {
        String lightSignal = (event.snapshot.value as Map)['lightSignal'];
        _lightSignalPattern = lightSignal.split(',').map(int.parse).toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _lightSignalPattern = _generateNewLightSignalPattern();
        _isLoading = false;
      });
    }
  }

 List<int> _generateNewLightSignalPattern() {
    Random random = Random();
    return List.generate(5, (index) => random.nextInt(1000) + 100);
  }

  void _generateLightSignal() async {
    if (_lightSignalPattern == null) return;
    await TorchLight.enableTorch();
    await _sendLightSignal(_lightSignalPattern!);
    await TorchLight.disableTorch();
  }

  Future<void> _sendLightSignal(List<int> signal) async {
    for (var interval in signal) {
      await TorchLight.enableTorch();
      await Future.delayed(Duration(milliseconds: interval));
      await TorchLight.disableTorch();
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Светлинен сигнал'),
        backgroundColor: AppStyles.primaryColor, // Използваме primaryColor от AppStyles
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  style: AppStyles.elevatedButtonTheme.style, // Използваме стила на бутона
                  onPressed: _generateLightSignal,
                  child: const Text(
                    'Генерирай сигнал',
                    style: AppStyles.buttonTextStyle, // Използваме текстовия стил от AppStyles
                  ),
                ),
        ),
      ),
    );
  }
}
