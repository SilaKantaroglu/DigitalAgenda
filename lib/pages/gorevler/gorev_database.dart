class Task {
  final int id;
  final String title;
  bool completed;

  Task({required this.id, required this.title, this.completed = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'completed': completed ? 1 : 0,
    };
  }
}
