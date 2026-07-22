import 'package:sra_hotel/features/reception/domain/entities/arrival_departure.dart';
import 'package:sra_hotel/features/room_management/domain/entities/room.dart';

abstract class ReceptionState {}

class ReceptionInitial extends ReceptionState {}

class ReceptionLoading extends ReceptionState {}

class ReceptionLoaded extends ReceptionState {
  final List<ArrivalDeparture> arrivals;
  final List<ArrivalDeparture> departures;
  final List<Room> rooms;

  ReceptionLoaded({
    required this.arrivals,
    required this.departures,
    required this.rooms,
  });
}

class ReceptionFailure extends ReceptionState {
  final String error;
  ReceptionFailure(this.error);
}
