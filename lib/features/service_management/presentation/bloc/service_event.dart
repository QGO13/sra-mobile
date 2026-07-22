import 'package:sra_hotel/features/service_management/domain/entities/hotel_service.dart';

abstract class ServiceEvent {}

class LoadServicesEvent extends ServiceEvent {}

class CreateServiceEvent extends ServiceEvent {
  final HotelService service;
  CreateServiceEvent(this.service);
}

class UpdateServiceEvent extends ServiceEvent {
  final HotelService service;
  UpdateServiceEvent(this.service);
}

class DeleteServiceEvent extends ServiceEvent {
  final int id;
  DeleteServiceEvent(this.id);
}
