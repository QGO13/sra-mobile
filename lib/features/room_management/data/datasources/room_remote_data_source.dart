import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sra_hotel/core/network/api_client.dart';
import 'package:sra_hotel/core/network/api_cache.dart';
import 'package:sra_hotel/features/room_management/data/models/room_model.dart';
import 'package:sra_hotel/features/room_management/data/models/room_type_model.dart';

abstract class RoomRemoteDataSource {
  Future<List<RoomModel>> getRooms();
  Future<RoomModel> createRoom(RoomModel room);
  Future<RoomModel> updateRoom(RoomModel room);
  Future<void> deleteRoom(String id);

  Future<List<RoomTypeModel>> getRoomTypes();
  Future<RoomTypeModel> createRoomType(RoomTypeModel type, {XFile? imageFile});
  Future<RoomTypeModel> updateRoomType(RoomTypeModel type, {XFile? imageFile});
  Future<void> deleteRoomType(String id);
}

class RoomRemoteDataSourceImpl implements RoomRemoteDataSource {
  final ApiClient apiClient;
  final ApiCache apiCache;

  RoomRemoteDataSourceImpl({required this.apiClient, required this.apiCache});

  @override
  Future<List<RoomModel>> getRooms() async {
    try {
      final response = await apiClient.get('/rooms/', queryParameters: {'limit': 100});
      if (response.statusCode == 200) {
        await apiCache.save('rooms', jsonEncode(response.data));
        final Map<String, dynamic> body = response.data as Map<String, dynamic>;
        final List<dynamic> data = body['data'] as List<dynamic>;
        return data.map((json) => RoomModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Server Error: ${response.statusMessage}');
      }
    } catch (e) {
      final cachedStr = await apiCache.get('rooms');
      if (cachedStr != null) {
        final decoded = jsonDecode(cachedStr) as Map<String, dynamic>;
        final List<dynamic> data = decoded['data'] as List<dynamic>;
        return data.map((json) => RoomModel.fromJson(json as Map<String, dynamic>)).toList();
      }
      rethrow;
    }
  }

  @override
  Future<RoomModel> createRoom(RoomModel room) async {
    final response = await apiClient.post('/rooms/', data: room.toJson());
    return RoomModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<RoomModel> updateRoom(RoomModel room) async {
    // Le backend attend un PATCH sur /rooms/{id}
    final response = await apiClient.dio.patch(
      '/rooms/${room.id}',
      data: room.toJson(),
    );
    return RoomModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteRoom(String id) async {
    await apiClient.delete('/rooms/$id');
  }

  @override
  Future<List<RoomTypeModel>> getRoomTypes() async {
    try {
      final response = await apiClient.get('/room-types/', queryParameters: {'limit': 100});
      if (response.statusCode == 200) {
        await apiCache.save('room_types', jsonEncode(response.data));
        final Map<String, dynamic> body = response.data as Map<String, dynamic>;
        final List<dynamic> data = body['data'] as List<dynamic>;
        return data.map((json) => RoomTypeModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Server Error: ${response.statusMessage}');
      }
    } catch (e) {
      final cachedStr = await apiCache.get('room_types');
      if (cachedStr != null) {
        final decoded = jsonDecode(cachedStr) as Map<String, dynamic>;
        final List<dynamic> data = decoded['data'] as List<dynamic>;
        return data.map((json) => RoomTypeModel.fromJson(json as Map<String, dynamic>)).toList();
      }
      rethrow;
    }
  }

  @override
  Future<RoomTypeModel> createRoomType(RoomTypeModel type, {XFile? imageFile}) async {
    final Map<String, dynamic> map = {
      'nom': type.nom,
      'prix_nuit': type.prixNuit,
      'capacite': type.capacite,
      'description': type.description,
    };
    if (imageFile != null) {
      if (kIsWeb) {
        final bytes = await imageFile.readAsBytes();
        map['file'] = MultipartFile.fromBytes(bytes, filename: imageFile.name);
      } else {
        map['file'] = await MultipartFile.fromFile(imageFile.path, filename: imageFile.name);
      }
    }
    final response = await apiClient.post(
      '/room-types/',
      data: imageFile != null ? FormData.fromMap(map) : type.toJson(),
    );
    return RoomTypeModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<RoomTypeModel> updateRoomType(RoomTypeModel type, {XFile? imageFile}) async {
    final Map<String, dynamic> map = {
      'nom': type.nom,
      'prix_nuit': type.prixNuit,
      'capacite': type.capacite,
      'description': type.description,
    };
    if (imageFile != null) {
      if (kIsWeb) {
        final bytes = await imageFile.readAsBytes();
        map['file'] = MultipartFile.fromBytes(bytes, filename: imageFile.name);
      } else {
        map['file'] = await MultipartFile.fromFile(imageFile.path, filename: imageFile.name);
      }
    }
    final response = await apiClient.dio.patch(
      '/room-types/${type.id}',
      data: imageFile != null ? FormData.fromMap(map) : type.toJson(),
    );
    return RoomTypeModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteRoomType(String id) async {
    await apiClient.delete('/room-types/$id');
  }
}
