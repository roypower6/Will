import 'package:flutter/material.dart';
import 'package:will/model/todo_item_model.dart';

class TodoList extends StatelessWidget {
  final List<TodoItem> todos;
  final Function(int) onToggle;
  final Function(int) onEdit;
  final Function(int) onDelete;

  const TodoList({
    super.key,
    required this.todos,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: todos.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(
            todos[index].text,
            style: TextStyle(
              decoration:
                  todos[index].isCompleted ? TextDecoration.lineThrough : null,
              color: todos[index].isCompleted ? Colors.grey : Colors.black,
            ),
          ),
          leading: Checkbox(
            value: todos[index].isCompleted,
            onChanged: (_) => onToggle(index),
            activeColor: const Color(0xFF62BFAD),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Color(0xFF62BFAD)),
                onPressed: () => onEdit(index),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Color(0xFFFF4552)),
                onPressed: () => onDelete(index),
              ),
            ],
          ),
        );
      },
    );
  }
}
