import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tf/models/establishment.dart';
import 'package:tf/models/product.dart';
import 'package:tf/presentation/pages/CreditRequest/credit_request_selection_screen.dart';
import 'package:tf/services/establishment_service.dart';


class EstablishmentDetailsScreen extends StatefulWidget {
  final int establishmentId;

  const EstablishmentDetailsScreen({super.key, required this.establishmentId});

  @override
  State<EstablishmentDetailsScreen> createState() =>
      _EstablishmentDetailsScreenState();
}

class _EstablishmentDetailsScreenState
    extends State<EstablishmentDetailsScreen> {
  late Future<Establishment> _establishmentFuture;
  final Map<int, int> _cartItems = {}; 

  @override
  void initState() {
    super.initState();
    _loadEstablishment();
  }

  Future<void> _loadEstablishment() async {
    final establishmentService = context.read<EstablishmentService>();
    _establishmentFuture =
        establishmentService.getEstablishmentById(widget.establishmentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Establecimiento'),
        actions: [
          _buildCartIcon(),
        ],
      ),
      body: FutureBuilder<Establishment>(
        future: _establishmentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final establishment = snapshot.data!;
            return _buildProductList(establishment.products);
          } else {
            return const Center(child: Text('No establishment found'));
          }
        },
      ),
    );
  }

  Widget _buildProductList(List<Product> products) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductTile(product);
      },
    );
  }

  Widget _buildProductTile(Product product) {
    return ListTile(
      title: Text(product.name),
      subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _cartItems.update(product.id, (value) => value + 1,
                    ifAbsent: () => 1);
              });
            },
            icon: const Icon(Icons.add),
          ),
          Text(_cartItems[product.id]?.toString() ?? '0'),
          IconButton(
            onPressed: () {
              setState(() {
                if (_cartItems.containsKey(product.id)) {
                  if (_cartItems[product.id]! > 1) {
                    _cartItems[product.id] = _cartItems[product.id]! - 1;
                  } else {
                    _cartItems.remove(product.id);
                  }
                }
              });
            },
            icon: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }

  Widget _buildCartIcon() {
    return Stack(
      children: [
        IconButton(
          onPressed: () => _navigateToCartScreen(),
          icon: const Icon(Icons.shopping_cart),
        ),
        if (_cartItems.isNotEmpty)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: const BoxConstraints(
                minWidth: 12,
                minHeight: 12,
              ),
              child: Text(
                _cartItems.values.reduce((a, b) => a + b).toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
      ],
    );
  }

  void _navigateToCartScreen() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CartScreen(cartItems: _cartItems),
    ));
  }
}

// Pantalla del carrito
class CartScreen extends StatelessWidget {
  final Map<int, int> cartItems;

  const CartScreen({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Scaffold(
      appBar: AppBar(title: const Text('Carrito de Compras')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1),
                  },
                  border: TableBorder.all(color: Colors.grey),
                  children: _buildCartItems(context, currencyFormat),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Total: ${currencyFormat.format(_calculateTotalPrice(context))}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Navegar a la vista de solicitud de crédito
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CreditRequestSelectionScreen(cartItems: cartItems), // Pasa los items del carrito a la siguiente pantalla
                ));
              },
              child: const Text('Solicitar Crédito'),
            ),
          ],
        ),
      ),
    );
  }

  List<TableRow> _buildCartItems(BuildContext context, NumberFormat currencyFormat) {
    final establishmentService = context.read<EstablishmentService>();
    return cartItems.entries.map((entry) {
      final productId = entry.key;
      final quantity = entry.value;
      return TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<Product>(
              future: establishmentService.getProductById(productId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Cargando...');
                } else if (snapshot.hasError) {
                  return const Text('Error al cargar el producto');
                } else if (snapshot.hasData) {
                  final product = snapshot.data!;
                  return Text(product.name);
                } else {
                  return const Text('Producto no encontrado');
                }
              },
            ),
          ),
          Center(child: Text(quantity.toString())),
          Center(
            child: FutureBuilder<Product>(
              future: establishmentService.getProductById(productId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Cargando...');
                } else if (snapshot.hasError) {
                  return const Text('Error al cargar el producto');
                } else if (snapshot.hasData) {
                  final product = snapshot.data!;
                  final total = product.price * quantity;
                  return Text(currencyFormat.format(total));
                } else {
                  return const Text('Producto no encontrado');
                }
              },
            ),
          ),
        ],
      );
    }).toList();
  }

  double _calculateTotalPrice(BuildContext context) {
    final establishmentService = context.read<EstablishmentService>();
    double totalPrice = 0;
    for (var entry in cartItems.entries) {
      final productId = entry.key;
      final quantity = entry.value;
      establishmentService.getProductById(productId).then((product) {
        totalPrice += product.price * quantity;
      });
    }
    return totalPrice;
  }
}