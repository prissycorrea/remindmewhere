import 'package:flutter/material.dart';
import 'create_reminder_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RemindMeWhere',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const CreateReminderPage(),
    );
  }
}
