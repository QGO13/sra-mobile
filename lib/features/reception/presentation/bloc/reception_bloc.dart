import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/features/reception/domain/entities/arrival_departure.dart';
import 'package:sra_hotel/features/room_management/domain/entities/room.dart';
import 'package:sra_hotel/features/reception/domain/usecases/get_arrivals_usecase.dart';
import 'package:sra_hotel/features/reception/domain/usecases/get_departures_usecase.dart';
import 'package:sra_hotel/features/reception/domain/usecases/perform_checkin_usecase.dart';
import 'package:sra_hotel/features/reception/domain/usecases/perform_checkout_usecase.dart';
import 'package:sra_hotel/features/reception/domain/usecases/get_reception_rooms_usecase.dart';
import 'reception_event.dart';
import 'reception_state.dart';

class ReceptionBloc extends Bloc<ReceptionEvent, ReceptionState> {
  final GetArrivalsUseCase getArrivalsUseCase;
  final GetDeparturesUseCase getDeparturesUseCase;
  final PerformCheckInUseCase performCheckInUseCase;
  final PerformCheckOutUseCase performCheckOutUseCase;
  final GetReceptionRoomsUseCase getReceptionRoomsUseCase;

  ReceptionBloc({
    required this.getArrivalsUseCase,
    required this.getDeparturesUseCase,
    required this.performCheckInUseCase,
    required this.performCheckOutUseCase,
    required this.getReceptionRoomsUseCase,
  }) : super(ReceptionInitial()) {
    on<LoadReceptionDashboardEvent>(_onLoadReceptionDashboard);
    on<PerformCheckInEvent>(_onPerformCheckIn);
    on<PerformCheckOutEvent>(_onPerformCheckOut);
  }

  Future<void> _onLoadReceptionDashboard(
    LoadReceptionDashboardEvent event,
    Emitter<ReceptionState> emit,
  ) async {
    emit(ReceptionLoading());
    try {
      final results = await Future.wait([
        getArrivalsUseCase(),
        getDeparturesUseCase(),
        getReceptionRoomsUseCase(),
      ]);

      emit(ReceptionLoaded(
        arrivals: results[0] as List<ArrivalDeparture>,
        departures: results[1] as List<ArrivalDeparture>,
        rooms: results[2] as List<Room>,
      ));
    } catch (e) {
      emit(ReceptionFailure(e.toString()));
    }
  }

  Future<void> _onPerformCheckIn(
    PerformCheckInEvent event,
    Emitter<ReceptionState> emit,
  ) async {
    try {
      await performCheckInUseCase(event.reference, event.roomNumber);
      add(LoadReceptionDashboardEvent());
    } catch (e) {
      emit(ReceptionFailure(e.toString()));
    }
  }

  Future<void> _onPerformCheckOut(
    PerformCheckOutEvent event,
    Emitter<ReceptionState> emit,
  ) async {
    try {
      await performCheckOutUseCase(event.reference);
      add(LoadReceptionDashboardEvent());
    } catch (e) {
      emit(ReceptionFailure(e.toString()));
    }
  }
}
