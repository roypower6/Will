class TodoItem {
  String text;
  bool isCompleted;
  bool isPinned;
  int originalIndex;
  String category;
  String description;
  DateTime? dueDateTime;
  int priority; // 우선순위 (1: 낮음, 2: 보통, 3: 높음)
  DateTime createdAt; // 생성일

  TodoItem({
    required this.text,
    this.isCompleted = false,
    this.isPinned = false,
    required this.originalIndex,
    this.category = '',
    this.description = '',
    this.dueDateTime,
    this.priority = 2, // 기본값은 보통(2)
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isCompleted': isCompleted,
      'isPinned': isPinned,
      'originalIndex': originalIndex,
      'category': category,
      'description': description,
      'dueDateTime': dueDateTime?.toIso8601String(),
      'priority': priority,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      text: json['text'],
      isCompleted: json['isCompleted'] ?? false,
      isPinned: json['isPinned'] ?? false,
      originalIndex: json['originalIndex'],
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      dueDateTime: json['dueDateTime'] != null
          ? DateTime.parse(json['dueDateTime'])
          : null,
      priority: json['priority'] ?? 2,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}
