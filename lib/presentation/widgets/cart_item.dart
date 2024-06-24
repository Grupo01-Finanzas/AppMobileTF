// cart_item.dart
import 'package:tf/models/api/product.dart'; 

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}