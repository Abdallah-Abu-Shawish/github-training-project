import 'package:flutter/material.dart';
import 'package:orders_manager/views/widgets/app_card.dart';
import 'package:orders_manager/views/widgets/custom_text_field.dart';
import 'package:orders_manager/views/widgets/empty_state_widget.dart';
import 'package:orders_manager/views/widgets/order_form_dialog.dart';
import 'package:orders_manager/views/widgets/order_list_card.dart';
import 'package:orders_manager/views/widgets/primary_button.dart';
import 'package:orders_manager/views/widgets/section_header.dart';
import '../controllers/order_controller.dart';
import '../models/order_model.dart';

class ListScreen extends StatelessWidget {
  final OrderController controller;
  final TextEditingController productController;
  final TextEditingController quantityController;
  final Future<void> Function() onAdd;

  const ListScreen({
    super.key,
    required this.controller,
    required this.productController,
    required this.quantityController,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final listItems = controller.listItems(controller.orders);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Product Name',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: productController,
                  hintText: 'Enter product name',
                ),
                const SizedBox(height: 16),
                const Text(
                  'Quantity',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
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
          SectionHeader(
            title: 'Registered Orders (${listItems.length})',
            trailing: listItems.isNotEmpty
                ? SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () async {
                        await controller.clearAllOrders();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Clear All'),
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 18),
          if (listItems.isEmpty)
            const EmptyStateWidget(
              icon: Icons.inventory_2_outlined,
              title: 'No orders yet',
              message: 'Add your first product order using the form above.',
            )
          else
            ...listItems.asMap().entries.map((entry) {
              final index = entry.key;
              final order = entry.value;

              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: OrderListCard(
                  order: order,
                  displayIndex: index + 1,
                  onToggle: (value) async {
                    await controller.toggleSelected(order, value);
                  },
                  onEdit: () async {
                    await _showEditDialog(context, order);
                  },
                  onDelete: () async {
                    await controller.deleteOrder(order.id!);
                  },
                ),
              );
            }),
        ],
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context, OrderModel order) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return OrderFormDialog(
          title: 'Edit Order',
          subtitle: 'Update the product name and quantity',
          productName: order.productName,
          quantity: order.quantity,
          onSubmit: (productName, quantity) {
            return controller.updateOrderFromInput(
              order: order,
              productName: productName,
              quantity: quantity,
            );
          },
        );
      },
    );
  }
}
