import 'package:flutter/material.dart';
import '../../models/order_model.dart';

class SelectedOrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onUnselect;
  final VoidCallback onDelete;

  const SelectedOrderCard({
    super.key,
    required this.order,
    required this.onUnselect,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Color(0xFF06A537), size: 28),
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
                  style: const TextStyle(fontSize: 14, color: Color(0xFF5E6C84)),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onUnselect,
            child: const Text(
              'Unselect',
              style: TextStyle(color: Color(0xFF334E75), fontWeight: FontWeight.w600),
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
