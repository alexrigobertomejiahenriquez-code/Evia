import '../../models/quote.dart';

abstract class QuoteRepository {
  Future<List<Quote>> getQuotes();
  Future<Quote?> getQuoteById(String id);
  Future<void> saveQuote(Quote quote);
  Future<void> deleteQuote(String id);
}
