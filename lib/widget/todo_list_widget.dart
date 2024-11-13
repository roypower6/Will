import 'package:flutter/material.dart';
import 'package:will/model/todo_item_model.dart';

class TodoList extends StatelessWidget {
  final List<TodoItem> todos;
  final Function(int) onToggle;
  final Function(int) onEdit;
  final Function(int) onDelete;
  final VoidCallback onDeleteAll;

  const TodoList({
    super.key,
    required this.todos,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
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
                  onPressed: onDeleteAll, // 직접 콜백 호출
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
              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(
                  todos[index].text,
                  style: TextStyle(
                    decoration: todos[index].isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    color:
                        todos[index].isCompleted ? Colors.grey : Colors.black,
                  ),
                ),
                leading: Checkbox(
                  value: todos[index].isCompleted,
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
                        onDelete(index); // 직접 콜백 호출
                        break;
                    }
                  },
                  itemBuilder: (context) => [
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
