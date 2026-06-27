import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/task_model.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _taskCollection =>
      _firestore.collection('tasks');

  String get currentUserId => _auth.currentUser!.uid;


  Future<void> addTask(TaskModel task) async {

  final newTask = task.copyWith();

  final data = {
    ...newTask.toMap(),
    'userId': currentUserId,
  };

  await _taskCollection.add(data);
}

  Stream<List<TaskModel>> getTasks() {
    return _taskCollection
        .where('userId', isEqualTo: currentUserId)
        .where('status', isEqualTo: 'Pending')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return TaskModel.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }

Stream<List<TaskModel>> getCompletedTasks() {
  return _taskCollection
      .where('userId', isEqualTo: currentUserId)
      .where('status', isEqualTo: 'Completed')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      return TaskModel.fromMap(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    }).toList();
  });
}

  Future<void> updateTask(TaskModel task) async {
    await _taskCollection
        .doc(task.id)
        .update(task.toMap());
  }

Future<void> markTaskCompleted(TaskModel task) async {
  await _taskCollection.doc(task.id).update({
    'status': 'Completed',
  });
}

  Future<void> deleteTask(String id) async {
    await _taskCollection.doc(id).delete();
  }
}