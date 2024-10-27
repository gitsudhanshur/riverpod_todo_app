import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/category_provider.dart';

class TodoScreen extends ConsumerWidget {
  final _taskController = TextEditingController();
  final _categoryController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);
    final categories = ref.watch(categoryProvider);
    final themeMode = ref.watch(themeProvider);

    String? selectedCategory;

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              ref.read(themeProvider.notifier).toggleTheme();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(
                      hintText: 'Enter task title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                DropdownButton<String>(
                  hint: Text('Select category'),
                  value: selectedCategory,
                  onChanged: (value) {
                    selectedCategory = value;
                    (context as Element).markNeedsBuild();
                  },
                  items: categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category.name,
                      child: Text(category.name),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: tasks.isEmpty
                  ? Center(child: Text('No tasks yet!'))
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return Dismissible(
                          key: UniqueKey(),
                          onDismissed: (_) {
                            ref.read(taskProvider.notifier).removeTask(index);
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          child: Card(
                            elevation: 2,
                            child: ListTile(
                              title: Text(
                                task.title,
                                style: TextStyle(
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              subtitle: task.category != null ? Text('Category: ${task.category}') : null,
                              leading: Checkbox(
                                value: task.isCompleted,
                                onChanged: (_) {
                                  ref.read(taskProvider.notifier).toggleTask(index);
                                },
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Add Task'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _taskController,
                        decoration: InputDecoration(hintText: 'Enter task title'),
                      ),
                      DropdownButton<String>(
                        hint: Text('Select category'),
                        value: selectedCategory,
                        onChanged: (value) {
                          selectedCategory = value;
                          (context as Element).markNeedsBuild();
                        },
                        items: categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category.name,
                            child: Text(category.name),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_taskController.text.isNotEmpty) {
                          ref.read(taskProvider.notifier).addTask(_taskController.text, selectedCategory);
                          _taskController.clear();
                          selectedCategory = null;
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text('Add'),
                    ),
                  ],
                ),
              );
            },
            child: Icon(Icons.add),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Add Category'),
                  content: TextField(
                    controller: _categoryController,
                    decoration: InputDecoration(hintText: 'Enter category name'),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_categoryController.text.isNotEmpty) {
                          ref.read(categoryProvider.notifier).addCategory(_categoryController.text);
                          _categoryController.clear();
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text('Add'),
                    ),
                  ],
                ),
              );
            },
            child: Icon(Icons.category),
          ),
        ],
      ),
    );
  }
}
