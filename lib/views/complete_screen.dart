import 'package:flutter/material.dart';
import 'package:orders_manager/views/widgets/completed_order_card.dart';
import '../controllers/order_controller.dart';
import '../models/order_model.dart';

class CompleteScreen extends StatelessWidget {
  final OrderController controller;
  final List<OrderModel> allOrders;
  final Future<void> Function() onRefresh;

  const CompleteScreen({
    super.key,
    required this.controller,
    required this.allOrders,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final completedItems = controller.completedItems(allOrders);
    final totalQuantity = controller.completedTotalQuantity(allOrders);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFF06A537),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.white, size: 32),
                    SizedBox(width: 12),
                    Text(
                      'Completed Orders',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Total: ${completedItems.length} order(s)',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 18),
                Container(height: 1, color: Colors.white.withOpacity(0.3)),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Items:',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      '$totalQuantity',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          if (completedItems.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 90),
              child: Column(
                children: [
                  Image.asset("images/cube_logo_gray.png", width: 100, height: 100, ),
                  const SizedBox(height: 18),
                  const Text(
                    'No completed orders yet.',
                    style: TextStyle(fontSize: 16, color: Color(0xFF9DA4B5)),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Select items and mark them as complete!',
                    style: TextStyle(fontSize: 14, color: Color(0xFF9DA4B5)),
                  ),
                ],
              ),
            )
          else
            ...completedItems.map(
                  (order) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: CompletedOrderCard(
                  order: order,
                  completedDate: controller.formatCompletedDate(order.completedAt),
                  onDelete: () async {
                    await controller.deleteOrder(order.id!);
                    await onRefresh();
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}