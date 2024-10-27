import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/task.dart';

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super([]) {
    _loadTasks();
  }

  void _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final taskList = prefs.getString('tasks');
    if (taskList != null) {
      state = List<Task>.from(json.decode(taskList).map((task) => Task.fromJson(task)));
    }
  }

  void _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('tasks', json.encode(state.map((task) => task.toJson()).toList()));
  }

  void addTask(String title, String? category) {
    state = [...state, Task(title: title, category: category)];
    _saveTasks();
  }

  void toggleTask(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          Task(title: state[i].title, isCompleted: !state[i].isCompleted)
        else
          state[i],
    ];
    _saveTasks();
  }

  void removeTask(int index) {
    state = state.where((task) => task != state[index]).toList();
    _saveTasks();
  }
}

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier();
});
