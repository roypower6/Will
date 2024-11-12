import 'package:flutter/material.dart';
import 'package:will/model/todo_item_model.dart';
import 'package:will/screen/app_info_screen.dart';

class BuildDrawer extends StatelessWidget {
  const BuildDrawer({
    super.key,
    required List<TodoItem> todos,
    required this.context,
  }) : _todos = todos;

  final List<TodoItem> _todos;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final incompleteTasks = _todos.where((todo) => !todo.isCompleted).length;
    final completedTasks = _todos.where((todo) => todo.isCompleted).length;

    void navigateTo(BuildContext context, Widget screen) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    }

    return Drawer(
      backgroundColor: const Color(0xFFF9F7E8),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF62BFAD),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Will',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '할 일: $incompleteTasks개',
                  style: const TextStyle(color: Colors.white),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '완료: $completedTasks개',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Text(
                      'version 1.0.0',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("앱 정보"),
            onTap: () => navigateTo(context, const AppInfoScreen()),
          ),
        ],
      ),
    );
  }
}
