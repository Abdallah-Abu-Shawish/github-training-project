import 'package:flutter/material.dart';
import 'package:orders_manager/views/widgets/confirm_action_dialog.dart';
import 'package:orders_manager/views/widgets/empty_state_widget.dart';
import 'package:orders_manager/views/widgets/primary_button.dart';
import 'package:orders_manager/views/widgets/selected_order_card.dart';
import 'package:orders_manager/views/widgets/summary_card.dart';
import '../controllers/order_controller.dart';

class SelectedScreen extends StatelessWidget {
  final OrderController controller;
  final void Function(int count) onCompleted;

  const SelectedScreen({
    super.key,
    required this.controller,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final selectedItems = controller.selectedItems(controller.orders);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SummaryCard(
            icon: Icons.check_box_outlined,
            title: 'Selected Items',
            value: '${controller.selectedOrdersCount} order(s)',
            subtitle: 'Total quantity: ${controller.selectedQuantityTotal}',
            color: const Color(0xFF334E75),
          ),
          if (selectedItems.isNotEmpty) ...[
            const SizedBox(height: 16),
            PrimaryButton(
              text: 'Complete Selected Items',
              backgroundColor: const Color(0xFF06A537),
              foregroundColor: Colors.white,
              onPressed: () async {
                final count = await controller.completeSelectedItems();
                onCompleted(count);
              },
            ),
          ],
          const SizedBox(height: 18),
          if (selectedItems.isEmpty)
            const EmptyStateWidget(
              icon: Icons.check_box_outline_blank,
              title: 'No selected orders',
              message:
                  'Choose orders from the List tab before completing them.',
            )
          else ...[
            ...selectedItems.map(
              (order) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: SelectedOrderCard(
                  order: order,
                  onUnselect: () async {
                    await controller.toggleSelected(order, false);
                  },
                  onDelete: () async {
                    final confirmed = await showConfirmActionDialog(
                      context: context,
                      title: 'Delete selected order?',
                      message: 'This order will be removed permanently.',
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
        ],
      ),
    );
  }
}
