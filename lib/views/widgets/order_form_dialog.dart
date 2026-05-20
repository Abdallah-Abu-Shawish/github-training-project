import 'package:flutter/material.dart';
import 'custom_text_field.dart';

class OrderFormDialog extends StatefulWidget {
  final String title;
  final String subtitle;
  final String productName;
  final int quantity;
  final Future<String?> Function(String productName, String quantity) onSubmit;

  const OrderFormDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.productName,
    required this.quantity,
    required this.onSubmit,
  });

  @override
  State<OrderFormDialog> createState() => _OrderFormDialogState();
}

class _OrderFormDialogState extends State<OrderFormDialog> {
  late final TextEditingController productController;
  late final TextEditingController quantityController;
  String? errorMessage;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    productController = TextEditingController(text: widget.productName);
    quantityController = TextEditingController(
      text: widget.quantity.toString(),
    );
  }

  @override
  void dispose() {
    productController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  Future<void> saveOrder() async {
    setState(() {
      errorMessage = null;
      isSaving = true;
    });

    final error = await widget.onSubmit(
      productController.text,
      quantityController.text,
    );

    if (!mounted) return;

    if (error != null) {
      setState(() {
        errorMessage = error;
        isSaving = false;
      });
      return;
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              widget.subtitle,
              style: const TextStyle(color: Color(0xFF8E8E9A), fontSize: 14),
            ),
            const SizedBox(height: 16),
            const Text(
              'Product Name',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: productController,
              hintText: 'Enter product name',
            ),
            const SizedBox(height: 14),
            const Text(
              'Quantity',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: quantityController,
              hintText: '1',
              keyboardType: TextInputType.number,
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                errorMessage!,
                style: const TextStyle(
                  color: Color(0xFFD92D20),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: isSaving ? null : saveOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(isSaving ? 'Saving...' : 'Update'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: isSaving ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
