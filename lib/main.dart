import 'package:flutter/material.dart';

void main() {
  runApp(const RemindMeWhereApp());
}

class RemindMeWhereApp extends StatelessWidget {
  const RemindMeWhereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RemindMeWhere',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _navigateToAddReminder(BuildContext context) {
    // Vamos implementar essa tela depois
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddReminderPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RemindMeWhere')),
      body: const Center(child: Text('Nenhum lembrete cadastrado ainda.')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddReminder(context),
        child: const Icon(Icons.add_location_alt),
      ),
    );
  }
}

class AddReminderPage extends StatelessWidget {
  const AddReminderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo lembrete')),
      body: const Center(child: Text('Formulário para novo lembrete')),
    );
  }
}
