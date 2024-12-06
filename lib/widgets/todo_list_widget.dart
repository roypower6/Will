import 'package:flutter/material.dart';
import 'package:will/models/todo_item_model.dart';

class TodoList extends StatelessWidget {
  final List<TodoItem> todos;
  final Function(int) onToggle;
  final Function(int) onEdit;
  final Function(int) onDelete;
  final Function(int) onTogglePin;
  final VoidCallback onDeleteAll;

  const TodoList({
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
    return Column(
      children: [
        if (todos.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onDeleteAll,
                  icon: Icon(Icons.delete_sweep,
                      color:
                          Theme.of(context).colorScheme.error.withOpacity(0.8)),
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
        Expanded(
          child: ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Row(
                  children: [
                    if (todo.isPinned)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.push_pin,
                          size: 16,
                          color: Theme.of(context).colorScheme.secondary,
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
                              ? Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.color
                                  ?.withOpacity(0.5)
                              : Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                  ],
                ),
                leading: Checkbox(
                  value: todo.isCompleted,
                  onChanged: (_) => onToggle(index),
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
                trailing: PopupMenuButton<String>(
                  color: Theme.of(context).colorScheme.surface,
                  icon: Icon(Icons.more_vert,
                      color: Theme.of(context).colorScheme.primary),
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        onEdit(index);
                        break;
                      case 'delete':
                        onDelete(index);
                        break;
                      case 'pin':
                        onTogglePin(index);
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
                            color: Theme.of(context).colorScheme.secondary,
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
                              color: Theme.of(context).colorScheme.primary),
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
                              color: Theme.of(context).colorScheme.error),
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
  }
}
