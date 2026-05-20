import 'package:flutter/material.dart';
import '../../../models/order_model.dart';
import 'app_card.dart';

class CompletedOrderCard extends StatelessWidget {
  final OrderModel order;
  final String completedDate;
  final VoidCallback onDelete;

  const CompletedOrderCard({
    super.key,
    required this.order,
    required this.completedDate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      border: const Border(
        left: BorderSide(color: Color(0xFF06A537), width: 4),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: Color(0xFF06A537),
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.productName,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF102447),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Quantity: ${order.quantity}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF5E6C84),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Completed on $completedDate',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF06A537),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
