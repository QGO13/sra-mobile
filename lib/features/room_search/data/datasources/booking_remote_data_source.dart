import 'package:sra_hotel/core/network/api_client.dart';
import 'package:sra_hotel/features/room_search/data/models/room_model.dart';

abstract class BookingRemoteDataSource {
  Future<List<RoomModel>> getAvailableRooms({
    required String checkIn,
    required String checkOut,
    String? categoryId,
  });

  Future<bool> verifyRoomAvailability({
    required String roomId,
    required String checkIn,
    required String checkOut,
  });
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final ApiClient apiClient;

  BookingRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<RoomModel>> getAvailableRooms({
    required String checkIn,
    required String checkOut,
    String? categoryId,
  }) async {
    final queryParameters = {
      'check_in': checkIn,
      'check_out': checkOut,
      'limit': 100, // Demander une page large pour l'UI mobile
    };
    if (categoryId != null) {
      queryParameters['room_type_id'] = categoryId;
    }

    final response = await apiClient.get(
      '/rooms/available',
      queryParameters: queryParameters,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = response.data as Map<String, dynamic>;
      final List<dynamic> data = body['data'] as List<dynamic>;
      return data.map((json) => RoomModel.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Server Error: ${response.statusMessage}');
    }
  }

  @override
  Future<bool> verifyRoomAvailability({
    required String roomId,
    required String checkIn,
    required String checkOut,
  }) async {
    // Le backend réel n'exposant pas /rooms/verify-availability, 
    // on vérifie si la chambre fait partie des chambres disponibles retournées
    try {
      final availableRooms = await getAvailableRooms(
        checkIn: checkIn,
        checkOut: checkOut,
      );
      return availableRooms.any((room) => room.id == roomId);
    } catch (_) {
      return false;
    }
  }
}

