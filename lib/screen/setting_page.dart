import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  static const String routeName = '/setting';
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting Page'),
      ),
      body: const Center(child: Text('SettingPage')),
    );
  }
}
