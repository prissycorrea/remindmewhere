import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AllRemindersPage extends StatefulWidget {
  final List<Map<String, dynamic>> allReminders;

  const AllRemindersPage({super.key, required this.allReminders});

  @override
  State<AllRemindersPage> createState() => _AllRemindersPageState();
}

class _AllRemindersPageState extends State<AllRemindersPage> {
  bool showCompleted = false;

  void toggleDone(int index) {
    setState(() {
      final reminder = widget.allReminders[index];
      reminder['done'] = !(reminder['done'] ?? false);
      reminder['completedAt'] =
          reminder['done'] ? DateTime.now().toIso8601String() : null;
    });
  }

  void deleteReminder(int index) {
    setState(() {
      widget.allReminders.removeAt(index);
    });
  }

  void editReminder(int index) {
    // Navegação ou lógica de edição pode ser implementada aqui
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Função de edição em desenvolvimento')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredReminders =
        widget.allReminders.where((reminder) {
          return reminder['done'] == showCompleted;
        }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        title: Text(showCompleted ? 'Concluídos' : 'Não concluídos'),
        backgroundColor: const Color(0xFF4F66FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ToggleButtons(
              isSelected: [!showCompleted, showCompleted],
              onPressed: (index) {
                setState(() {
                  showCompleted = index == 1;
                });
              },
              borderRadius: BorderRadius.circular(10),
              selectedColor: Colors.white,
              fillColor: const Color(0xFF4F66FF),
              color: Colors.white70,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Não concluídos'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Concluídos'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredReminders.length,
                itemBuilder: (context, index) {
                  final reminder = filteredReminders[index];
                  final done = reminder['done'] ?? false;
                  final completedAt = reminder['completedAt'];
                  final formattedDate =
                      completedAt != null
                          ? DateFormat(
                            'dd/MM/yyyy HH:mm',
                          ).format(DateTime.parse(completedAt))
                          : null;

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
                      if (done) return false;
                      if (direction == DismissDirection.startToEnd) {
                        editReminder(widget.allReminders.indexOf(reminder));
                        return false;
                      } else {
                        deleteReminder(widget.allReminders.indexOf(reminder));
                        return true;
                      }
                    },
                    child: GestureDetector(
                      onTap:
                          () =>
                              toggleDone(widget.allReminders.indexOf(reminder)),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              done
                                  ? const Color(0xFF3A3A3C)
                                  : const Color(0xFF5473A9).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              done
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
                                    reminder['location'] ?? '',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                  if (formattedDate != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      'Concluído em: $formattedDate',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white54,
                                      ),
                                    ),
                                  ],
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
                                  '${reminder['distance']}m',
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
    );
  }
}
