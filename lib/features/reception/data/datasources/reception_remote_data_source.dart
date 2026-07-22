import 'package:sra_hotel/core/network/api_client.dart';
import 'package:sra_hotel/features/reception/data/models/arrival_departure_model.dart';
import 'package:sra_hotel/features/room_management/data/models/room_model.dart';

abstract class ReceptionRemoteDataSource {
  Future<List<ArrivalDepartureModel>> getArrivals();
  Future<List<ArrivalDepartureModel>> getDepartures();
  Future<void> performCheckIn(String ref, String roomNo);
  Future<void> performCheckOut(String ref);
  Future<List<RoomModel>> getRooms();
}

class ReceptionRemoteDataSourceImpl implements ReceptionRemoteDataSource {
  final ApiClient apiClient;

  ReceptionRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ArrivalDepartureModel>> getArrivals() async {
    final response = await apiClient.get('/backoffice/arrivals');
    return (response.data as List)
        .map((json) => ArrivalDepartureModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ArrivalDepartureModel>> getDepartures() async {
    final response = await apiClient.get('/backoffice/departures');
    return (response.data as List)
        .map((json) => ArrivalDepartureModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> performCheckIn(String ref, String roomNo) async {
    await apiClient.post('/backoffice/checkin', data: {
      'reference': ref,
      'chambre_numero': roomNo,
    });
  }

  @override
  Future<void> performCheckOut(String ref) async {
    await apiClient.post('/backoffice/checkout', data: {
      'reference': ref,
    });
  }

  @override
  Future<List<RoomModel>> getRooms() async {
    final response = await apiClient.get('/backoffice/rooms');
    return (response.data as List)
        .map((json) => RoomModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
