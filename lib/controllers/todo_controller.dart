import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:will/models/todo_item_model.dart';

class TodoController extends GetxController {
  final RxList<TodoItem> _todos = <TodoItem>[].obs;
  final RxString _selectedCategory = ''.obs;
  final RxString _searchQuery = ''.obs;
  final Rx<SortType> _sortType = SortType.dueDate.obs;
  final RxBool _showCompleted = true.obs;
  final String _storageKey = 'todos';

  List<TodoItem> get todos => _todos;
  String get selectedCategory => _selectedCategory.value;
  String get searchQuery => _searchQuery.value;
  SortType get sortType => _sortType.value;
  bool get showCompleted => _showCompleted.value;

  List<String> get categories {
    final Set<String> categorySet = _todos
        .where((todo) => todo.category.isNotEmpty)
        .map((todo) => todo.category)
        .toSet();
    return ['', ...categorySet.toList()..sort()];
  }

  List<TodoItem> get filteredTodos {
    return _todos.where((todo) {
      // 카테고리 필터
      if (_selectedCategory.value.isNotEmpty &&
          todo.category != _selectedCategory.value) {
        return false;
      }

      // 완료 상태 필터
      if (!_showCompleted.value && todo.isCompleted) {
        return false;
      }

      // 검색 필터
      if (_searchQuery.value.isNotEmpty) {
        final query = _searchQuery.value.toLowerCase();
        return todo.text.toLowerCase().contains(query) ||
            todo.description.toLowerCase().contains(query) ||
            todo.category.toLowerCase().contains(query);
      }

      return true;
    }).toList()
      ..sort((a, b) {
        // 핀 고정된 항목 우선
        if (a.isPinned != b.isPinned) {
          return a.isPinned ? -1 : 1;
        }

        // 완료 상태에 따라 정렬: 미완료된 할 일이 먼저 오도록
        if (a.isCompleted != b.isCompleted) {
          return a.isCompleted ? 1 : -1;
        }

        // 정렬 기준에 따라 정렬
        switch (_sortType.value) {
          case SortType.dueDate:
            if (a.dueDateTime == null && b.dueDateTime == null) return 0;
            if (a.dueDateTime == null) return 1;
            if (b.dueDateTime == null) return -1;
            return a.dueDateTime!.compareTo(b.dueDateTime!);
          case SortType.createdAt:
            return b.createdAt.compareTo(a.createdAt);
        }
      });
  }

  void setSelectedCategory(String category) {
    _selectedCategory.value = category;
  }

  void setSearchQuery(String query) {
    _searchQuery.value = query;
  }

  void setSortType(SortType type) {
    _sortType.value = type;
  }

  void toggleShowCompleted() {
    _showCompleted.value = !_showCompleted.value;
  }

  void toggleTodo(int index) async {
    if (index >= 0 && index < _todos.length) {
      _todos[index].isCompleted = !_todos[index].isCompleted;
      _todos.refresh(); // UI 업데이트
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
      await _saveTodos();
    }
  }

  Future<void> deleteAllTodos() async {
    _todos.clear();
    await _saveTodos();
  }

  void togglePin(TodoItem todo) async {
    todo.isPinned = !todo.isPinned;
    _todos.refresh(); // UI 업데이트
    await _saveTodos();
  }

  List<TodoItem> getDueSoonTodos() {
    final now = DateTime.now();
    return _todos.where((todo) {
      if (todo.dueDateTime == null || todo.isCompleted) return false;
      final difference = todo.dueDateTime!.difference(now);
      return difference.inDays <= 3 && difference.inMilliseconds > 0;
    }).toList();
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
    await _saveTodos();
  }
}

enum SortType {
  dueDate,
  createdAt,
}
