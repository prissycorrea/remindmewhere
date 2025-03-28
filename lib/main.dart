import 'package:flutter/material.dart';
import 'package:remindmewhere/home_page.dart';
import 'create_reminder_page.dart';
import 'profile_page.dart';

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
      home: HomePage(),
      routes: {
        '/create': (context) => const CreateReminderPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
