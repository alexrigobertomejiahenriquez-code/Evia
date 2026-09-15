class QuoteItem {
  final String id;
  final String description;
  final double quantity;
  final String unit;
  final double unitPrice;

  const QuoteItem({
    required this.id,
    required this.description,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
  });

  QuoteItem copyWith({
    String? id,
    String? description,
    double? quantity,
    String? unit,
    double? unitPrice,
  }) {
    return QuoteItem(
      id: id ?? this.id,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'quantity': quantity,
        'unit': unit,
        'unitPrice': unitPrice,
      };

  factory QuoteItem.fromJson(Map<String, dynamic> json) {
    return QuoteItem(
      id: json['id'] as String? ?? '',
      description: json['description'] as String? ?? '',
      quantity: _asFiniteDouble(json['quantity']),
      unit: json['unit'] as String? ?? '',
      unitPrice: _asFiniteDouble(json['unitPrice']),
    );
  }
}

class Quote {
  final String id;
  final String title;
  final String client;
  final DateTime date;
  final String workDescription;
  final List<QuoteItem> items;
  final double laborCost;
  final double otherCosts;
  final double discount;
  final double taxPercent;
  final double? targetBudget;
  final String? projectId;
  final String? projectName;

  const Quote({
    required this.id,
    required this.title,
    required this.client,
    required this.date,
    required this.workDescription,
    required this.items,
    required this.laborCost,
    required this.otherCosts,
    required this.discount,
    required this.taxPercent,
    this.targetBudget,
    this.projectId,
    this.projectName,
  });

  Quote copyWith({
    String? id,
    String? title,
    String? client,
    DateTime? date,
    String? workDescription,
    List<QuoteItem>? items,
    double? laborCost,
    double? otherCosts,
    double? discount,
    double? taxPercent,
    double? targetBudget,
    bool clearTargetBudget = false,
    String? projectId,
    bool clearProjectId = false,
    String? projectName,
    bool clearProjectName = false,
  }) {
    return Quote(
      id: id ?? this.id,
      title: title ?? this.title,
      client: client ?? this.client,
      date: date ?? this.date,
      workDescription: workDescription ?? this.workDescription,
      items: items ?? this.items,
      laborCost: laborCost ?? this.laborCost,
      otherCosts: otherCosts ?? this.otherCosts,
      discount: discount ?? this.discount,
      taxPercent: taxPercent ?? this.taxPercent,
      targetBudget:
          clearTargetBudget ? null : (targetBudget ?? this.targetBudget),
      projectId: clearProjectId ? null : (projectId ?? this.projectId),
      projectName: clearProjectName ? null : (projectName ?? this.projectName),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'client': client,
        'date': date.toIso8601String(),
        'workDescription': workDescription,
        'items': items.map((e) => e.toJson()).toList(),
        'laborCost': laborCost,
        'otherCosts': otherCosts,
        'discount': discount,
        'taxPercent': taxPercent,
        'targetBudget': targetBudget,
        'projectId': projectId,
        'projectName': projectName,
      };

  factory Quote.fromJson(Map<String, dynamic> json) {
    final itemsRaw = json['items'];
    return Quote(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      client: json['client'] as String? ?? '',
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      workDescription: json['workDescription'] as String? ?? '',
      items: itemsRaw is List
          ? itemsRaw
              .map((e) =>
                  QuoteItem.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList()
          : const [],
      laborCost: _asFiniteDouble(json['laborCost']),
      otherCosts: _asFiniteDouble(json['otherCosts']),
      discount: _asFiniteDouble(json['discount']),
      taxPercent: _asFiniteDouble(json['taxPercent']),
      targetBudget: json['targetBudget'] == null
          ? null
          : _asFiniteDouble(json['targetBudget']),
      projectId: json['projectId'] as String?,
      projectName: json['projectName'] as String?,
    );
  }
}

double _asFiniteDouble(dynamic value) {
  if (value is num) {
    final d = value.toDouble();
    return d.isFinite ? d : 0;
  }
  if (value is String) {
    final parsed = double.tryParse(value);
    return parsed != null && parsed.isFinite ? parsed : 0;
  }
  return 0;
}
