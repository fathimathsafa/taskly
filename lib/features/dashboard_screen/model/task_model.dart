class Task {
  final String id;
  final String title;
  final String description;
  final String status; // 'pending', 'in progress', 'completed', 'on hold'
  final String priority; // 'low', 'medium', 'high'
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;
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
    DateTime? updatedAt,
    this.project = '{SW} DashX Accounts Portal',
    this.assignee = 'Fathima Nasrin V K',
    this.reviewer = 'Fathima Nasrin V K',
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? (createdAt ?? DateTime.now());

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    String? priority,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
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
      updatedAt: updatedAt ?? this.updatedAt,
      project: project ?? this.project,
      assignee: assignee ?? this.assignee,
      reviewer: reviewer ?? this.reviewer,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'dueDate': dueDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'project': project,
      'assignee': assignee,
      'reviewer': reviewer,
    };
  }

  factory Task.fromMap(Map<dynamic, dynamic> map) {
    return Task(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      status: map['status'] as String? ?? 'pending',
      priority: map['priority'] as String? ?? 'medium',
      dueDate: map['dueDate'] != null ? DateTime.tryParse(map['dueDate'] as String) : null,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt'] as String) : DateTime.now(),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'] as String) : DateTime.now(),
      project: map['project'] as String? ?? 'Taskly Project',
      assignee: map['assignee'] as String? ?? 'Admin User',
      reviewer: map['reviewer'] as String? ?? 'Admin User',
    );
  }
}
