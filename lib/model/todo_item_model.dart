class TodoItem {
  String text;
  bool isCompleted;
  int originalIndex;

  TodoItem({
    required this.text,
    this.isCompleted = false,
    required this.originalIndex,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isCompleted': isCompleted,
      'originalIndex': originalIndex,
    };
  }

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      text: json['text'],
      isCompleted: json['isCompleted'],
      originalIndex: json['originalIndex'],
    );
  }
}
