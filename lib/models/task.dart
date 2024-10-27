class Task {
  String title;
  bool isCompleted;
  String? category;

  Task({required this.title, this.isCompleted = false, this.category});

  Map<String, dynamic> toJson() => {
        'title': title,
        'isCompleted': isCompleted,
        'category': category,
      };

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      isCompleted: json['isCompleted'],
      category: json['category'],
    );
  }
}
