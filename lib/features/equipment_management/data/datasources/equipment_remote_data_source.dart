import 'dart:convert';
import 'package:sra_hotel/core/network/api_client.dart';
import 'package:sra_hotel/core/network/api_cache.dart';
import '../models/equipment_model.dart';

abstract class EquipmentRemoteDataSource {
  Future<List<EquipmentModel>> getEquipments();
  Future<EquipmentModel> createEquipment(EquipmentModel equipment);
  Future<EquipmentModel> updateEquipment(EquipmentModel equipment);
  Future<void> deleteEquipment(String id);
}

class EquipmentRemoteDataSourceImpl implements EquipmentRemoteDataSource {
  final ApiClient apiClient;
  final ApiCache apiCache;

  EquipmentRemoteDataSourceImpl({required this.apiClient, required this.apiCache});

  @override
  Future<List<EquipmentModel>> getEquipments() async {
    try {
      final response = await apiClient.get('/equipments/', queryParameters: {'limit': 100});
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        await apiCache.save('equipments', jsonEncode(response.data));
        final body = response.data as Map<String, dynamic>;
        final data = body['data'] as List<dynamic>? ?? const [];
        return data.map((json) => EquipmentModel.fromJson(json as Map<String, dynamic>)).toList();
      }
      return const <EquipmentModel>[];
    } catch (e) {
      final cachedStr = await apiCache.get('equipments');
      if (cachedStr != null) {
        final decoded = jsonDecode(cachedStr) as Map<String, dynamic>;
        final data = decoded['data'] as List<dynamic>? ?? const [];
        return data.map((json) => EquipmentModel.fromJson(json as Map<String, dynamic>)).toList();
      }
      rethrow;
    }
  }

  @override
  Future<EquipmentModel> createEquipment(EquipmentModel equipment) async {
    final response = await apiClient.post('/equipments/', data: {
      'name': equipment.name,
      'description': equipment.description,
      'status': equipment.status,
    });
    return EquipmentModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<EquipmentModel> updateEquipment(EquipmentModel equipment) async {
    final response = await apiClient.dio.patch('/equipments/${equipment.id}', data: {
      'name': equipment.name,
      'description': equipment.description,
      'status': equipment.status,
    });
    return EquipmentModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteEquipment(String id) async {
    await apiClient.delete('/equipments/$id');
  }
}
