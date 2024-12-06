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
                  icon:
                      const Icon(Icons.delete_sweep, color: Color(0xFFFF4552)),
                  label: const Text(
                    '전체 삭제',
                    style: TextStyle(color: Color(0xFFFF4552)),
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.separated(
            itemCount: todos.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final todo = todos[index];
              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Row(
                  children: [
                    if (todo.isPinned)
                      const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.push_pin,
                          size: 16,
                          color: Color(0xFFF87C4C),
                        ),
                      ),
                    Expanded(
                      child: Text(
                        todo.text,
                        style: TextStyle(
                          decoration: todo.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: todo.isCompleted ? Colors.grey : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                leading: Checkbox(
                  value: todo.isCompleted,
                  onChanged: (_) => onToggle(index),
                  activeColor: const Color(0xFF62BFAD),
                ),
                trailing: PopupMenuButton<String>(
                  color: const Color(0xFFF9F7E8),
                  icon: const Icon(Icons.more_vert, color: Color(0xFF62BFAD)),
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
                            color: const Color(0xFFF87C4C),
                          ),
                          const SizedBox(width: 8),
                          Text(todo.isPinned ? '고정 해제' : '고정'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Color(0xFF62BFAD)),
                          SizedBox(width: 8),
                          Text('수정'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Color(0xFFFF4552)),
                          SizedBox(width: 8),
                          Text('삭제'),
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
