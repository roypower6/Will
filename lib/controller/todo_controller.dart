import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:will/model/todo_item_model.dart';

class TodoController {
  List<TodoItem> todos = [];
  final String _storageKey = 'todos';

  Future<void> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todosString = prefs.getString(_storageKey);
    if (todosString != null) {
      final List<dynamic> todosJson = jsonDecode(todosString);
      todos = todosJson.map((json) => TodoItem.fromJson(json)).toList();
      _sortTodos();
    }
  }

  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String todosString =
        jsonEncode(todos.map((todo) => todo.toJson()).toList());
    await prefs.setString(_storageKey, todosString);
  }

  Future<void> addTodo(String text) async {
    todos.add(TodoItem(
      text: text,
      originalIndex: todos.length,
    ));
    _sortTodos();
    await _saveTodos();
  }

  Future<void> toggleTodo(int index) async {
    if (index >= 0 && index < todos.length) {
      todos[index].isCompleted = !todos[index].isCompleted;
      _sortTodos();
      await _saveTodos();
    }
  }

  Future<void> editTodo(int index, String newText) async {
    if (index >= 0 && index < todos.length) {
      todos[index].text = newText;
      await _saveTodos();
    }
  }

  Future<void> deleteTodo(int index) async {
    if (index >= 0 && index < todos.length) {
      todos.removeAt(index);
      _sortTodos();
      await _saveTodos();
    }
  }

  Future<void> deleteAllTodos() async {
    todos.clear();
    await _saveTodos();
  }

  Future<void> togglePin(int index) async {
    if (index >= 0 && index < todos.length) {
      todos[index].isPinned = !todos[index].isPinned;
      _sortTodos();
      await _saveTodos();
    }
  }

  void _sortTodos() {
    todos.sort((a, b) {
      // 1. 먼저 고정 여부로 정렬
      if (a.isPinned != b.isPinned) {
        return a.isPinned ? -1 : 1;
      }
      // 2. 그 다음 완료 여부로 정렬
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      // 3. 마지막으로 원래 순서로 정렬
      return a.originalIndex.compareTo(b.originalIndex);
    });
  }
}
