class QuoteLineItem {
  final String id;
  final String category;
  final String description;
  final double quantity;
  final double unitPrice;

  const QuoteLineItem({
    required this.id,
    required this.category,
    required this.description,
    required this.quantity,
    required this.unitPrice,
  });

  double get subtotal => quantity * unitPrice;

  QuoteLineItem copyWith({
    String? id,
    String? category,
    String? description,
    double? quantity,
    double? unitPrice,
  }) {
    return QuoteLineItem(
      id: id ?? this.id,
      category: category ?? this.category,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'description': description,
        'quantity': quantity,
        'unitPrice': unitPrice,
      };

  factory QuoteLineItem.fromJson(Map<String, dynamic> json) {
    return QuoteLineItem(
      id: json['id'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unitPrice: (json['unitPrice'] as num).toDouble(),
    );
  }
}
