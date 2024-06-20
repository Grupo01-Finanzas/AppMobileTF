import 'api_service.dart';
import '../models/credit_request.dart';

class CreditRequestService {
  final ApiService _apiService;

  CreditRequestService(this._apiService);

  Future<void> createCreditRequest(
    int clientId,
    int establishmentId,
    double requestedCreditLimit,
    int monthlyDueDate,
    String interestType,
    String creditType,
    int gracePeriod,
  ) async {
    await _apiService.createCreditRequest(clientId, establishmentId,
        requestedCreditLimit, monthlyDueDate, interestType, creditType, gracePeriod);
  }

  Future<CreditRequest> getCreditRequestById(int id) async {
    return await _apiService.getCreditRequestById(id);
  }

  Future<void> approveCreditRequest(int id) async {
    await _apiService.approveCreditRequest(id);
  }

  Future<void> rejectCreditRequest(int id) async {
    await _apiService.rejectCreditRequest(id);
  }

  Future<List<CreditRequest>> getPendingCreditRequestsByEstablishmentId(
      int establishmentId) async {
    return await _apiService.getPendingCreditRequestsByEstablishmentId(
        establishmentId);
  }

  Future<List<CreditRequest>> getCreditRequestsByClientId(int clientId) async {
    return await _apiService.getCreditRequestsByClientId(clientId);
  }

  Future<void> updateCreditRequestDueDate(int id, DateTime newDueDate) async {
    await _apiService.updateCreditRequestDueDate(id, newDueDate);
  }

  Future<List<CreditRequest>> getCreditRequestsByEstablishmentId(int establishmentId) {
    return _apiService.getCreditRequestsByEstablishmentId(establishmentId);
  }


}