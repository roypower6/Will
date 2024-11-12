import 'package:flutter/material.dart';
import 'package:will/controller/todo_controller.dart';
import 'package:will/widget/custom_dialog_widget.dart';
import 'package:will/widget/delete_dialog_widget.dart';
import 'package:will/widget/empty_state_widget.dart';
import 'package:will/widget/left_drawer_widget.dart';
import 'package:will/widget/todo_list_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final TodoController _todoController = TodoController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    await _todoController.loadTodos();
    setState(() {}); // UI 업데이트
  }

  Future<void> _showAddTodoDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => const CustomDialog(
        title: '새로운 할 일',
        submitText: '추가',
        hintText: '할 일을 입력하세요.',
      ),
    );

    if (result != null && result.isNotEmpty) {
      await _todoController.addTodo(result);
      setState(() {}); // UI 업데이트
    }
  }

  Future<void> _handleEdit(int index) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => CustomDialog(
        title: '할 일 수정',
        initialText: _todoController.todos[index].text,
        submitText: '저장',
        hintText: '수정할 내용을 입력하세요.',
      ),
    );

    if (result != null && result.isNotEmpty) {
      await _todoController.editTodo(index, result);
      setState(() {}); // UI 업데이트
    }
  }

  Future<void> _handleDelete(int index) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => const DeleteDialog(),
    );

    if (shouldDelete == true) {
      await _todoController.deleteTodo(index);
      setState(() {}); // UI 업데이트
    }
  }

  Future<void> _handleToggle(int index) async {
    await _todoController.toggleTodo(index);
    setState(() {}); // UI 업데이트
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text(
          'Will',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF62BFAD),
            fontSize: 32,
          ),
        ),
      ),
      drawer: BuildDrawer(todos: _todoController.todos, context: context),
      body: _todoController.todos.isEmpty
          ? const EmptyState()
          : TodoList(
              todos: _todoController.todos,
              onToggle: _handleToggle,
              onEdit: _handleEdit,
              onDelete: _handleDelete,
            ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        onPressed: _showAddTodoDialog,
        backgroundColor: const Color(0xFF62BFAD),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
