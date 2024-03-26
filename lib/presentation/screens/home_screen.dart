import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const name = 'HomeScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.push('/writeData');
              },
              child: const Text('Write Data'),
            ),
            ElevatedButton(
              onPressed: () {
                context.push('/loadData');
              },
              child: const Text('Load Data'),
            ),
          ],
        ),
      ),
    );
  }
}