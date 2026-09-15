import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:evia/features/quotes/data/quote_repository_local.dart';
import 'package:evia/features/quotes/domain/models/quote_draft.dart';
import 'package:evia/features/quotes/domain/models/quote_line_item.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('QuoteRepositoryLocal', () {
    test('returns an empty draft when storage is empty', () async {
      final repository = QuoteRepositoryLocal();

      final draft = await repository.getDraft();

      expect(draft.title, 'Cotización general');
      expect(draft.items, isEmpty);
      expect(draft.total, 0);
    });

    test('saves and restores a draft', () async {
      final repository = QuoteRepositoryLocal();
      final draft = QuoteDraft(
        title: 'Presupuesto oficina',
        customerName: 'Empresa X',
        notes: 'Incluye instalación',
        discountPercent: 8,
        targetBudget: 2500,
        items: const [
          QuoteLineItem(
            id: '1',
            category: 'Material',
            description: 'Cableado',
            quantity: 30,
            unitPrice: 12.5,
          ),
        ],
      );

      await repository.saveDraft(draft);
      final restored = await repository.getDraft();

      expect(restored.title, draft.title);
      expect(restored.customerName, draft.customerName);
      expect(restored.notes, draft.notes);
      expect(restored.discountPercent, draft.discountPercent);
      expect(restored.targetBudget, draft.targetBudget);
      expect(restored.items.single.description, 'Cableado');
    });

    test('clears corrupt storage gracefully', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('quotes_draft', 'not-json');

      final repository = QuoteRepositoryLocal();
      final draft = await repository.getDraft();

      expect(draft.items, isEmpty);
      expect(prefs.getString('quotes_draft'), isNull);
    });
  });
}
