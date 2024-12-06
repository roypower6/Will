class TodoItem {
  String text;
  bool isCompleted;
  bool isPinned;
  int originalIndex;

  TodoItem({
    required this.text,
    this.isCompleted = false,
    this.isPinned = false,
    required this.originalIndex,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isCompleted': isCompleted,
      'isPinned': isPinned,
      'originalIndex': originalIndex,
    };
  }

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      text: json['text'],
      isCompleted: json['isCompleted'] ?? false,
      isPinned: json['isPinned'] ?? false,
      originalIndex: json['originalIndex'],
    );
  }
}
