import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orders_manager/views/complete_screen.dart';
import 'package:orders_manager/views/selected_screen.dart';
import '../controllers/order_controller.dart';
import 'list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final OrderController controller = Get.put(OrderController());
  final TextEditingController productController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    controller.loadOrders();
  }

  Future<void> addOrder() async {
    final name = productController.text.trim();
    final qty = int.tryParse(quantityController.text.trim()) ?? 0;

    if (name.isEmpty || qty <= 0) return;

    await controller.addOrder(name, qty);
    productController.clear();
    quantityController.clear();
  }

  void showCompleteMessage(int count) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.white,
        content: Text(
          '$count item(s) marked as complete!',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<OrderController>();
    productController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Orders Manager',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(
        () {
          final pages = [
            ListScreen(
              controller: controller,
              productController: productController,
              quantityController: quantityController,
              onAdd: addOrder,
            ),
            SelectedScreen(
              controller: controller,
              onCompleted: showCompleteMessage,
            ),
            CompleteScreen(controller: controller),
          ];

          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return pages[currentIndex];
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color(0xFFA6AEC1),
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted_rounded),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box_outlined),
            label: 'Selected',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'Complete',
          ),
        ],
      ),
    );
  }
}
