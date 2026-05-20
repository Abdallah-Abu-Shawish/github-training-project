import 'package:flutter/material.dart';
import '../../../models/order_model.dart';

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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: const Border(left: BorderSide(color: Color(0xFF06A537), width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
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
                  const SizedBox(height: 6),
                  Text(
                    'Completed on $completedDate',
                    style: const TextStyle(fontSize: 14, color: Color(0xFF06A537)),
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
      ),
    );
  }
}
