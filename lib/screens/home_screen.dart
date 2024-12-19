import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:will/controllers/todo_controller.dart';
import 'package:will/widgets/dialogs/create_dialog.dart';
import 'package:will/widgets/empty_state_widget.dart';
import 'package:will/widgets/left_drawer_widget.dart';
import 'package:will/widgets/todo_list_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key}) {
    Get.put(TodoController()); // TodoController 초기화
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final RxBool _isSearching = false.obs;

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
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                  Expanded(
                    child: Obx(
                      () => _isSearching.value
                          ? TextField(
                              decoration: InputDecoration(
                                hintText: '할 일 검색...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    _isSearching.value = false;
                                    controller.setSearchQuery('');
                                  },
                                ),
                              ),
                              onChanged: controller.setSearchQuery,
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Will',
                                    style: TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.search),
                                  onPressed: () => _isSearching.value = true,
                                ),
                              ],
                            ),
                    ),
                  ),
                  PopupMenuButton<SortType>(
                    onSelected: controller.setSortType,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: SortType.dueDate,
                        child: Row(
                          children: [
                            Icon(
                              controller.sortType == SortType.dueDate
                                  ? Icons.check
                                  : Icons.check_box_outline_blank,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            const Text('마감일순'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: SortType.createdAt,
                        child: Row(
                          children: [
                            Icon(
                              controller.sortType == SortType.createdAt
                                  ? Icons.check
                                  : Icons.check_box_outline_blank,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            const Text('생성일순'),
                          ],
                        ),
                      ),
                    ],
                    child: Row(
                      children: [
                        Text(
                          controller.sortType == SortType.dueDate
                              ? '마감일순'
                              : '생성일순',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Obx(() => Icon(
                          controller.showCompleted
                              ? Icons.check_circle
                              : Icons.check_circle_outline,
                        )),
                    onPressed: controller.toggleShowCompleted,
                    tooltip: '완료된 항목 표시',
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
                  onTogglePin: controller.togglePin,
                  onEdit: (todo) async {
                    final result = await showDialog<Map<String, dynamic>>(
                      context: context,
                      builder: (context) => CustomDialog(
                        title: '할 일 수정',
                        submitText: '수정',
                        hintText: '할 일을 입력해주세요.',
                        initialText: todo.text,
                        initialCategory: todo.category,
                        initialDescription: todo.description,
                        initialDueDateTime: todo.dueDateTime,
                      ),
                    );
                    if (result != null && result['text']!.isNotEmpty) {
                      await controller.editTodo(
                        todo,
                        result['text']!,
                        category: result['category'] ?? '',
                        description: result['description'] ?? '',
                        dueDateTime: result['dueDateTime'],
                      );
                    }
                  },
                  onDelete: controller.deleteTodo,
                  onDeleteAll: controller.deleteAllTodos,
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
