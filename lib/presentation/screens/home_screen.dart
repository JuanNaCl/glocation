import 'package:flutter/material.dart';
import 'package:glocation/presentation/shared/custom_filled_button.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const name = 'HomeScreen';
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icon.jpg'),
            const SizedBox( height: 20),

            SizedBox(
              width: size.width * 0.8,
              height: 50,
              child: CustomFilledButton(
                buttonColor: Colors.black,
                onPressed: () {
                  context.push('/writeData');
                },
                text: ('Write Data'),
              ),
            ),
            const SizedBox( height: 10),
            SizedBox(
              width: size.width * 0.8,
              height: 50,
              child: CustomFilledButton(
                onPressed: () {
                  context.push('/loadData');
                },
                text: ('Load Data'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}