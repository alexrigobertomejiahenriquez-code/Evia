// lib/features/shopping/domain/repositories/shopping_repository.dart

import '../../domain/models/shopping_item.dart';

abstract class ShoppingRepository {
  Future<List<ShoppingItem>> getItems();
  Future<void> addItem(ShoppingItem item);
  Future<void> removeItem(String id);
  Future<double> getBudget();
  Future<void> setBudget(double budget);
}
