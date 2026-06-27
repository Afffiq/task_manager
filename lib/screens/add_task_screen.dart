import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/task_service.dart';
import '../models/task_model.dart';

class AddTaskScreen extends StatefulWidget {

  final TaskModel? task;

  const AddTaskScreen({
    super.key,
    this.task,
  });


  

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TaskService taskService = TaskService();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  

  DateTime? taskDate;
  DateTime? dueDate;

  TimeOfDay? startTime;
  TimeOfDay? dueTime;

  String priority = "Medium";

  Future<void> pickTaskDate() async {
  final picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2035),
  );

  if (picked != null) {
    setState(() {
      taskDate = picked;
    });
  }
}

Future<void> pickDueDate() async {
  final picked = await showDatePicker(
    context: context,
    initialDate: taskDate ?? DateTime.now(),
    firstDate: taskDate ?? DateTime.now(),
    lastDate: DateTime(2035),
  );

  if (picked != null) {
    setState(() {
      dueDate = picked;
    });
  }
}

Future<void> pickStartTime() async {
  final picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );

  if (picked != null) {
    setState(() {
      startTime = picked;
    });
  }
}

Future<void> pickDueTime() async {
  final picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );

  if (picked != null) {
    setState(() {
      dueTime = picked;
    });
  }
}

Future<void> saveTask() async {
  if (titleController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter a task title'),
      ),
    );
    return;
  }

  if (taskDate == null ||
      dueDate == null ||
      startTime == null ||
      dueTime == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please complete all date and time fields'),
      ),
    );
    return;
  }

  final task = TaskModel(
    id: '',
    title: titleController.text.trim(),
    description: descriptionController.text.trim(),
    taskDate: taskDate!,
    dueDate: dueDate!,
    startTime: startTime!.format(context),
    dueTime: dueTime!.format(context),
    priority: priority,
    status: 'Pending',
    userId: '',
    createdAt: Timestamp.now(),
  );

  if (widget.task == null) {
  // Add new task
  await taskService.addTask(task);
} else {
  // Update existing task
  await taskService.updateTask(
    widget.task!.copyWith(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      taskDate: taskDate!,
      dueDate: dueDate!,
      startTime: startTime!.format(context),
      dueTime: dueTime!.format(context),
      priority: priority,
    ),
  );
}

if (!mounted) return;

Navigator.pop(context);
}

@override
void initState() {
  super.initState();

  if (widget.task != null) {
    titleController.text = widget.task!.title;
    descriptionController.text = widget.task!.description;

    taskDate = widget.task!.taskDate;
    dueDate = widget.task!.dueDate;

    priority = widget.task!.priority;

    startTime = _stringToTimeOfDay(widget.task!.startTime);
    dueTime = _stringToTimeOfDay(widget.task!.dueTime);
  }
}

TimeOfDay _stringToTimeOfDay(String time) {
  final parts = time.split(" ");

  final hm = parts[0].split(":");

  int hour = int.parse(hm[0]);
  int minute = int.parse(hm[1]);

  if (parts[1] == "PM" && hour != 12) {
    hour += 12;
  }

  if (parts[1] == "AM" && hour == 12) {
    hour = 0;
  }

  return TimeOfDay(
    hour: hour,
    minute: minute,
  );
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Add Task'),
    ),
    body: SingleChildScrollView(
  padding: const EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [

      // Task Title
      TextField(
        controller: titleController,
        decoration: const InputDecoration(
          labelText: 'Task Title',
          border: OutlineInputBorder(),
        ),
      ),

      const SizedBox(height: 16),

      // Description
      TextField(
        controller: descriptionController,
        maxLines: 3,
        decoration: const InputDecoration(
          labelText: 'Description',
          border: OutlineInputBorder(),
        ),
      ),

      const SizedBox(height: 16),

      // Task Date
      ElevatedButton(
        onPressed: pickTaskDate,
        child: Text(
          taskDate == null
              ? 'Select Task Date'
              : DateFormat('dd/MM/yyyy').format(taskDate!),
        ),
      ),

      const SizedBox(height: 12),

      // Due Date
      ElevatedButton(
        onPressed: pickDueDate,
        child: Text(
          dueDate == null
              ? 'Select Due Date'
              : DateFormat('dd/MM/yyyy').format(dueDate!),
        ),
      ),

      const SizedBox(height: 12),

      // Start Time
      ElevatedButton(
        onPressed: pickStartTime,
        child: Text(
          startTime == null
              ? 'Select Start Time'
              : startTime!.format(context),
        ),
      ),

      const SizedBox(height: 12),

      // Due Time
      ElevatedButton(
        onPressed: pickDueTime,
        child: Text(
          dueTime == null
              ? 'Select Due Time'
              : dueTime!.format(context),
        ),
      ),

      const SizedBox(height: 16),

      // Priority
      DropdownButtonFormField<String>(
        initialValue: priority,
        decoration: const InputDecoration(
          labelText: 'Priority',
          border: OutlineInputBorder(),
        ),
        items: const [
          DropdownMenuItem(
            value: 'Low',
            child: Text('Low'),
          ),
          DropdownMenuItem(
            value: 'Medium',
            child: Text('Medium'),
          ),
          DropdownMenuItem(
            value: 'High',
            child: Text('High'),
          ),
        ],
        onChanged: (value) {
          setState(() {
            priority = value!;
          });
        },
      ),

      const SizedBox(height: 24),

      ElevatedButton(
        onPressed: saveTask,
        child: const Text('Save Task'),
      ),
    ],
  ),
),
  );
}
}