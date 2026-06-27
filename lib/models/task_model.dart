import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final DateTime taskDate;
  final DateTime dueDate;
  final String startTime;
  final String dueTime;
  final String priority;
  final String status;
  final String userId;
  final Timestamp createdAt;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.taskDate,
    required this.dueDate,
    required this.startTime,
    required this.dueTime,
    required this.priority,
    required this.status,
    required this.userId,
    required this.createdAt,
  });

  factory TaskModel.fromMap(
    Map<String, dynamic> data,
    String documentId,
  ) {
    return TaskModel(
      id: documentId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      taskDate: (data['taskDate'] as Timestamp).toDate(),
      dueDate: (data['dueDate'] as Timestamp).toDate(),
      startTime: data['startTime'] ?? '',
      dueTime: data['dueTime'] ?? '',
      priority: data['priority'] ?? 'Medium',
      status: data['status'] ?? 'Pending',
      userId: data['userId'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'taskDate': Timestamp.fromDate(taskDate),
      'dueDate': Timestamp.fromDate(dueDate),
      'startTime': startTime,
      'dueTime': dueTime,
      'priority': priority,
      'status': status,
      'userId': userId,
      'createdAt': createdAt,
    };
  }

  TaskModel copyWith({
  String? id,
  String? title,
  String? description,
  DateTime? taskDate,
  DateTime? dueDate,
  String? startTime,
  String? dueTime,
  String? priority,
  String? status,
  String? userId,
  Timestamp? createdAt,
}) {
  return TaskModel(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    taskDate: taskDate ?? this.taskDate,
    dueDate: dueDate ?? this.dueDate,
    startTime: startTime ?? this.startTime,
    dueTime: dueTime ?? this.dueTime,
    priority: priority ?? this.priority,
    status: status ?? this.status,
    userId: userId ?? this.userId,
    createdAt: createdAt ?? this.createdAt,
  );
}
}