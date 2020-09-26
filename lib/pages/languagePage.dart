import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguagePage extends StatelessWidget {
  final List _languages = [
    'English',
    'हिंदी',
    'മലയാളം',
    'मराठी',
    'தமிழ்',
    'ಕನ್ನಡ'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('langset'.tr()),
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
