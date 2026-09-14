import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/models/quote_draft.dart';
import '../domain/repositories/quote_repository.dart';

class QuoteRepositoryLocal implements QuoteRepository {
  static const _draftKey = 'quotes_draft';

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  @override
  Future<void> clearDraft() async {
    final prefs = await _prefs;
    await prefs.remove(_draftKey);
  }

  @override
  Future<QuoteDraft> getDraft() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_draftKey);
    if (raw == null || raw.isEmpty) {
      return QuoteDraft.empty();
    }

    try {
      return QuoteDraft.fromJson(
        Map<String, dynamic>.from(jsonDecode(raw) as Map),
      );
    } catch (_) {
      await prefs.remove(_draftKey);
      return QuoteDraft.empty();
    }
  }

  @override
  Future<void> saveDraft(QuoteDraft draft) async {
    final prefs = await _prefs;
    await prefs.setString(_draftKey, jsonEncode(draft.toJson()));
  }
}
