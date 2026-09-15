import '../models/quote_draft.dart';

abstract class QuoteRepository {
  Future<QuoteDraft> getDraft();
  Future<void> saveDraft(QuoteDraft draft);
  Future<void> clearDraft();
}
