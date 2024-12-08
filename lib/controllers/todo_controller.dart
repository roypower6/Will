import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:will/models/todo_item_model.dart';

class TodoController extends GetxController {
  final RxList<TodoItem> _todos = <TodoItem>[].obs;
  final RxString _selectedCategory = ''.obs;
  final String _storageKey = 'todos';

  List<TodoItem> get todos => _todos;
  String get selectedCategory => _selectedCategory.value;

  List<String> get categories {
    final Set<String> categorySet = _todos
        .where((todo) => todo.category.isNotEmpty)
        .map((todo) => todo.category)
        .toSet();
    return ['', ...categorySet.toList()..sort()];
  }

  List<TodoItem> get filteredTodos {
    if (_selectedCategory.value.isEmpty) {
      return _todos;
    }
    return _todos
        .where((todo) => todo.category == _selectedCategory.value)
        .toList();
  }

  void setSelectedCategory(String category) {
    _selectedCategory.value = category;
  }

  @override
  void onInit() {
    super.onInit();
    loadTodos();
  }

  Future<void> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todosString = prefs.getString(_storageKey);
    if (todosString != null) {
      final List<dynamic> todosJson = jsonDecode(todosString);
      _todos.value = todosJson.map((json) => TodoItem.fromJson(json)).toList();
      _sortTodos();
    }
  }

  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String todosString =
        jsonEncode(_todos.map((todo) => todo.toJson()).toList());
    await prefs.setString(_storageKey, todosString);
  }

  Future<void> addTodo(String text,
      {String category = '',
      String description = '',
      DateTime? dueDateTime}) async {
    _todos.add(TodoItem(
      text: text,
      originalIndex: _todos.length,
      category: category,
      description: description,
      dueDateTime: dueDateTime,
    ));
    _sortTodos();
    await _saveTodos();
  }

  Future<void> toggleTodo(int index) async {
    if (index >= 0 && index < _todos.length) {
      _todos[index].isCompleted = !_todos[index].isCompleted;
      _todos.refresh(); // GetX에게 상태 변경을 알림
      _sortTodos();
      await _saveTodos();
    }
  }

  Future<void> editTodo(int index, String newText,
      {String category = '',
      String description = '',
      DateTime? dueDateTime}) async {
    if (index >= 0 && index < _todos.length) {
      _todos[index].text = newText;
      _todos[index].category = category;
      _todos[index].description = description;
      _todos[index].dueDateTime = dueDateTime;
      _todos.refresh();
      await _saveTodos();
    }
  }

  Future<void> deleteTodo(int index) async {
    if (index >= 0 && index < _todos.length) {
      _todos.removeAt(index);
      _sortTodos();
      await _saveTodos();
    }
  }

  Future<void> deleteAllTodos() async {
    _todos.clear();
    await _saveTodos();
  }

  Future<void> togglePin(int index) async {
    if (index >= 0 && index < _todos.length) {
      _todos[index].isPinned = !_todos[index].isPinned;
      _todos.refresh();
      _sortTodos();
      await _saveTodos();
    }
  }

  void _sortTodos() {
    _todos.sort((a, b) {
      // 1. 먼저 고정 여부로 정렬
      if (a.isPinned != b.isPinned) {
        return a.isPinned ? -1 : 1;
      }
      // 2. 그 다음 완료 여부로 정렬
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      // 3. 시간 순서로 정렬 (시간이 없는 항목은 마지막에)
      if (a.dueDateTime != null && b.dueDateTime != null) {
        return a.dueDateTime!.compareTo(b.dueDateTime!);
      }
      if (a.dueDateTime != null) return -1;
      if (b.dueDateTime != null) return 1;
      // 4. 마지막으로 원래 순서로 정렬
      return a.originalIndex.compareTo(b.originalIndex);
    });
    _todos.refresh(); // 정렬 후 UI 업데이트
  }
}
