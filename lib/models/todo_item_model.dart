class TodoItem {
  String text;
  bool isCompleted;
  bool isPinned;
  int originalIndex;
  String category;
  String description;
  DateTime? dueDateTime; // 날짜와 시간을 함께 저장

  TodoItem({
    required this.text,
    this.isCompleted = false,
    this.isPinned = false,
    required this.originalIndex,
    this.category = '',
    this.description = '',
    this.dueDateTime, // 날짜와 시간을 함께 저장
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isCompleted': isCompleted,
      'isPinned': isPinned,
      'originalIndex': originalIndex,
      'category': category,
      'description': description,
      'dueDateTime': dueDateTime?.toIso8601String(), // ISO 8601 문자열로 변환
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
          : null, // ISO 8601 문자열에서 DateTime으로 변환
    );
  }
}
