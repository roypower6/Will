import 'package:flutter/material.dart';
import 'package:will/models/todo_item_model.dart';
import 'package:will/screens/app_info_screen.dart';
import 'package:get/get.dart';
import 'package:will/controllers/theme_controller.dart';

class BuildDrawer extends StatelessWidget {
  final List<TodoItem> _todos;
  final BuildContext context;

  const BuildDrawer({
    super.key,
    required List<TodoItem> todos,
    required this.context,
  }) : _todos = todos;

  @override
  Widget build(BuildContext context) {
    final incompleteTasks = _todos.where((todo) => !todo.isCompleted).length;
    final completedTasks = _todos.where((todo) => todo.isCompleted).length;
    final themeController = Get.find<ThemeController>();

    void navigateTo(BuildContext context, Widget screen) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    }

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
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
                      'version 1.0.7',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(
              'Home',
              style: TextStyle(
                color:
                    themeController.isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(
              "앱 정보",
              style: TextStyle(
                color:
                    themeController.isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            onTap: () => navigateTo(context, const AppInfoScreen()),
          ),
          Obx(() => GestureDetector(
                onTap: () {
                  themeController.toggleTheme();
                },
                child: SwitchListTile(
                  title: Text(themeController.isDarkMode ? '다크 모드' : '라이트 모드',
                      style: TextStyle(
                        color: themeController.isDarkMode
                            ? Colors.white
                            : Colors.black87,
                      )),
                  secondary: Icon(
                    themeController.isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                  ),
                  value: themeController.isDarkMode,
                  onChanged: (bool value) {
                    themeController.toggleTheme();
                  },
                ),
              )),
        ],
      ),
    );
  }
}
