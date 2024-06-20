import 'package:tf/models/admin.dart';
import 'package:tf/models/establishment.dart';

import 'api_service.dart';

class AdminService {
  final ApiService _apiService;

  AdminService(this._apiService);

  Future<List<Admin>> getAllAdmin() async {
    return await _apiService.getAllAdmins();
  }

  Future<Admin?> getAdmin(int id) async {
    return await _apiService.getAdminById(id);
  }

  Future<void> updateAdmin(int id, bool isActive) async {
    await _apiService.updateAdmin(id, isActive);
  }

  Future<void> deleteAdmin(int id) async {
    await _apiService.deleteAdmin(id);
  }

  Future<void> registerEstablishment(String ruc, String name, String phone,
      String address, String imageUrl) async {
    await _apiService.registerEstablishment(
        ruc, name, phone, address, imageUrl);
  }

  Future<List<Establishment>> getEstablishmentsByAdminId(int id) async {
    return await _apiService.getEstablishmentsByAdminId(id);
  }
}
