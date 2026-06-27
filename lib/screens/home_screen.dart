import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskService taskService = TaskService();
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Task Manager'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Logout"),
        content: const Text(
          "Are you sure you want to logout?",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text("Logout"),
          ),
        ],
      );
    },
  );

  if (confirm == true) {
    await authService.logout();
  }
},
        ),
      ],
    ),
    body: StreamBuilder<List<TaskModel>>(
  stream: taskService.getTasks(),
  builder: (context, snapshot) {

  if (snapshot.connectionState == ConnectionState.waiting) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  if (snapshot.hasError) {
    return Center(
      child: Text(snapshot.error.toString()),
    );
  }

  if (!snapshot.hasData || snapshot.data!.isEmpty) {
    return const Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.task_alt,
        size: 80,
        color: Colors.grey,
      ),
      SizedBox(height: 16),
      Text(
        "No tasks yet",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 8),
      Text(
        "Tap the + button to create your first task.",
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
    ],
  ),
);
  }

  final tasks = snapshot.data!;

  return ListView.builder(
    itemCount: tasks.length,
    itemBuilder: (context, index) {
      final task = tasks[index];

      return Card(
  margin: const EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 8,
  ),
  elevation: 3,
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Expanded(
              child: Text(
                task.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Chip(
  label: Text(
    task.priority,
    style: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  ),
  backgroundColor:
      task.priority == "High"
          ? Colors.red
          : task.priority == "Medium"
              ? Colors.orange
              : Colors.green,
),

          ],
        ),

        const SizedBox(height: 10),

        Text(task.description),

        const SizedBox(height: 15),

        Text("Task Date : ${task.taskDate.day}/${task.taskDate.month}/${task.taskDate.year}"),

        Text("Due Date : ${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}"),

        Text("Time : ${task.startTime} - ${task.dueTime}"),

        const SizedBox(height: 10),

        Row(
  children: [

    Expanded(
      child: Text(
        "Status : ${task.status}",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: task.status == "Completed"
              ? Colors.green
              : Colors.orange,
        ),
      ),
    ),

    IconButton(
      icon: const Icon(
        Icons.edit,
        color: Colors.blue,
      ),
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddTaskScreen(
              task: task,
            ),
          ),
        );
      },
    ),

    IconButton(
  icon: const Icon(
    Icons.delete,
    color: Colors.red,
  ),
  onPressed: () async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Task"),
          content: const Text(
            "Are you sure you want to delete this task?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await taskService.deleteTask(task.id);
    }
  },
),



  ],
),

      ],
    ),
  ),
);
    },
  );
}
),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddTaskScreen(),
          ),
          );
       },
        child: const Icon(Icons.add),
     ),
   );
  }
}
