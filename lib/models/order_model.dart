class OrderModel {
  final int? id;
  final String productName;
  final int quantity;
  final bool isSelected;
  final bool isCompleted;
  final String createdAt;
  final String updatedAt;
  final String? completedAt;

  OrderModel({
    this.id,
    required this.productName,
    required this.quantity,
    required this.isSelected,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_name': productName,
      'quantity': quantity,
      'is_selected': isSelected ? 1 : 0,
      'is_completed': isCompleted ? 1 : 0,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'completed_at': completedAt,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'],
      productName: map['product_name'],
      quantity: map['quantity'],
      isSelected: map['is_selected'] == 1,
      isCompleted: map['is_completed'] == 1,
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
      completedAt: map['completed_at'],
    );
  }

  OrderModel copyWith({
    int? id,
    String? productName,
    int? quantity,
    bool? isSelected,
    bool? isCompleted,
    String? createdAt,
    String? updatedAt,
    String? completedAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      isSelected: isSelected ?? this.isSelected,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}