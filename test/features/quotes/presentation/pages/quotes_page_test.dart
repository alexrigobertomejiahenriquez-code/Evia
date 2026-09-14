import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:evia/features/quotes/domain/models/quote_draft.dart';
import 'package:evia/features/quotes/domain/models/quote_line_item.dart';
import 'package:evia/features/quotes/domain/repositories/quote_repository.dart';
import 'package:evia/features/quotes/presentation/pages/quotes_page.dart';

class FakeQuoteRepository implements QuoteRepository {
  QuoteDraft draft;

  FakeQuoteRepository(this.draft);

  @override
  Future<void> clearDraft() async {
    draft = QuoteDraft.empty();
  }

  @override
  Future<QuoteDraft> getDraft() async => draft;

  @override
  Future<void> saveDraft(QuoteDraft draft) async {
    this.draft = draft;
  }
}

void main() {
  testWidgets('renders stored totals and updates after removing an item', (
    tester,
  ) async {
    final repository = FakeQuoteRepository(
      QuoteDraft(
        title: 'Remodelación',
        customerName: 'Cliente demo',
        notes: '',
        discountPercent: 10,
        targetBudget: 1000,
        items: const [
          QuoteLineItem(
            id: '1',
            category: 'Material',
            description: 'Pintura',
            quantity: 4,
            unitPrice: 50,
          ),
          QuoteLineItem(
            id: '2',
            category: 'Servicio',
            description: 'Aplicación',
            quantity: 1,
            unitPrice: 100,
          ),
        ],
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: QuotesPage(repository: repository),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Remodelación'), findsOneWidget);
    expect(find.text('\$300.00'), findsWidgets);
    expect(find.textContaining('10.0%'), findsOneWidget);
    expect(find.text('\$270.00'), findsOneWidget);

    await tester.tap(find.byTooltip('Eliminar línea').first);
    await tester.pumpAndSettle();

    expect(find.text('Pintura'), findsNothing);
    expect(find.text('\$100.00'), findsWidgets);
    expect(repository.draft.items.length, 1);
  });
}
