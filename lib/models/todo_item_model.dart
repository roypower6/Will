class TodoItem {
  String text;
  bool isCompleted;
  bool isPinned;
  int originalIndex;
  String category;
  String description;

  TodoItem({
    required this.text,
    this.isCompleted = false,
    this.isPinned = false,
    required this.originalIndex,
    this.category = '',
    this.description = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isCompleted': isCompleted,
      'isPinned': isPinned,
      'originalIndex': originalIndex,
      'category': category,
      'description': description,
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
    );
  }
}
