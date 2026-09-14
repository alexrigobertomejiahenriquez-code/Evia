import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:evia/models/quote.dart';
import 'package:evia/services/quotes/quote_repository_local.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Quote quote(String id, {String client = 'Cliente', double labor = 0}) {
    final day = id == '2' ? 2 : 1;
    return Quote(
      id: id,
      title: 'Q$id',
      client: client,
      date: DateTime.utc(2026, 1, day),
      workDescription: 'Trabajo',
      items: const [],
      laborCost: labor,
      otherCosts: 0,
      discount: 0,
      taxPercent: 0,
    );
  }

  test('guardar y cargar cotizaciones', () async {
    final repo = QuoteRepositoryLocal();
    await repo.saveQuote(quote('1', client: 'Ana'));
    await repo.saveQuote(quote('2', client: 'Luis'));

    final quotes = await repo.getQuotes();

    expect(quotes.length, 2);
    expect(quotes.first.id, '2');
    expect(quotes[1].client, 'Ana');
  });

  test('actualizar cotización existente por id', () async {
    final repo = QuoteRepositoryLocal();
    await repo.saveQuote(quote('1', client: 'Original'));

    await repo.saveQuote(quote('1', client: 'Actualizado', labor: 25));

    final loaded = await repo.getQuoteById('1');
    expect(loaded, isNotNull);
    expect(loaded!.client, 'Actualizado');
    expect(loaded.laborCost, 25);
  });

  test('eliminar cotización guardada', () async {
    final repo = QuoteRepositoryLocal();
    await repo.saveQuote(quote('1'));
    await repo.saveQuote(quote('2'));

    await repo.deleteQuote('1');

    final quotes = await repo.getQuotes();
    expect(quotes.length, 1);
    expect(quotes.first.id, '2');
  });

  test('maneja json corrupto limpiando storage', () async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('evia_quotes', 'no-json');

    final repo = QuoteRepositoryLocal();
    final quotes = await repo.getQuotes();

    expect(quotes, isEmpty);
    expect(prefs.getString('evia_quotes'), isNull);
  });
}
