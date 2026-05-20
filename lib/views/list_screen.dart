import 'package:flutter/material.dart';
import 'package:orders_manager/views/widgets/custom_text_field.dart';
import 'package:orders_manager/views/widgets/order_list_card.dart';
import 'package:orders_manager/views/widgets/primary_button.dart';
import '../controllers/order_controller.dart';
import '../models/order_model.dart';

class ListScreen extends StatelessWidget {
  final OrderController controller;
  final List<OrderModel> allOrders;
  final TextEditingController productController;
  final TextEditingController quantityController;
  final Future<void> Function() onAdd;
  final Future<void> Function() onRefresh;

  const ListScreen({
    super.key,
    required this.controller,
    required this.allOrders,
    required this.productController,
    required this.quantityController,
    required this.onAdd,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final listItems = controller.listItems(allOrders);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Product Name', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                CustomTextField(controller: productController, hintText: 'Enter product name'),
                const SizedBox(height: 16),
                const Text('Quantity', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: quantityController,
                  hintText: '1',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 18),
                PrimaryButton(text: 'Add', onPressed: () => onAdd()),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Registered Orders (${listItems.length})',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (listItems.isNotEmpty)
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () async {
                      await controller.clearAllOrders();
                      await onRefresh();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Clear All'),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
          if (listItems.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 80),
              child: Center(
                child: Text(
                  'No orders yet. Add your first order above!',
                  style: TextStyle(fontSize: 16, color: Color(0xFF9DA4B5)),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            ...listItems.asMap().entries.map(
                  (entry) {
                final index = entry.key;
                final order = entry.value;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: OrderListCard(
                    order: order,
                    displayIndex: index + 1,
                    onToggle: (value) async {
                      await controller.toggleSelected(order, value);
                      await onRefresh();
                    },
                    onEdit: () async {
                      await controller.showEditDialog(
                        context: context,
                        order: order,
                        onUpdated: () async => await onRefresh(),
                      );
                    },
                    onDelete: () async {
                      await controller.deleteOrder(order.id!);
                      await onRefresh();
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}