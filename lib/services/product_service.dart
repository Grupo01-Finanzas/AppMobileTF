import 'api_service.dart';
import '../models/product.dart';

class ProductService {
  final ApiService _apiService;

  ProductService(this._apiService);

  Future<List<Product>> getAllProducts() async {
    return await _apiService.getAllProducts();
  }

  Future<Product> getProductById(int id) async {
    return await _apiService.getProductById(id);
  }

  Future<List<Product>> getProductsByEstablishmentId(int establishmentId) async {
    return await _apiService.getProductsByEstablishmentId(establishmentId);
  }

  Future<void> createProduct(
    String name,
    String description,
    double price,
    String category,
    int stock,
    String imageUrl,
    bool isActive,
    int establishmentId,
  ) async {
    await _apiService.createProduct(
        name, description, price, category, stock, imageUrl, isActive, establishmentId);
  }

  Future<void> updateProduct(
    int id,
    String name,
    String description,
    double price,
    String category,
    int stock,
    bool isActive,
  ) async {
    await _apiService.updateProduct(
        id, name, description, price, category, stock, isActive);
  }

  Future<void> deleteProduct(int id) async {
    await _apiService.deleteProduct(id);
  }
}