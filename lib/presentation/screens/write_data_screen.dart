import 'package:flutter/material.dart';
import 'package:glocation/presentation/shared/custom_text_form_field.dart';
class WriteDataScreen extends StatelessWidget {
  const WriteDataScreen({super.key});
  static const name = 'WriteDataScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Write Data Screen'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Write Data Screen'),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CustomTextFormField(
                label: 'Name',
                hint: 'Enter your name',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to load data
              },
              child: const Text('Load Data'),
            ),
          ],
        ),
      ),
    );
  }
}