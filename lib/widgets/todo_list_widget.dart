import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:will/controllers/todo_controller.dart';
import 'package:will/models/todo_item_model.dart';

class TodoList extends StatelessWidget {
  final List<TodoItem> todos;
  final Function(int) onToggle;
  final Function(int) onEdit;
  final Function(int) onDelete;
  final Function(int) onTogglePin;
  final VoidCallback onDeleteAll;
  final TodoController controller = Get.find<TodoController>();

  TodoList({
    super.key,
    required this.todos,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
    required this.onTogglePin,
    required this.onDeleteAll,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final filteredTodos = controller.filteredTodos;

      return Column(
        children: [
          if (todos.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //전체 삭제 버튼
                  TextButton.icon(
                    onPressed: onDeleteAll,
                    icon: Icon(Icons.delete_sweep,
                        color: Theme.of(context)
                            .colorScheme
                            .error
                            .withOpacity(0.8)),
                    label: Text(
                      '전체 삭제',
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .error
                              .withOpacity(0.8)),
                    ),
                  ),
                ],
              ),
            ),
          // 카테고리별 정렬
          Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.categories.length,
              itemBuilder: (context, index) {
                final category = controller.categories[index];
                final isSelected = category == controller.selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(category.isEmpty ? '전체' : category),
                    selected: isSelected,
                    onSelected: (_) => controller.setSelectedCategory(category),
                    selectedColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    checkmarkColor: Theme.of(context).colorScheme.primary,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filteredTodos.isEmpty
                //할 일이 없을 때
                ? const Center(
                    child: Text('할 일이 없습니다.'),
                  )
                //할 일이 있을 때
                : ListView.builder(
                    itemCount: filteredTodos.length,
                    itemBuilder: (context, index) {
                      final todo = filteredTodos[index];
                      return Card(
                        elevation: todo.isPinned ? 3 : 1,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: Checkbox(
                              value: todo.isCompleted,
                              onChanged: (_) => onToggle(index),
                              activeColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    if (todo.isPinned)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 4.0),
                                        child: Icon(
                                          Icons.push_pin,
                                          size: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    Expanded(
                                      child: Text(
                                        todo.text,
                                        style: TextStyle(
                                          decoration: todo.isCompleted
                                              ? TextDecoration.lineThrough
                                              : null,
                                          color: todo.isCompleted
                                              ? Theme.of(context).disabledColor
                                              : null,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (todo.description.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      todo.description,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: todo.isCompleted
                                            ? Theme.of(context).disabledColor
                                            : Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.color,
                                      ),
                                    ),
                                  ),
                                Row(
                                  children: [
                                    if (todo.category.isNotEmpty)
                                      Container(
                                        margin: const EdgeInsets.only(top: 4.0),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          todo.category,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                      ),
                                    if (todo.dueDateTime != null)
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 4.0, left: 8.0),
                                          child: Text(
                                            DateFormat('yyyy/MM/dd HH:mm')
                                                .format(todo.dueDateTime!),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: todo.dueDateTime!
                                                      .isBefore(DateTime.now())
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .error
                                                  : Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.color,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.flag,
                                    color: todo.priority == 3
                                        ? Colors.red
                                        : todo.priority == 2
                                            ? Colors.orange
                                            : Colors.grey,
                                  ),
                                  onPressed: () {
                                    final newPriority = (todo.priority % 3) + 1;
                                    controller.setPriority(index, newPriority);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    todo.isPinned
                                        ? Icons.push_pin
                                        : Icons.push_pin_outlined,
                                    color: todo.isPinned
                                        ? Theme.of(context).colorScheme.primary
                                        : null,
                                  ),
                                  onPressed: () => onTogglePin(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.more_vert),
                                  onPressed: () =>
                                      _showMoreOptions(context, index),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      );
    });
  }

  void _showMoreOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('수정'),
            onTap: () {
              Navigator.pop(context);
              onEdit(index);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('삭제'),
            onTap: () {
              Navigator.pop(context);
              onDelete(index);
            },
          ),
        ],
      ),
    );
  }
}
