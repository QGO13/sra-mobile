import 'package:sra_hotel/features/reception/domain/entities/arrival_departure.dart';
import 'package:sra_hotel/features/room_management/domain/entities/room.dart';

abstract class ReceptionRepository {
  Future<List<ArrivalDeparture>> getArrivals();
  Future<List<ArrivalDeparture>> getDepartures();
  Future<void> performCheckIn(String ref, String roomNo);
  Future<void> performCheckOut(String ref);
  Future<List<Room>> getRooms();
}
