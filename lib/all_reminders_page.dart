import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class AllRemindersPage extends StatelessWidget {
  final List<Map<String, dynamic>> allReminders;

  const AllRemindersPage({super.key, required this.allReminders});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4F66FF),
        title: const Text('Todos os lembretes'),
      ),
      body:
          allReminders.isEmpty
              ? const Center(
                child: Text(
                  'Nenhum lembrete cadastrado.',
                  style: TextStyle(color: Colors.white70),
                ),
              )
              : ListView.builder(
                itemCount: allReminders.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final reminder = allReminders[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5473A9).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          reminder['done']
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reminder['title'] ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                reminder['locationName'] ?? '',
                                style: const TextStyle(color: Colors.white70),
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
                              '${reminder['distance'] ?? ''}m',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
