import 'package:sra_hotel/core/network/api_client.dart';
import 'package:sra_hotel/features/client_booking/data/models/booking_room_type_model.dart';
import 'package:sra_hotel/features/client_booking/data/models/booking_room_model.dart';

abstract class ClientBookingRemoteDataSource {
  Future<List<BookingRoomTypeModel>> getRoomTypes();
  Future<List<BookingRoomModel>> getAvailableRooms({
    required String checkIn,
    required String checkOut,
  });
}

class ClientBookingRemoteDataSourceImpl implements ClientBookingRemoteDataSource {
  final ApiClient apiClient;

  ClientBookingRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<BookingRoomTypeModel>> getRoomTypes() async {
    final response = await apiClient.get('/room-types/');
    if (response.statusCode == 200) {
      final Map<String, dynamic> body = response.data as Map<String, dynamic>;
      final List<dynamic> data = body['data'] as List<dynamic>;
      return data.map((json) => BookingRoomTypeModel.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Server Error: ${response.statusMessage}');
    }
  }

  @override
  Future<List<BookingRoomModel>> getAvailableRooms({
    required String checkIn,
    required String checkOut,
  }) async {
    final response = await apiClient.get(
      '/rooms/available',
      queryParameters: {
        'check_in': checkIn,
        'check_out': checkOut,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = response.data as Map<String, dynamic>;
      final List<dynamic> data = body['data'] as List<dynamic>;
      return data.map((json) => BookingRoomModel.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Server Error: ${response.statusMessage}');
    }
  }
}
