import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tf/cubits/purchase_cubit.dart';
import 'package:tf/enum/credit_type.dart';
import 'package:tf/models/api/product.dart';
import 'package:tf/presentation/widgets/cart_item.dart';
import 'package:tf/repository/purchase_repository.dart';
import 'package:tf/services/api/establishment_service.dart';
import 'package:tf/services/api/product_service.dart';

class ClientPurchaseScreen extends StatefulWidget {
  const ClientPurchaseScreen({super.key});

  @override
  State<ClientPurchaseScreen> createState() => _ClientPurchaseScreenState();
}

class _ClientPurchaseScreenState extends State<ClientPurchaseScreen> {
  List<Product> _products = [];
  List<CartItem> _cartItems = [];
  bool _isLoading = true;
  int? establishmentId;
  CreditType? creditType;
  @override
  void initState() {
    super.initState();
    _loadEstablishmentData();
  }

  Future<void> _loadEstablishmentData() async {
    final establishmentService = context.read<EstablishmentService>();
    final productService = context.read<ProductService>();

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    final accessToken = prefs.getString('accessToken');

    if (userId != null && accessToken != null) {
      try {
        final establishment = await establishmentService
            .getEstablishmentByAdminId(userId, accessToken);
        if (establishment != null) {
          establishmentId = establishment.id;
          final products = await productService.getProductsByEstablishmentId(
              establishmentId!, accessToken);
          setState(() {
            _products = products;
            _isLoading = false;
          });
        }
      } catch (e) {
        print('Error fetching establishment: $e');
      }
    }
  }

  void _addToCart(Product product) {
    setState(() {
      _cartItems.add(CartItem(product: product, quantity: 1));
    });
  }

  void _removeFromCart(Product product) {
    setState(() {
      _cartItems.removeWhere((item) => item.product.id == product.id);
    });
  }

  void _incrementQuantity(CartItem cartItem) {
    setState(() {
      cartItem.quantity++;
    });
  }

  void _decrementQuantity(CartItem cartItem) {
    if (cartItem.quantity > 1) {
      setState(() {
        cartItem.quantity--;
      });
    } else {
      _removeFromCart(cartItem.product);
    }
  }

  double _calculateTotal() {
    return _cartItems.fold(
        0, (sum, item) => sum + item.product.price * item.quantity);
  }

  Future<void> _checkout() async {
    final purchaseCubit = context.read<PurchaseCubit>();
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken != null) {
      try {
        // Make the purchase
        await purchaseCubit.createPurchase(
          accessToken: accessToken,
          establishmentID: establishmentId!,
          productIds: _cartItems.map((item) => item.product.id).toList(),
          creditType: creditType!.name,
          amount: _calculateTotal(),
        );

        // Clear the cart and show a success message
        setState(() {
          _cartItems = [];
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Compra realizada con éxito!')),
        );
      } catch (e) {
        print("Error making purchase: $e");
        // Handle error, maybe show a snackbar
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PurchaseCubit(purchaseRepository: context.read<PurchaseRepository>()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Productos del Establecimiento'),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        final product = _products[index];
                        return Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                product.imageUrl,
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'S/ ${product.price}',
                                style: const TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  _addToCart(product);
                                },
                                child: const Text('Agregar'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  if (_cartItems.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Shopping cart summary
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  const Text(
                                    'Carrito de Compras',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // List of cart items
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: _cartItems.length,
                                    itemBuilder: (context, index) {
                                      final cartItem = _cartItems[index];
                                      return ListTile(
                                        title: Text(cartItem.product.name),
                                        subtitle: Text(
                                            'S/ ${cartItem.product.price} x ${cartItem.quantity}'),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.remove),
                                              onPressed: () {
                                                _decrementQuantity(cartItem);
                                              },
                                            ),
                                            Text(cartItem.quantity.toString()),
                                            IconButton(
                                              icon: const Icon(Icons.add),
                                              onPressed: () {
                                                _incrementQuantity(cartItem);
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  // Total price
                                  Text(
                                    'Total: S/ ${_calculateTotal()}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Checkout button
                          ElevatedButton(
                            onPressed: _checkout,
                            child: const Text('Pagar'),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
