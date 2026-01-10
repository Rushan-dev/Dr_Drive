import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class ComplianceManagerScreen extends StatefulWidget {
  const ComplianceManagerScreen({super.key});

  @override
  State<ComplianceManagerScreen> createState() => _ComplianceManagerScreenState();
}

class _ComplianceManagerScreenState extends State<ComplianceManagerScreen> {
  final List<Reminder> _reminders = [
    Reminder(
      id: '1',
      title: 'Vehicle Service Due',
      description: 'Oil change and general maintenance',
      dateTime: DateTime.now().add(const Duration(days: 7)),
      priority: Priority.high,
      isCompleted: false,
    ),
    Reminder(
      id: '2',
      title: 'Insurance Renewal',
      description: 'Auto insurance expires soon',
      dateTime: DateTime.now().add(const Duration(days: 14)),
      priority: Priority.medium,
      isCompleted: false,
    ),
    Reminder(
      id: '3',
      title: 'License Check',
      description: 'Verify license validity',
      dateTime: DateTime.now().add(const Duration(days: 30)),
      priority: Priority.low,
      isCompleted: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder Dashboard'),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddReminderDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Cards
          Container(
            padding: const EdgeInsets.all(16),
            color: backgroundColor,
            child: Row(
              children: [
                _buildSummaryCard(
                  'Total',
                  _reminders.length.toString(),
                  Icons.list,
                  primaryColor,
                ),
                const SizedBox(width: 12),
                _buildSummaryCard(
                  'Pending',
                  _reminders.where((r) => !r.isCompleted).length.toString(),
                  Icons.pending,
                  warningColor,
                ),
                const SizedBox(width: 12),
                _buildSummaryCard(
                  'Completed',
                  _reminders.where((r) => r.isCompleted).length.toString(),
                  Icons.check_circle,
                  successColor,
                ),
              ],
            ),
          ),

          // Reminders List
          Expanded(
            child: _reminders.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _reminders.length,
                    itemBuilder: (context, index) {
                      return _buildReminderCard(_reminders[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String count, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: kCardDecoration,
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              count,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
                fontFamily: 'Roboto',
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: textSecondary,
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No reminders yet',
            style: TextStyle(
              fontSize: 20,
              color: textSecondary,
              fontFamily: 'Roboto',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first reminder to stay organized',
            style: TextStyle(
              fontSize: 14,
              color: textSecondary,
              fontFamily: 'Roboto',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddReminderDialog(),
            icon: const Icon(Icons.add),
            label: const Text('Add Reminder'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderCard(Reminder reminder) {
    return Dismissible(
      key: Key(reminder.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: errorColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) => _deleteReminder(reminder.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: kCardDecoration.copyWith(
          border: Border.all(
            color: reminder.isCompleted ? successColor.withValues(alpha: 0.3) : Colors.transparent,
            width: 2,
          ),
        ),
        child: ListTile(
          leading: Checkbox(
            value: reminder.isCompleted,
            onChanged: (value) => _toggleReminder(reminder.id),
            activeColor: successColor,
          ),
          title: Text(
            reminder.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: reminder.isCompleted ? textSecondary : textPrimary,
              decoration: reminder.isCompleted ? TextDecoration.lineThrough : null,
              fontFamily: 'Roboto',
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                reminder.description,
                style: TextStyle(
                  fontSize: 14,
                  color: textSecondary,
                  fontFamily: 'Roboto',
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDateTime(reminder.dateTime),
                    style: TextStyle(
                      fontSize: 12,
                      color: textSecondary,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildPriorityChip(reminder.priority),
                ],
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditReminderDialog(reminder),
          ),
          onTap: () => _showEditReminderDialog(reminder),
        ),
      ),
    );
  }

  Widget _buildPriorityChip(Priority priority) {
    Color color;
    String label;

    switch (priority) {
      case Priority.high:
        color = errorColor;
        label = 'High';
      case Priority.medium:
        color = warningColor;
        label = 'Medium';
      case Priority.low:
        color = successColor;
        label = 'Low';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
        ),
      ),
    );
  }

  void _showAddReminderDialog() {
    _showReminderDialog(null);
  }

  void _showEditReminderDialog(Reminder reminder) {
    _showReminderDialog(reminder);
  }

  void _showReminderDialog(Reminder? reminder) {
    final isEditing = reminder != null;
    final titleController = TextEditingController(text: reminder?.title ?? '');
    final descriptionController = TextEditingController(text: reminder?.description ?? '');
    DateTime selectedDate = reminder?.dateTime ?? DateTime.now().add(const Duration(days: 1));
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(reminder?.dateTime ?? DateTime.now());
    Priority selectedPriority = reminder?.priority ?? Priority.medium;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(isEditing ? 'Edit Reminder' : 'Add Reminder'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Enter reminder title',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter reminder details',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (date != null) {
                            setState(() => selectedDate = date);
                          }
                        },
                        icon: const Icon(Icons.calendar_today),
                        label: Text(_formatDate(selectedDate)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: selectedTime,
                          );
                          if (time != null) {
                            setState(() => selectedTime = time);
                          }
                        },
                        icon: const Icon(Icons.access_time),
                        label: Text(selectedTime.format(context)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<Priority>(
                  initialValue: selectedPriority,
                  decoration: const InputDecoration(
                    labelText: 'Priority',
                  ),
                  items: Priority.values.map((priority) {
                    return DropdownMenuItem(
                      value: priority,
                      child: Text(priority.name.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedPriority = value);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  final dateTime = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );

                  if (isEditing) {
                    _updateReminder(
                      reminder.id,
                      titleController.text,
                      descriptionController.text,
                      dateTime,
                      selectedPriority,
                    );
                  } else {
                    _addReminder(
                      titleController.text,
                      descriptionController.text,
                      dateTime,
                      selectedPriority,
                    );
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(isEditing ? 'Update' : 'Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _addReminder(String title, String description, DateTime dateTime, Priority priority) {
    final newReminder = Reminder(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      dateTime: dateTime,
      priority: priority,
      isCompleted: false,
    );
    setState(() {
      _reminders.add(newReminder);
    });
  }

  void _updateReminder(String id, String title, String description, DateTime dateTime, Priority priority) {
    setState(() {
      final index = _reminders.indexWhere((r) => r.id == id);
      if (index != -1) {
        _reminders[index] = Reminder(
          id: id,
          title: title,
          description: description,
          dateTime: dateTime,
          priority: priority,
          isCompleted: _reminders[index].isCompleted,
        );
      }
    });
  }

  void _toggleReminder(String id) {
    setState(() {
      final index = _reminders.indexWhere((r) => r.id == id);
      if (index != -1) {
        _reminders[index] = Reminder(
          id: _reminders[index].id,
          title: _reminders[index].title,
          description: _reminders[index].description,
          dateTime: _reminders[index].dateTime,
          priority: _reminders[index].priority,
          isCompleted: !_reminders[index].isCompleted,
        );
      }
    });
  }

  void _deleteReminder(String id) {
    setState(() {
      _reminders.removeWhere((r) => r.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reminder deleted')),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.inDays == 0) {
      return 'Today ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Tomorrow ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${dateTime.weekday == 1 ? 'Mon' : dateTime.weekday == 2 ? 'Tue' : dateTime.weekday == 3 ? 'Wed' : dateTime.weekday == 4 ? 'Thu' : dateTime.weekday == 5 ? 'Fri' : dateTime.weekday == 6 ? 'Sat' : 'Sun'} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${dateTime.day}/${dateTime.month} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class Reminder {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final Priority priority;
  final bool isCompleted;

  Reminder({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.priority,
    required this.isCompleted,
  });
}

enum Priority { low, medium, high }