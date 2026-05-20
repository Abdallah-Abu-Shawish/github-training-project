import 'package:flutter/material.dart';
import 'package:orders_manager/views/complete_screen.dart';
import 'package:orders_manager/views/selected_screen.dart';
import '../controllers/order_controller.dart';
import '../models/order_model.dart';
import 'list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final OrderController controller = OrderController();
  final TextEditingController productController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  int currentIndex = 0;
  List<OrderModel> allOrders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    setState(() => isLoading = true);
    allOrders = await controller.getAllOrders();
    setState(() => isLoading = false);
  }

  Future<void> addOrder() async {
    final name = productController.text.trim();
    final qty = int.tryParse(quantityController.text.trim()) ?? 0;

    if (name.isEmpty || qty <= 0) return;

    await controller.addOrder(name, qty);
    productController.clear();
    quantityController.clear();
    await loadOrders();
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
    productController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      ListScreen(
        controller: controller,
        allOrders: allOrders,
        productController: productController,
        quantityController: quantityController,
        onAdd: addOrder,
        onRefresh: loadOrders,
      ),
      SelectedScreen(
        controller: controller,
        allOrders: allOrders,
        onRefresh: loadOrders,
        onCompleted: showCompleteMessage,
      ),
      CompleteScreen(
        controller: controller,
        allOrders: allOrders,
        onRefresh: loadOrders,
      ),
    ];

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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pages[currentIndex],
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