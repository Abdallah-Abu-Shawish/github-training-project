import 'package:flutter/material.dart';
import 'package:orders_manager/views/widgets/completed_order_card.dart';
import 'package:orders_manager/views/widgets/confirm_action_dialog.dart';
import 'package:orders_manager/views/widgets/empty_state_widget.dart';
import 'package:orders_manager/views/widgets/summary_card.dart';
import '../controllers/order_controller.dart';

class CompleteScreen extends StatelessWidget {
  final OrderController controller;

  const CompleteScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final completedItems = controller.completedItems(controller.orders);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SummaryCard(
            icon: Icons.check_circle_outline,
            title: 'Completed Orders',
            value: '${controller.completedOrdersCount} order(s)',
            subtitle: 'Total quantity: ${controller.completedQuantityTotal}',
            color: const Color(0xFF06A537),
            filled: true,
          ),
          const SizedBox(height: 22),
          if (completedItems.isEmpty)
            const EmptyStateWidget(
              icon: Icons.check_circle_outline,
              title: 'No completed orders yet',
              message: 'Select orders and mark them as complete.',
              assetName: 'images/cube_logo_gray.png',
            )
          else
            ...completedItems.map(
              (order) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: CompletedOrderCard(
                  order: order,
                  completedDate: controller.formatCompletedDate(
                    order.completedAt,
                  ),
                  onDelete: () async {
                    final confirmed = await showConfirmActionDialog(
                      context: context,
                      title: 'Delete completed order?',
                      message:
                          'This completed order will be removed permanently.',
                      confirmText: 'Delete',
                    );

                    if (confirmed) {
                      await controller.deleteOrder(order.id!);
                    }
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
