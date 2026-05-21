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
    final error = await controller.addOrderFromInput(
      productName: productController.text,
      quantity: quantityController.text,
    );

    if (error != null) {
      showMessage(error, isError: true);
      return;
    }

    productController.clear();
    quantityController.clear();
  }

  void showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? const Color(0xFFFFF4F2) : Colors.white,
        content: Text(
          message,
          style: TextStyle(
            color: isError ? const Color(0xFFD92D20) : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  void showCompleteMessage(int count) {
    showMessage('$count item(s) marked as complete!');
  }

  Widget selectedNavIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2535),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(icon),
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
      body: Obx(() {
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

        if (controller.errorMessage.value != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Color(0xFFD92D20),
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    controller.errorMessage.value!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF5E6C84),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.loadOrders,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          );
        }

        return pages[currentIndex];
      }),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: const Color(0xFF8E97AA),
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedFontSize: 13,
          unselectedFontSize: 12,
          selectedIconTheme: const IconThemeData(size: 28),
          unselectedIconTheme: const IconThemeData(size: 24),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
          onTap: (index) {
            setState(() => currentIndex = index);
          },
          items: [
            BottomNavigationBarItem(
              icon: const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.format_list_bulleted_rounded),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: selectedNavIcon(Icons.format_list_bulleted_rounded),
              ),
              label: 'List',
            ),
            BottomNavigationBarItem(
              icon: const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.check_box_outlined),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: selectedNavIcon(Icons.check_box_outlined),
              ),
              label: 'Selected',
            ),
            BottomNavigationBarItem(
              icon: const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.check_circle_outline),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: selectedNavIcon(Icons.check_circle_outline),
              ),
              label: 'Complete',
            ),
          ],
        ),
      ),
    );
  }
}
