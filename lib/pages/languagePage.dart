import 'package:flutter/material.dart';

class LanguagePage extends StatelessWidget {
  final List _languages = [
    'English',
    'Hindi',
    'Malayalam',
    'Marathi',
    'Tamil',
    'Kannada'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language Settings'),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
