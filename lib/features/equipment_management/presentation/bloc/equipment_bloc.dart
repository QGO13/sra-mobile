import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_equipments_usecase.dart';
import '../../domain/usecases/create_equipment_usecase.dart';
import '../../domain/usecases/update_equipment_usecase.dart';
import '../../domain/usecases/delete_equipment_usecase.dart';
import 'equipment_event.dart';
import 'equipment_state.dart';

class EquipmentBloc extends Bloc<EquipmentEvent, EquipmentState> {
  final GetEquipmentsUseCase getEquipmentsUseCase;
  final CreateEquipmentUseCase createEquipmentUseCase;
  final UpdateEquipmentUseCase updateEquipmentUseCase;
  final DeleteEquipmentUseCase deleteEquipmentUseCase;

  EquipmentBloc({
    required this.getEquipmentsUseCase,
    required this.createEquipmentUseCase,
    required this.updateEquipmentUseCase,
    required this.deleteEquipmentUseCase,
  }) : super(EquipmentInitial()) {
    on<LoadEquipmentsEvent>(_onLoadEquipments);
    on<CreateEquipmentEvent>(_onCreateEquipment);
    on<UpdateEquipmentEvent>(_onUpdateEquipment);
    on<DeleteEquipmentEvent>(_onDeleteEquipment);
  }

  Future<void> _onLoadEquipments(LoadEquipmentsEvent event, Emitter<EquipmentState> emit) async {
    emit(EquipmentLoading());
    try {
      final list = await getEquipmentsUseCase();
      emit(EquipmentLoaded(list));
    } catch (e) {
      emit(EquipmentFailure(e.toString()));
    }
  }

  Future<void> _onCreateEquipment(CreateEquipmentEvent event, Emitter<EquipmentState> emit) async {
    try {
      await createEquipmentUseCase(event.equipment);
      add(LoadEquipmentsEvent());
    } catch (e) {
      emit(EquipmentFailure(e.toString()));
    }
  }

  Future<void> _onUpdateEquipment(UpdateEquipmentEvent event, Emitter<EquipmentState> emit) async {
    try {
      await updateEquipmentUseCase(event.equipment);
      add(LoadEquipmentsEvent());
    } catch (e) {
      emit(EquipmentFailure(e.toString()));
    }
  }

  Future<void> _onDeleteEquipment(DeleteEquipmentEvent event, Emitter<EquipmentState> emit) async {
    try {
      await deleteEquipmentUseCase(event.id);
      add(LoadEquipmentsEvent());
    } catch (e) {
      emit(EquipmentFailure(e.toString()));
    }
  }
}
