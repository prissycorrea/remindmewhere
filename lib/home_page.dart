import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:remindmewhere/all_reminders_page.dart';

class Reminder {
  final String title;
  final String location;
  final int distance;
  bool done;
  DateTime? completedAt;

  Reminder({
    required this.title,
    required this.location,
    required this.distance,
    this.done = false,
    this.completedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'location': location,
      'distance': distance,
      'done': done,
      'completedAt': completedAt?.toIso8601String(),
    };
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Reminder> _reminders = [
    Reminder(
      title: 'Comprar ração',
      location: 'Petz - Av. Marginal Tietê',
      distance: 500,
    ),
    Reminder(
      title: 'Farmácia',
      location: 'Droga Raia - Av. Paulista',
      distance: 300,
      done: true,
      completedAt: DateTime.now(),
    ),
    Reminder(title: 'Padaria', location: 'Padaria do Zé', distance: 150),
  ];

  void toggleDone(Reminder reminder) {
    setState(() {
      reminder.done = true;
      reminder.completedAt = DateTime.now();
    });
  }

  void deleteReminder(Reminder reminder) {
    setState(() {
      _reminders.remove(reminder);
    });
  }

  void editReminder(Reminder reminder) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Função de edição em desenvolvimento')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingReminders = _reminders.where((r) => !r.done).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: const BoxDecoration(
                color: Color(0xFF4F66FF),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Olá, Logan',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Seus próximos lembretes',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Botão Novo Lembrete
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/create'),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F66FF),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Novo lembrete',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Lista de lembretes pendentes
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: pendingReminders.length,
                itemBuilder: (context, index) {
                  final reminder = pendingReminders[index];
                  return Dismissible(
                    key: UniqueKey(),
                    background: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.centerLeft,
                      color: Colors.orange,
                      child: const Icon(Icons.edit, color: Colors.white),
                    ),
                    secondaryBackground: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.centerRight,
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        editReminder(reminder);
                        return false;
                      } else {
                        deleteReminder(reminder);
                        return true;
                      }
                    },
                    child: GestureDetector(
                      onTap: () => toggleDone(reminder),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5473A9).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_box_outline_blank,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    reminder.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    reminder.location,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.redAccent,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${reminder.distance}m',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF4F66FF),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 1,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => AllRemindersPage(
                      allReminders: _reminders.map((r) => r.toMap()).toList(),
                    ),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FeatherIcons.user),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(FeatherIcons.calendar),
            label: 'Todos os lembretes',
          ),
        ],
      ),
    );
  }
}
