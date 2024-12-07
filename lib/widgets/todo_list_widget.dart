import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                // 할 일이 없을 때
                ? const Center(
                    child: Text('할 일이 없습니다.'),
                  )
                // 할 일이 있을 때
                : ListView.builder(
                    itemCount: filteredTodos.length,
                    itemBuilder: (context, index) {
                      final todo = filteredTodos[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        title: Row(
                          children: [
                            if (todo.isPinned)
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.push_pin,
                                  size: 16,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      // 할 일
                                      Expanded(
                                        child: Text(
                                          todo.text,
                                          style: TextStyle(
                                            decoration: todo.isCompleted
                                                ? TextDecoration.lineThrough
                                                : null,
                                            color: todo.isCompleted
                                                ? Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.color
                                                    ?.withOpacity(0.5)
                                                : Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.color,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (todo.category.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Container(
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
                                        // 할일 카테고리
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
                                    ),
                                  if (todo.description.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      // 할일 설명
                                      child: Text(
                                        todo.description,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.color
                                              ?.withOpacity(0.8),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        //할 일 완료 체크박스
                        leading: Checkbox(
                          value: todo.isCompleted,
                          onChanged: (_) =>
                              onToggle(filteredTodos.indexOf(todo)),
                          activeColor: Theme.of(context).colorScheme.primary,
                        ),
                        //할 일 수정, 삭제, 고정 설정 버튼
                        trailing: PopupMenuButton<String>(
                          color: Theme.of(context).colorScheme.surface,
                          icon: Icon(Icons.more_vert,
                              color: Theme.of(context).colorScheme.primary),
                          onSelected: (value) {
                            switch (value) {
                              case 'edit':
                                onEdit(filteredTodos.indexOf(todo));
                                break;
                              case 'delete':
                                onDelete(filteredTodos.indexOf(todo));
                                break;
                              case 'pin':
                                onTogglePin(filteredTodos.indexOf(todo));
                                break;
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem<String>(
                              value: 'pin',
                              child: Row(
                                children: [
                                  Icon(
                                    todo.isPinned
                                        ? Icons.push_pin_outlined
                                        : Icons.push_pin,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(todo.isPinned ? '고정 해제' : '고정'),
                                ],
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  const SizedBox(width: 8),
                                  const Text('수정'),
                                ],
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete,
                                      color:
                                          Theme.of(context).colorScheme.error),
                                  const SizedBox(width: 8),
                                  const Text('삭제'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      );
    });
  }
}
