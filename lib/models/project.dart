// lib/models/project.dart

class Project {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;
  final DateTime? startDate;
  final DateTime? endDate;
  final String status; // 'planning', 'in_progress', 'completed', 'on_hold'
  final String? address;
  final double? estimatedBudget;
  final List<String> tags;

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    this.startDate,
    this.endDate,
    this.status = 'planning',
    this.address,
    this.estimatedBudget,
    this.tags = const [],
  });

  Project copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? createdAt,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? address,
    double? estimatedBudget,
    List<String>? tags,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      address: address ?? this.address,
      estimatedBudget: estimatedBudget ?? this.estimatedBudget,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'createdAt': createdAt.toIso8601String(),
        'startDate': startDate?.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'status': status,
        'address': address,
        'estimatedBudget': estimatedBudget,
        'tags': tags,
      };

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate'] as String) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate'] as String) : null,
      status: json['status'] as String? ?? 'planning',
      address: json['address'] as String?,
      estimatedBudget: (json['estimatedBudget'] as num?)?.toDouble(),
      tags: List<String>.from(json['tags'] as List? ?? []),
    );
  }
}
