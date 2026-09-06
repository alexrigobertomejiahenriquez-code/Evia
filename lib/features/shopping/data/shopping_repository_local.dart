import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/shopping_item.dart';
import '../../domain/repositories/shopping_repository.dart';

class ShoppingRepositoryLocal implements ShoppingRepository {
  static const _itemsKey = 'shopping_items';
  static const _budgetKey = 'shopping_budget';

  Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();

  @override
  Future<void> addItem(ShoppingItem item) async {
    final prefs = await _prefs;
    final items = await getItems();
    items.add(item);
    final encoded = items.map((e) => e.toJson()).toList();
    await prefs.setString(_itemsKey, jsonEncode(encoded));
  }

  @override
  Future<List<ShoppingItem>> getItems() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_itemsKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw) as List;
      return decoded.map((m) => ShoppingItem.fromJson(Map<String, dynamic>.from(m))).toList();
    } catch (e) {
      // si hay error, limpiar y devolver lista vacía
      await prefs.remove(_itemsKey);
      return [];
    }
  }

  @override
  Future<void> removeItem(String id) async {
    final prefs = await _prefs;
    final items = await getItems();
    items.removeWhere((i) => i.id == id);
    final encoded = items.map((e) => e.toJson()).toList();
    await prefs.setString(_itemsKey, jsonEncode(encoded));
  }

  Future<void> updateItem(ShoppingItem item) async {
    final prefs = await _prefs;
    final items = await getItems();
    final idx = items.indexWhere((i) => i.id == item.id);
    if (idx >= 0) {
      items[idx] = item;
      final encoded = items.map((e) => e.toJson()).toList();
      await prefs.setString(_itemsKey, jsonEncode(encoded));
    } else {
      // si no existe agregar
      items.add(item);
      await prefs.setString(_itemsKey, jsonEncode(items.map((e) => e.toJson()).toList()));
    }
  }

  @override
  Future<double> getBudget() async {
    final prefs = await _prefs;
    return prefs.getDouble(_budgetKey) ?? 0.0;
  }

  @override
  Future<void> setBudget(double budget) async {
    final prefs = await _prefs;
    await prefs.setDouble(_budgetKey, budget);
  }

  // Extra: toggle completado
  Future<void> toggleComplete(String id, bool completed) async {
    final prefs = await _prefs;
    final items = await getItems();
    final idx = items.indexWhere((i) => i.id == id);
    if (idx >= 0) {
      final updated = items[idx].copyWith(completado: completed);
      items[idx] = updated;
      await prefs.setString(_itemsKey, jsonEncode(items.map((e) => e.toJson()).toList()));
    }
  }
}
