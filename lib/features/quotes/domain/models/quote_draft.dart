import 'quote_line_item.dart';

class QuoteDraft {
  final String title;
  final String customerName;
  final String notes;
  final double discountPercent;
  final double targetBudget;
  final List<QuoteLineItem> items;

  const QuoteDraft({
    required this.title,
    required this.customerName,
    required this.notes,
    required this.discountPercent,
    required this.targetBudget,
    required this.items,
  });

  factory QuoteDraft.empty() {
    return const QuoteDraft(
      title: 'Cotización general',
      customerName: '',
      notes: '',
      discountPercent: 0,
      targetBudget: 0,
      items: [],
    );
  }

  double get subtotal => items.fold(0, (sum, item) => sum + item.subtotal);

  double get discountAmount => subtotal * (discountPercent / 100);

  double get total => subtotal - discountAmount;

  double get remainingBudget => targetBudget - total;

  QuoteDraft copyWith({
    String? title,
    String? customerName,
    String? notes,
    double? discountPercent,
    double? targetBudget,
    List<QuoteLineItem>? items,
  }) {
    return QuoteDraft(
      title: title ?? this.title,
      customerName: customerName ?? this.customerName,
      notes: notes ?? this.notes,
      discountPercent: discountPercent ?? this.discountPercent,
      targetBudget: targetBudget ?? this.targetBudget,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'customerName': customerName,
        'notes': notes,
        'discountPercent': discountPercent,
        'targetBudget': targetBudget,
        'items': items.map((item) => item.toJson()).toList(),
      };

  factory QuoteDraft.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? const [];
    return QuoteDraft(
      title: json['title'] as String? ?? 'Cotización general',
      customerName: json['customerName'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      discountPercent: (json['discountPercent'] as num?)?.toDouble() ?? 0,
      targetBudget: (json['targetBudget'] as num?)?.toDouble() ?? 0,
      items: rawItems.map((item) => QuoteLineItem.fromJson(Map<String, dynamic>.from(item as Map))).toList(),
    );
  }
}
