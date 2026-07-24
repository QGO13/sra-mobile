import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:sra_hotel/core/network/api_client.dart';
import 'package:sra_hotel/core/network/api_cache.dart';
import 'package:sra_hotel/features/service_management/data/models/hotel_service_model.dart';

abstract class ServiceRemoteDataSource {
  Future<List<HotelServiceModel>> getServices();
  Future<HotelServiceModel> createService(HotelServiceModel service);
  Future<HotelServiceModel> updateService(HotelServiceModel service);
  Future<void> deleteService(int id);
}

class ServiceRemoteDataSourceImpl implements ServiceRemoteDataSource {
  final ApiClient apiClient;
  final ApiCache apiCache;

  ServiceRemoteDataSourceImpl({required this.apiClient, required this.apiCache});

  @override
  Future<List<HotelServiceModel>> getServices() async {
    try {
      final response = await apiClient.get('/services/');
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        await apiCache.save('services', jsonEncode(response.data));
        final body = response.data as Map<String, dynamic>;
        final data = body['data'] as List<dynamic>? ?? const [];
        return data.map((json) => HotelServiceModel.fromJson(json as Map<String, dynamic>)).toList();
      }
      return const <HotelServiceModel>[];
    } catch (e) {
      final cachedStr = await apiCache.get('services');
      if (cachedStr != null) {
        final decoded = jsonDecode(cachedStr) as Map<String, dynamic>;
        final data = decoded['data'] as List<dynamic>? ?? const [];
        return data.map((json) => HotelServiceModel.fromJson(json as Map<String, dynamic>)).toList();
      }
      if (e is DioException && e.response?.statusCode == 404) {
        return const <HotelServiceModel>[];
      }
      rethrow;
    }
  }

  @override
  Future<HotelServiceModel> createService(HotelServiceModel service) async {
    final response = await apiClient.post('/services/', data: service.toJson());
    return HotelServiceModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<HotelServiceModel> updateService(HotelServiceModel service) async {
    final response = await apiClient.put('/services/${service.id}', data: service.toJson());
    return HotelServiceModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteService(int id) async {
    await apiClient.delete('/services/$id');
  }
}
