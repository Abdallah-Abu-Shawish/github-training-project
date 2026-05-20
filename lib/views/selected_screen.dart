import 'package:flutter/material.dart';
import 'package:orders_manager/views/widgets/primary_button.dart';
import 'package:orders_manager/views/widgets/selected_order_card.dart';
import '../controllers/order_controller.dart';
import '../models/order_model.dart';



class SelectedScreen extends StatelessWidget {
  final OrderController controller;
  final List<OrderModel> allOrders;
  final Future<void> Function() onRefresh;
  final void Function(int count) onCompleted;

  const SelectedScreen({
    super.key,
    required this.controller,
    required this.allOrders,
    required this.onRefresh,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final selectedItems = controller.selectedItems(allOrders);
    final totalQuantity = controller.selectedTotalQuantity(allOrders);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
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
                Text(
                  'Selected Items (${selectedItems.length})',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (selectedItems.isNotEmpty) ...[
                  const SizedBox(height: 18),

                  PrimaryButton(
                    text: 'Complete Selected Items',
                    backgroundColor: const Color(0xFF06A537),
                    foregroundColor: Colors.white,
                    onPressed: () async {
                      final count = await controller.completeSelectedItems();
                      await onRefresh();
                      onCompleted(count);
                    },
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 18),
          if (selectedItems.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 90),
              child: Text(
                'No items selected. Go to the List tab and select items.',
                style: TextStyle(fontSize: 16, color: Color(0xFF9DA4B5)),
                textAlign: TextAlign.center,
              ),
            )
          else ...[
            ...selectedItems.map(
                  (order) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: SelectedOrderCard(
                  order: order,
                  onUnselect: () async {
                    await controller.toggleSelected(order, false);
                    await onRefresh();
                  },
                  onDelete: () async {
                    await controller.deleteOrder(order.id!);
                    await onRefresh();
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Quantity:',
                    style: TextStyle(fontSize: 16, color: Color(0xFF334E75)),
                  ),
                  Text(
                    '$totalQuantity',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
