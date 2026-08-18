class Task {
  final String id;
  final String title;
  final String description;
  final String status; // 'pending', 'in progress', 'completed', 'on hold'
  final String priority; // 'low', 'medium', 'high'
  final DateTime? dueDate;
  final DateTime createdAt;
  final String project;
  final String assignee;
  final String reviewer;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.status = 'pending',
    this.priority = 'medium',
    this.dueDate,
    DateTime? createdAt,
    this.project = '{SW} DashX Accounts Portal',
    this.assignee = 'Fathima Nasrin V K',
    this.reviewer = 'Fathima Nasrin V K',
  }) : createdAt = createdAt ?? DateTime.now();

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    String? priority,
    DateTime? dueDate,
    DateTime? createdAt,
    String? project,
    String? assignee,
    String? reviewer,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      project: project ?? this.project,
      assignee: assignee ?? this.assignee,
      reviewer: reviewer ?? this.reviewer,
    );
  }
}
