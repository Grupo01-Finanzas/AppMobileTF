import 'package:tf/models/product.dart';

import 'api_service.dart';
import '../models/establishment.dart';

class EstablishmentService {
  final ApiService _apiService;

  EstablishmentService(this._apiService);

  Future<List<Establishment>> getAllEstablishments() async {
    return await _apiService.getAllEstablishments();
  }

  Future<Establishment> getEstablishmentById(int id) async {
    return await _apiService.getEstablishmentById(id);
  }

  Future<void> updateEstablishment(
    int id,
    String ruc,
    String name,
    String phone,
    String address,
    bool isActive,
  ) async {
    await _apiService.updateEstablishment(
        id, ruc, name, phone, address, isActive);
  }

  Future<void> deleteEstablishment(int id) async {
    await _apiService.deleteEstablishment(id);
  }

  Future<void> registerProducts(int establishmentId, List<int> productIds) async {
    await _apiService.registerProducts(establishmentId, productIds);
  }

  Future<void> addClientToEstablishment(int establishmentId, int clientId) async {
    await _apiService.addClientToEstablishment(establishmentId, clientId);
  }

  Future<Product> getProductById(int productId) async {
    return await _apiService.getProductById(productId);
  }
}