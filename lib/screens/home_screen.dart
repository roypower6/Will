import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:will/controllers/todo_controller.dart'; // 경로 변경됨
import 'package:will/widgets/create_dialog.dart';
import 'package:will/widgets/delete_dialog_widget.dart';
import 'package:will/widgets/empty_state_widget.dart';
import 'package:will/widgets/left_drawer_widget.dart';
import 'package:will/widgets/todo_list_widget.dart';

class HomeScreen extends StatelessWidget {
  // StatefulWidget에서 StatelessWidget으로 변경
  HomeScreen({super.key}) {
    Get.put(TodoController()); // TodoController 초기화
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _showAddTodoDialog() async {
    final result = await showDialog<String>(
      context: Get.context!,
      builder: (context) => const CustomDialog(
        title: '새로 할 일',
        submitText: '추가',
        hintText: '할 일을 입력해주세요.',
        initialValue: '',
      ),
    );

    if (result != null && result.isNotEmpty) {
      await Get.find<TodoController>().addTodo(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TodoController>();

    return Scaffold(
      key: _scaffoldKey,
      drawer: BuildDrawer(todos: controller.todos, context: context),
      backgroundColor: const Color(0xFFF9F7E8),
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                  const Expanded(
                    child: Text(
                      'Todo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
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
                    final result = await showDialog<String>(
                      context: context,
                      builder: (context) => CustomDialog(
                        title: '할 일 수정',
                        submitText: '수정',
                        hintText: '할 일을 입력하세요.',
                        initialValue: todos[index].text,
                      ),
                    );
                    if (result != null && result.isNotEmpty) {
                      await controller.editTodo(index, result);
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
        backgroundColor: const Color(0xFF87C4A3),
        child: const Icon(Icons.add),
      ),
    );
  }
}
