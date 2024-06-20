import 'api_service.dart';
import '../models/client.dart';

class ClientService {
  final ApiService _apiService;

  ClientService(this._apiService);

  Future<List<Client>> getAllClients() async {
    return await _apiService.getAllClients();
  }

  Future<Client> getClientById(int id) async {
    return await _apiService.getClientById(id);
  }

  Future<void> updateClient(int id, bool isActive) async {
    await _apiService.updateClient(id, isActive);
  }

  Future<void> deleteClient(int id) async {
    await _apiService.deleteClient(id);
  }

  Future<List<Client>> getClientsByEstablishmentId(int establishmentId) async {
    return await _apiService.getClientsByEstablishmentId(establishmentId);
  }
}