import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/features/service_management/domain/usecases/get_services_usecase.dart';
import 'package:sra_hotel/features/service_management/domain/usecases/create_service_usecase.dart';
import 'package:sra_hotel/features/service_management/domain/usecases/update_service_usecase.dart';
import 'package:sra_hotel/features/service_management/domain/usecases/delete_service_usecase.dart';
import 'service_event.dart';
import 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final GetServicesUseCase getServicesUseCase;
  final CreateServiceUseCase createServiceUseCase;
  final UpdateServiceUseCase updateServiceUseCase;
  final DeleteServiceUseCase deleteServiceUseCase;

  ServiceBloc({
    required this.getServicesUseCase,
    required this.createServiceUseCase,
    required this.updateServiceUseCase,
    required this.deleteServiceUseCase,
  }) : super(ServiceInitial()) {
    on<LoadServicesEvent>(_onLoadServices);
    on<CreateServiceEvent>(_onCreateService);
    on<UpdateServiceEvent>(_onUpdateService);
    on<DeleteServiceEvent>(_onDeleteService);
  }

  Future<void> _onLoadServices(LoadServicesEvent event, Emitter<ServiceState> emit) async {
    emit(ServiceLoading());
    try {
      final list = await getServicesUseCase();
      emit(ServiceLoaded(list));
    } catch (e) {
      emit(ServiceFailure(e.toString()));
    }
  }

  Future<void> _onCreateService(CreateServiceEvent event, Emitter<ServiceState> emit) async {
    try {
      await createServiceUseCase(event.service);
      add(LoadServicesEvent());
    } catch (e) {
      emit(ServiceFailure(e.toString()));
    }
  }

  Future<void> _onUpdateService(UpdateServiceEvent event, Emitter<ServiceState> emit) async {
    try {
      await updateServiceUseCase(event.service);
      add(LoadServicesEvent());
    } catch (e) {
      emit(ServiceFailure(e.toString()));
    }
  }

  Future<void> _onDeleteService(DeleteServiceEvent event, Emitter<ServiceState> emit) async {
    try {
      await deleteServiceUseCase(event.id);
      add(LoadServicesEvent());
    } catch (e) {
      emit(ServiceFailure(e.toString()));
    }
  }
}
