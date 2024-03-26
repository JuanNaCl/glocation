import 'package:flutter/material.dart';
class LoadDataScreen extends StatelessWidget {
  const LoadDataScreen({super.key});
  static const name = 'LoadDataScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Load Data Screen'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              // Navigate to writeData
            },
            child: const Text('Write Data'),
          ),
        ],
      ),
    );
  }
}