import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/order_model.dart';

class OrderController {
  Future<List<OrderModel>> getAllOrders() async {
    final db = await DBHelper.database;
    final result = await db.query('orders', orderBy: 'id DESC');
    return result.map((e) => OrderModel.fromMap(e)).toList();
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
  }

  Future<void> updateOrder(OrderModel order) async {
    final db = await DBHelper.database;
    await db.update(
      'orders',
      order.copyWith(updatedAt: DateTime.now().toIso8601String()).toMap(),
      where: 'id = ?',
      whereArgs: [order.id],
    );
  }

  Future<void> deleteOrder(int id) async {
    final db = await DBHelper.database;
    await db.delete('orders', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearAllOrders() async {
    final db = await DBHelper.database;
    await db.delete('orders');
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

  Future<void> showEditDialog({
    required BuildContext context,
    required OrderModel order,
    required VoidCallback onUpdated,
  }) async {
    final productController = TextEditingController(text: order.productName);
    final quantityController = TextEditingController(text: order.quantity.toString());

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Edit Order',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    )
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Update the product name and quantity',
                  style: TextStyle(color: Color(0xFF8E8E9A), fontSize: 14),
                ),
                const SizedBox(height: 16),
                const Text('Product Name', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextField(
                  controller: productController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF1F1F1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text('Quantity', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF1F1F1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final name = productController.text.trim();
                          final qty = int.tryParse(quantityController.text.trim()) ?? 0;

                          if (name.isEmpty || qty <= 0) return;

                          await updateOrder(
                            order.copyWith(
                              productName: name,
                              quantity: qty,
                            ),
                          );

                          if (context.mounted) {
                            Navigator.pop(context);
                            onUpdated();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Update'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}