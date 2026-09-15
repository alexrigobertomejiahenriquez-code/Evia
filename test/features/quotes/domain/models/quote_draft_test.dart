import 'package:flutter_test/flutter_test.dart';

import 'package:evia/features/quotes/domain/models/quote_draft.dart';
import 'package:evia/features/quotes/domain/models/quote_line_item.dart';

void main() {
  group('QuoteDraft', () {
    test('calculates subtotal, discount and total', () {
      final draft = QuoteDraft(
        title: 'Reforma cocina',
        customerName: 'Ana',
        notes: '',
        discountPercent: 10,
        targetBudget: 1200,
        items: const [
          QuoteLineItem(
            id: '1',
            category: 'Material',
            description: 'Piso porcelánico',
            quantity: 10,
            unitPrice: 35,
          ),
          QuoteLineItem(
            id: '2',
            category: 'Servicio',
            description: 'Instalación',
            quantity: 1,
            unitPrice: 250,
          ),
        ],
      );

      expect(draft.subtotal, 600);
      expect(draft.discountAmount, 60);
      expect(draft.total, 540);
      expect(draft.remainingBudget, 660);
    });

    test('serializes and restores line items', () {
      final original = QuoteDraft(
        title: 'Cotización general',
        customerName: 'Cliente demo',
        notes: 'Entrega en 48h',
        discountPercent: 5,
        targetBudget: 0,
        items: const [
          QuoteLineItem(
            id: '1',
            category: 'Producto',
            description: 'Kit eléctrico',
            quantity: 2,
            unitPrice: 99.9,
          ),
        ],
      );

      final restored = QuoteDraft.fromJson(original.toJson());

      expect(restored.title, original.title);
      expect(restored.customerName, original.customerName);
      expect(restored.notes, original.notes);
      expect(restored.discountPercent, original.discountPercent);
      expect(restored.items.length, 1);
      expect(restored.items.first.description, 'Kit eléctrico');
      expect(restored.items.first.subtotal, closeTo(199.8, 0.0001));
    });
  });
}
