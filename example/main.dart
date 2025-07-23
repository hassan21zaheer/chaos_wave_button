import 'package:chaos_wave_button/src/chaos_wave_button.dart';
import 'package:flutter/material.dart';

void main() {

  runApp(MyApp(
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Chaos Wave Buttons')),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                ChaosButton(
                  width: 250.0,
                  height: 70.0,
                  text: 'Chaos Button',
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: Colors.black),
                  backgroundColor: Colors.black,
                  lineColors: const [Colors.purpleAccent, Colors.blue, Colors.orange, Colors.green],
                  animationDuration: const Duration(milliseconds: 500),
                  onTap: () => print('Chaos Button Pressed!'),
                ),
                const SizedBox(height: 30),
                WaveButton(
                  width: 250.0,
                  height: 70.0,
                  text: 'Wave Button',
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: Colors.black),
                  backgroundColor: Colors.black,
                  lineColors: const [Colors.purpleAccent, Colors.blue, Colors.orange, Colors.green],
                  animationDuration: const Duration(milliseconds: 500),
                  onTap: () => print('Wave Button Pressed!'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}