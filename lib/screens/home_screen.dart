import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:will/controllers/todo_controller.dart';
import 'package:will/widgets/dialogs/create_dialog.dart';
import 'package:will/widgets/dialogs/delete_dialog.dart';
import 'package:will/widgets/empty_state_widget.dart';
import 'package:will/widgets/left_drawer_widget.dart';
import 'package:will/widgets/todo_list_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key}) {
    Get.put(TodoController()); // TodoController 초기화
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _showAddTodoDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: Get.context!,
      builder: (context) => const CustomDialog(
        title: '새로 할 일',
        submitText: '추가',
        hintText: '할 일을 입력해주세요.',
      ),
    );

    if (result != null && result['text']!.isNotEmpty) {
      await Get.find<TodoController>().addTodo(
        result['text']!,
        category: result['category'] ?? '',
        description: result['description'] ?? '',
        dueDateTime: result['dueDateTime'], // 날짜와 시간을 함께 저장
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TodoController>();

    return Scaffold(
      key: _scaffoldKey,
      drawer: BuildDrawer(todos: controller.todos, context: context),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Theme.of(context).colorScheme.primary,
                      size: 30,
                    ),
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      'Will',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Todo List
            Expanded(
              child: Obx(() {
                final todos = controller.todos;
                if (todos.isEmpty) {
                  return const EmptyState();
                }
                return TodoList(
                  todos: todos,
                  onToggle: controller.toggleTodo,
                  onEdit: (index) async {
                    final result = await showDialog<Map<String, dynamic>>(
                      context: context,
                      builder: (context) => CustomDialog(
                        title: '할 일 수정',
                        submitText: '수정',
                        hintText: '할 일을 입력해주세요.',
                        initialText: todos[index].text,
                        initialCategory: todos[index].category,
                        initialDescription: todos[index].description,
                        initialDueDateTime:
                            todos[index].dueDateTime, // 날짜와 시간을 함께 저장
                      ),
                    );
                    if (result != null && result['text']!.isNotEmpty) {
                      await controller.editTodo(
                        index,
                        result['text']!,
                        category: result['category'] ?? '',
                        description: result['description'] ?? '',
                        dueDateTime: result['dueDateTime'], // 날짜와 시간을 함께 저장
                      );
                    }
                  },
                  onDelete: (index) async {
                    final result = await showDialog<bool>(
                      context: context,
                      builder: (context) => const DeleteDialog(
                        title: '정말 모든 할 일을 삭제하시겠습니까?',
                      ),
                    );
                    if (result == true) {
                      await controller.deleteTodo(index);
                    }
                  },
                  onTogglePin: controller.togglePin,
                  onDeleteAll: () async {
                    final result = await showDialog<bool>(
                      context: context,
                      builder: (context) => const DeleteDialog(
                        title: '정말 모든 할 일을 삭제하시겠습니까?',
                      ),
                    );
                    if (result == true) {
                      await controller.deleteAllTodos();
                    }
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
