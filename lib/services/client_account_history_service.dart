import 'api_service.dart';
import '../models/account_statement_response.dart';

class ClientAccountHistoryService {
  final ApiService _apiService;

  ClientAccountHistoryService(this._apiService);

  Future<AccountStatementResponse> getClientAccountHistory(int clientId) async {
    return await _apiService.getClientAccountHistory(clientId);
  }
}