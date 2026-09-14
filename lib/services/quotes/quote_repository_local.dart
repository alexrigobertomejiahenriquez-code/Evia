import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/quote.dart';
import 'quote_repository.dart';

class QuoteRepositoryLocal implements QuoteRepository {
  static const String _storageKey = 'evia_quotes';

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  @override
  Future<List<Quote>> getQuotes() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return <Quote>[];

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      final quotes = decoded
          .map((e) => Quote.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      quotes.sort((a, b) => b.date.compareTo(a.date));
      return quotes;
    } catch (_) {
      await prefs.remove(_storageKey);
      return <Quote>[];
    }
  }

  @override
  Future<Quote?> getQuoteById(String id) async {
    final quotes = await getQuotes();
    for (final quote in quotes) {
      if (quote.id == id) return quote;
    }
    return null;
  }

  @override
  Future<void> saveQuote(Quote quote) async {
    final prefs = await _prefs;
    final quotes = await getQuotes();
    final index = quotes.indexWhere((q) => q.id == quote.id);
    if (index >= 0) {
      quotes[index] = quote;
    } else {
      quotes.insert(0, quote);
    }
    final encoded = quotes.map((e) => e.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(encoded));
  }

  @override
  Future<void> deleteQuote(String id) async {
    final prefs = await _prefs;
    final quotes = await getQuotes();
    quotes.removeWhere((q) => q.id == id);
    final encoded = quotes.map((e) => e.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(encoded));
  }
}
