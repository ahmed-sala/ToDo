import 'package:flutter/material.dart';

import '../database/my_database.dart';
import '../database/task.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> tasks = [];

  void refreshTasks(DateTime selectedDate) async {
    tasks = [];
    var snapshot = await MyDatabase.getAllTasks(selectedDate);
    snapshot.docs.map((e) {
      tasks.add(e.data());
    }).toList();
    notifyListeners();
  }
}
