import '../../models/quote.dart';

enum BudgetStatus { notSet, withinBudget, overBudget, available }

class QuoteTotals {
  final int itemsSubtotalCents;
  final int laborCostCents;
  final int otherCostsCents;
  final int subtotalBeforeDiscountCents;
  final int discountCents;
  final int taxableSubtotalCents;
  final int taxCents;
  final int totalCents;
  final int? targetBudgetCents;
  final int? budgetDifferenceCents;
  final BudgetStatus budgetStatus;

  const QuoteTotals({
    required this.itemsSubtotalCents,
    required this.laborCostCents,
    required this.otherCostsCents,
    required this.subtotalBeforeDiscountCents,
    required this.discountCents,
    required this.taxableSubtotalCents,
    required this.taxCents,
    required this.totalCents,
    required this.targetBudgetCents,
    required this.budgetDifferenceCents,
    required this.budgetStatus,
  });

  double get itemsSubtotal => fromCents(itemsSubtotalCents);
  double get laborCost => fromCents(laborCostCents);
  double get otherCosts => fromCents(otherCostsCents);
  double get subtotalBeforeDiscount => fromCents(subtotalBeforeDiscountCents);
  double get discount => fromCents(discountCents);
  double get taxableSubtotal => fromCents(taxableSubtotalCents);
  double get tax => fromCents(taxCents);
  double get total => fromCents(totalCents);
  double? get targetBudget => targetBudgetCents == null ? null : fromCents(targetBudgetCents!);
  double? get budgetDifference => budgetDifferenceCents == null ? null : fromCents(budgetDifferenceCents!);

  String get budgetStatusLabel {
    switch (budgetStatus) {
      case BudgetStatus.notSet:
        return 'Sin presupuesto';
      case BudgetStatus.withinBudget:
        return 'Dentro del presupuesto';
      case BudgetStatus.overBudget:
        return 'Exceso';
      case BudgetStatus.available:
        return 'Disponible';
    }
  }
}

class QuoteCalculator {
  static QuoteTotals calculate(Quote quote) {
    final itemsSubtotal = quote.items.fold<int>(0, (sum, item) {
      final quantity = _toScaledInt(item.quantity, scale: 1000);
      final unitPriceCents = toCents(item.unitPrice);
      final lineCents = ((quantity * unitPriceCents) / 1000).round();
      return sum + lineCents;
    });

    final labor = toCents(quote.laborCost);
    final others = toCents(quote.otherCosts);
    final subtotalBeforeDiscount = itemsSubtotal + labor + others;

    final rawDiscount = toCents(quote.discount);
    final discount = rawDiscount.clamp(0, subtotalBeforeDiscount).toInt();

    final taxable = subtotalBeforeDiscount - discount;
    final tax = ((taxable * _safePercent(quote.taxPercent)) / 100).round();
    final total = taxable + tax;

    final budgetCents = quote.targetBudget == null ? null : toCents(quote.targetBudget!);
    final difference = budgetCents == null ? null : budgetCents - total;
    final status = _budgetStatus(budgetCents, difference);

    return QuoteTotals(
      itemsSubtotalCents: itemsSubtotal,
      laborCostCents: labor,
      otherCostsCents: others,
      subtotalBeforeDiscountCents: subtotalBeforeDiscount,
      discountCents: discount,
      taxableSubtotalCents: taxable,
      taxCents: tax,
      totalCents: total,
      targetBudgetCents: budgetCents,
      budgetDifferenceCents: difference,
      budgetStatus: status,
    );
  }

  static BudgetStatus _budgetStatus(int? budgetCents, int? difference) {
    if (budgetCents == null || difference == null) return BudgetStatus.notSet;
    if (difference == 0) return BudgetStatus.withinBudget;
    if (difference < 0) return BudgetStatus.overBudget;
    return BudgetStatus.available;
  }

  static int toCents(double value) {
    if (!value.isFinite) return 0;
    return (value * 100).round();
  }

  static double fromCents(int cents) => cents / 100;

  static int _toScaledInt(double value, {required int scale}) {
    if (!value.isFinite) return 0;
    return (value * scale).round();
  }

  static double _safePercent(double value) {
    if (!value.isFinite || value <= 0) return 0;
    return value;
  }
}
