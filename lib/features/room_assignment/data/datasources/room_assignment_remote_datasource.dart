import 'dart:convert';
import 'package:sra_hotel/core/network/api_client.dart';
import 'package:sra_hotel/core/network/api_cache.dart';
import 'package:sra_hotel/features/reservation_management/data/models/booking_model.dart';
import 'package:sra_hotel/features/room_management/data/models/room_model.dart';

abstract class RoomAssignmentRemoteDataSource {
  Future<List<BookingModel>> getBookings();
  Future<List<RoomModel>> getRooms();
  Future<BookingModel> updateBooking(BookingModel booking);
}

class RoomAssignmentRemoteDataSourceImpl implements RoomAssignmentRemoteDataSource {
  final ApiClient apiClient;
  final ApiCache apiCache;

  RoomAssignmentRemoteDataSourceImpl({required this.apiClient, required this.apiCache});

  @override
  Future<List<BookingModel>> getBookings() async {
    try {
      final response = await apiClient.get('/reservation/', queryParameters: {'limit': 100});
      if (response.statusCode == 200) {
        await apiCache.save('room_assignment_bookings', jsonEncode(response.data));
        final List<dynamic> data;
        if (response.data is List) {
          data = response.data as List;
        } else if (response.data is Map) {
          data = (response.data as Map<String, dynamic>)['data'] as List;
        } else {
          throw Exception('Format de données de réservation invalide');
        }
        return data.map((json) => BookingModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Server Error: ${response.statusMessage}');
      }
    } catch (e) {
      final cachedStr = await apiCache.get('room_assignment_bookings');
      if (cachedStr != null) {
        final decoded = jsonDecode(cachedStr);
        final List<dynamic> data;
        if (decoded is List) {
          data = decoded;
        } else if (decoded is Map) {
          data = decoded['data'] as List;
        } else {
          throw Exception('Format de données de réservation invalide');
        }
        return data.map((json) => BookingModel.fromJson(json as Map<String, dynamic>)).toList();
      }
      rethrow;
    }
  }

  @override
  Future<List<RoomModel>> getRooms() async {
    try {
      final response = await apiClient.get('/rooms/', queryParameters: {'limit': 100});
      if (response.statusCode == 200) {
        await apiCache.save('room_assignment_rooms', jsonEncode(response.data));
        final List<dynamic> data;
        if (response.data is List) {
          data = response.data as List;
        } else if (response.data is Map) {
          data = (response.data as Map<String, dynamic>)['data'] as List;
        } else {
          throw Exception('Format de données de chambre invalide');
        }
        return data.map((json) => RoomModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Server Error: ${response.statusMessage}');
      }
    } catch (e) {
      final cachedStr = await apiCache.get('room_assignment_rooms');
      if (cachedStr != null) {
        final decoded = jsonDecode(cachedStr);
        final List<dynamic> data;
        if (decoded is List) {
          data = decoded;
        } else if (decoded is Map) {
          data = decoded['data'] as List;
        } else {
          throw Exception('Format de données de chambre invalide');
        }
        return data.map((json) => RoomModel.fromJson(json as Map<String, dynamic>)).toList();
      }
      rethrow;
    }
  }

  @override
  Future<BookingModel> updateBooking(BookingModel booking) async {
    // Construct a minimal and strict payload for the FastAPI update schema
    final payload = {
      'status': BookingModel.denormalizeStatus(booking.statutBooking),
      'reservation_lines': booking.lines.map((l) => {
        'id': l.id,
        'room_id': l.chambreId,
        'check_in': l.checkIn,
        'check_out': l.checkOut,
        'occupant_name': l.occupantName,
      }).toList(),
    };

    final response = await apiClient.dio.patch(
      '/reservation/${booking.id}',
      data: payload,
    );
    if (response.statusCode == 200) {
      return BookingModel.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw Exception('Server Error: ${response.statusMessage}');
    }
  }
}
