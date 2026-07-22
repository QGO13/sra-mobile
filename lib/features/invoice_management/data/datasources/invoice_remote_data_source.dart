import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:sra_hotel/core/network/api_client.dart';
import 'package:sra_hotel/core/network/api_cache.dart';
import 'package:sra_hotel/features/invoice_management/data/models/client_invoice_model.dart';

abstract class InvoiceRemoteDataSource {
  Future<List<ClientInvoiceModel>> getInvoices();
}

class InvoiceRemoteDataSourceImpl implements InvoiceRemoteDataSource {
  final ApiClient apiClient;
  final ApiCache apiCache;

  InvoiceRemoteDataSourceImpl({required this.apiClient, required this.apiCache});

  @override
  Future<List<ClientInvoiceModel>> getInvoices() async {
    try {
      final response = await _fetchInvoicesData();
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final body = response.data as Map<String, dynamic>;
        final data = body['data'] as List<dynamic>? ?? const [];
        return data.map((json) => ClientInvoiceModel.fromJson(json as Map<String, dynamic>)).toList();
      }
    } catch (_) {
      // Ignorer silencieusement et renvoyer une liste vide
    }
    return const <ClientInvoiceModel>[];
  }

  Future<dynamic> _fetchInvoicesData() async {
    try {
      final response = await apiClient.get('/reservation/', queryParameters: {'limit': 100});
      await apiCache.save('invoices_admin', jsonEncode(response.data));
      return response;
    } catch (_) {
      try {
        final response = await apiClient.get('/me/reservations', queryParameters: {'limit': 100});
        await apiCache.save('invoices_me', jsonEncode(response.data));
        return response;
      } catch (e) {
        final adminCached = await apiCache.get('invoices_admin');
        if (adminCached != null) {
          return Response(requestOptions: RequestOptions(), data: jsonDecode(adminCached), statusCode: 200);
        }
        final meCached = await apiCache.get('invoices_me');
        if (meCached != null) {
          return Response(requestOptions: RequestOptions(), data: jsonDecode(meCached), statusCode: 200);
        }
        rethrow;
      }
    }
  }
}
