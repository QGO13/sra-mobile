import 'package:sra_hotel/features/service_management/domain/entities/hotel_service.dart';

abstract class ServiceState {}

class ServiceInitial extends ServiceState {}

class ServiceLoading extends ServiceState {}

class ServiceLoaded extends ServiceState {
  final List<HotelService> services;
  ServiceLoaded(this.services);
}

class ServiceFailure extends ServiceState {
  final String error;
  ServiceFailure(this.error);
}
