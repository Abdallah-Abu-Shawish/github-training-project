import 'package:get/get.dart';
import '../database/db_helper.dart';
import '../models/order_model.dart';

class OrderController extends GetxController {
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;

  int get totalOrders => orders.length;
  int get selectedOrdersCount => selectedItems(orders).length;
  int get completedOrdersCount => completedItems(orders).length;
  int get selectedQuantityTotal => selectedTotalQuantity(orders);
  int get completedQuantityTotal => completedTotalQuantity(orders);

  Future<void> loadOrders() async {
    isLoading.value = true;

    final loadedOrders = await getAllOrders();
    orders.assignAll(loadedOrders);

    isLoading.value = false;
  }

  Future<List<OrderModel>> getAllOrders() async {
    final db = await DBHelper.database;
    final result = await db.query('orders', orderBy: 'id DESC');
    return result.map((e) => OrderModel.fromMap(e)).toList();
  }

  String? validateOrderInput({
    required String productName,
    required String quantity,
  }) {
    final name = productName.trim();
    final parsedQuantity = int.tryParse(quantity.trim());

    if (name.isEmpty) {
      return 'Product name is required.';
    }

    if (name.length < 2) {
      return 'Product name is too short.';
    }

    if (parsedQuantity == null) {
      return 'Quantity must be a number.';
    }

    if (parsedQuantity <= 0) {
      return 'Quantity must be greater than zero.';
    }

    if (parsedQuantity > 9999) {
      return 'Quantity is too large.';
    }

    return null;
  }

  Future<String?> addOrderFromInput({
    required String productName,
    required String quantity,
  }) async {
    final error = validateOrderInput(
      productName: productName,
      quantity: quantity,
    );

    if (error != null) return error;

    await addOrder(productName.trim(), int.parse(quantity.trim()));
    return null;
  }

  Future<void> addOrder(String productName, int quantity) async {
    final db = await DBHelper.database;
    final now = DateTime.now().toIso8601String();

    await db.insert('orders', {
      'product_name': productName,
      'quantity': quantity,
      'is_selected': 0,
      'is_completed': 0,
      'created_at': now,
      'updated_at': now,
      'completed_at': null,
    });

    await loadOrders();
  }

  Future<String?> updateOrderFromInput({
    required OrderModel order,
    required String productName,
    required String quantity,
  }) async {
    final error = validateOrderInput(
      productName: productName,
      quantity: quantity,
    );

    if (error != null) return error;

    await updateOrder(
      order.copyWith(
        productName: productName.trim(),
        quantity: int.parse(quantity.trim()),
      ),
    );

    return null;
  }

  Future<void> updateOrder(OrderModel order) async {
    final db = await DBHelper.database;
    await db.update(
      'orders',
      order.copyWith(updatedAt: DateTime.now().toIso8601String()).toMap(),
      where: 'id = ?',
      whereArgs: [order.id],
    );

    await loadOrders();
  }

  Future<void> deleteOrder(int id) async {
    final db = await DBHelper.database;
    await db.delete('orders', where: 'id = ?', whereArgs: [id]);
    await loadOrders();
  }

  Future<void> clearAllOrders() async {
    final db = await DBHelper.database;
    await db.delete('orders');
    await loadOrders();
  }

  Future<void> toggleSelected(OrderModel order, bool value) async {
    final db = await DBHelper.database;
    await db.update(
      'orders',
      {
        'is_selected': value ? 1 : 0,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [order.id],
    );

    await loadOrders();
  }

  Future<int> completeSelectedItems() async {
    final db = await DBHelper.database;
    final selected = await db.query(
      'orders',
      where: 'is_selected = ? AND is_completed = ?',
      whereArgs: [1, 0],
    );

    final now = DateTime.now().toIso8601String();

    await db.update(
      'orders',
      {
        'is_completed': 1,
        'is_selected': 0,
        'completed_at': now,
        'updated_at': now,
      },
      where: 'is_selected = ? AND is_completed = ?',
      whereArgs: [1, 0],
    );

    await loadOrders();
    return selected.length;
  }

  String formatCompletedDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return '';
    final date = DateTime.tryParse(isoDate);
    if (date == null) return '';
    return '${date.year}/${date.month}/${date.day}';
  }

  List<OrderModel> listItems(List<OrderModel> orders) {
    return orders.where((e) => !e.isCompleted).toList();
  }

  List<OrderModel> selectedItems(List<OrderModel> orders) {
    return orders.where((e) => e.isSelected && !e.isCompleted).toList();
  }

  List<OrderModel> completedItems(List<OrderModel> orders) {
    return orders.where((e) => e.isCompleted).toList();
  }

  int selectedTotalQuantity(List<OrderModel> orders) {
    return selectedItems(orders).fold(0, (sum, item) => sum + item.quantity);
  }

  int completedTotalQuantity(List<OrderModel> orders) {
    return completedItems(orders).fold(0, (sum, item) => sum + item.quantity);
  }
}
