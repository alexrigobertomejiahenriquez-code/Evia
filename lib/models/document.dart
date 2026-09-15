class DocumentField {
  final String id;
  final String label;
  final String type; // texto, numero, fecha, casilla, seleccion, firma
  final List<String>? options;
  final bool required;

  const DocumentField({
    required this.id,
    required this.label,
    required this.type,
    this.options,
    this.required = false,
  });

  DocumentField copyWith({
    String? id,
    String? label,
    String? type,
    List<String>? options,
    bool? required,
  }) {
    return DocumentField(
      id: id ?? this.id,
      label: label ?? this.label,
      type: type ?? this.type,
      options: options ?? this.options,
      required: required ?? this.required,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'type': type,
        'options': options,
        'required': required,
      };

  factory DocumentField.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'];
    return DocumentField(
      id: json['id'] as String? ?? '',
      label: json['label'] as String? ?? '',
      type: json['type'] as String? ?? 'texto',
      options: rawOptions is List
          ? rawOptions
              .whereType<String>()
              .toList()
          : null,
      required: json['required'] as bool? ?? false,
    );
  }
}

class Document {
  final String id;
  final String title;
  final String? description;
  final String type;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status;
  final List<String>? tags;
  final String? projectId;
  final String? clientId;
  final List<DocumentField>? fields;

  const Document({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    this.tags,
    this.projectId,
    this.clientId,
    this.fields,
  });

  Document copyWith({
    String? id,
    String? title,
    String? description,
    bool clearDescription = false,
    String? type,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? status,
    List<String>? tags,
    bool clearTags = false,
    String? projectId,
    bool clearProjectId = false,
    String? clientId,
    bool clearClientId = false,
    List<DocumentField>? fields,
    bool clearFields = false,
  }) {
    return Document(
      id: id ?? this.id,
      title: title ?? this.title,
      description: clearDescription ? null : (description ?? this.description),
      type: type ?? this.type,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      tags: clearTags ? null : (tags ?? this.tags),
      projectId: clearProjectId ? null : (projectId ?? this.projectId),
      clientId: clearClientId ? null : (clientId ?? this.clientId),
      fields: clearFields ? null : (fields ?? this.fields),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'type': type,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'status': status,
        'tags': tags,
        'projectId': projectId,
        'clientId': clientId,
        'fields': fields?.map((field) => field.toJson()).toList(),
      };

  factory Document.fromJson(Map<String, dynamic> json) {
    final rawTags = json['tags'];
    final rawFields = json['fields'];

    return Document(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      type: json['type'] as String? ?? 'Documento',
      content: json['content'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? DateTime.now(),
      status: json['status'] as String? ?? 'borrador',
      tags: rawTags is List
          ? rawTags
              .whereType<String>()
              .toList()
          : null,
      projectId: json['projectId'] as String?,
      clientId: json['clientId'] as String?,
      fields: rawFields is List
          ? rawFields
              .map((e) => DocumentField.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList()
          : null,
    );
  }
}

const List<String> documentCategories = [
  'Documento',
  'Contrato',
  'Informe',
  'Tarea',
  'Apunte',
  'Formulario',
  'Checklist',
  'Otro',
];

const List<String> documentStatuses = [
  'borrador',
  'completado',
  'archivado',
];
