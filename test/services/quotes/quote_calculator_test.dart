import 'package:flutter_test/flutter_test.dart';

import 'package:evia/models/quote.dart';
import 'package:evia/services/quotes/quote_calculator.dart';

void main() {
  Quote buildQuote({
    List<QuoteItem> items = const [],
    double labor = 0,
    double other = 0,
    double discount = 0,
    double taxPercent = 0,
    double? budget,
  }) {
    return Quote(
      id: 'q1',
      title: 'Cotización',
      client: 'Cliente',
      date: DateTime.utc(2026, 1, 1),
      workDescription: 'Trabajo',
      items: items,
      laborCost: labor,
      otherCosts: other,
      discount: discount,
      taxPercent: taxPercent,
      targetBudget: budget,
    );
  }

  test('calcula subtotal, descuento, impuesto y total en centavos', () {
    final quote = buildQuote(
      items: const [
        QuoteItem(id: '1', description: 'Cemento', quantity: 2, unit: 'bolsa', unitPrice: 10.50),
        QuoteItem(id: '2', description: 'Pintura', quantity: 1.5, unit: 'galón', unitPrice: 20),
      ],
      labor: 100.25,
      other: 9.75,
      discount: 10.10,
      taxPercent: 15,
    );

    final totals = QuoteCalculator.calculate(quote);

    expect(totals.itemsSubtotalCents, 5100);
    expect(totals.subtotalBeforeDiscountCents, 16100);
    expect(totals.discountCents, 1010);
    expect(totals.taxCents, 2264);
    expect(totals.totalCents, 17354);
    expect(totals.total, 173.54);
  });

  test('presupuesto exacto queda dentro del presupuesto', () {
    final quote = buildQuote(labor: 50, taxPercent: 0, budget: 50.00);

    final totals = QuoteCalculator.calculate(quote);

    expect(totals.totalCents, 5000);
    expect(totals.budgetDifferenceCents, 0);
    expect(totals.budgetStatus, BudgetStatus.withinBudget);
  });

  test('diferencia de 0.01 maneja estado exceso/disponible por centavos', () {
    final over = QuoteCalculator.calculate(buildQuote(labor: 10, budget: 9.99));
    final available = QuoteCalculator.calculate(buildQuote(labor: 10, budget: 10.01));

    expect(over.budgetDifferenceCents, -1);
    expect(over.budgetStatus, BudgetStatus.overBudget);

    expect(available.budgetDifferenceCents, 1);
    expect(available.budgetStatus, BudgetStatus.available);
  });

  test('valores decimales evitan ruido de punto flotante', () {
    final quote = buildQuote(
      items: const [
        QuoteItem(id: '1', description: 'Decimal', quantity: 0.1, unit: 'u', unitPrice: 0.2),
      ],
    );

    final totals = QuoteCalculator.calculate(quote);

    expect(totals.itemsSubtotalCents, 2);
    expect(totals.total, 0.02);
  });

  test('cotización sin materiales calcula solo mano de obra y extras', () {
    final quote = buildQuote(
      labor: 50,
      other: 20,
      discount: 10,
      taxPercent: 10,
    );

    final totals = QuoteCalculator.calculate(quote);

    expect(totals.itemsSubtotalCents, 0);
    expect(totals.taxableSubtotalCents, 6000);
    expect(totals.taxCents, 600);
    expect(totals.totalCents, 6600);
  });
}
