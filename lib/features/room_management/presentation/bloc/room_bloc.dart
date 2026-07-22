import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/features/room_management/domain/entities/room.dart';
import 'package:sra_hotel/features/room_management/domain/entities/room_type.dart';
import 'package:sra_hotel/features/room_management/domain/usecases/get_rooms_usecase.dart';
import 'package:sra_hotel/features/room_management/domain/usecases/create_room_usecase.dart';
import 'package:sra_hotel/features/room_management/domain/usecases/update_room_usecase.dart';
import 'package:sra_hotel/features/room_management/domain/usecases/delete_room_usecase.dart';
import 'package:sra_hotel/features/room_management/domain/usecases/get_room_types_usecase.dart';
import 'package:sra_hotel/features/room_management/domain/usecases/create_room_type_usecase.dart';
import 'package:sra_hotel/features/room_management/domain/usecases/update_room_type_usecase.dart';
import 'package:sra_hotel/features/room_management/domain/usecases/delete_room_type_usecase.dart';
import 'room_event.dart';
import 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final GetRoomsUseCase getRoomsUseCase;
  final CreateRoomUseCase createRoomUseCase;
  final UpdateRoomUseCase updateRoomUseCase;
  final DeleteRoomUseCase deleteRoomUseCase;
  final GetRoomTypesUseCase getRoomTypesUseCase;
  final CreateRoomTypeUseCase createRoomTypeUseCase;
  final UpdateRoomTypeUseCase updateRoomTypeUseCase;
  final DeleteRoomTypeUseCase deleteRoomTypeUseCase;

  RoomBloc({
    required this.getRoomsUseCase,
    required this.createRoomUseCase,
    required this.updateRoomUseCase,
    required this.deleteRoomUseCase,
    required this.getRoomTypesUseCase,
    required this.createRoomTypeUseCase,
    required this.updateRoomTypeUseCase,
    required this.deleteRoomTypeUseCase,
  }) : super(RoomInitial()) {
    on<LoadRoomsAndTypesEvent>(_onLoadRoomsAndTypes);
    on<CreateRoomEvent>(_onCreateRoom);
    on<UpdateRoomEvent>(_onUpdateRoom);
    on<DeleteRoomEvent>(_onDeleteRoom);
    on<CreateRoomTypeEvent>(_onCreateRoomType);
    on<UpdateRoomTypeEvent>(_onUpdateRoomType);
    on<DeleteRoomTypeEvent>(_onDeleteRoomType);
  }

  Future<void> _onLoadRoomsAndTypes(LoadRoomsAndTypesEvent event, Emitter<RoomState> emit) async {
    emit(RoomLoading());
    try {
      final results = await Future.wait([
        getRoomsUseCase(),
        getRoomTypesUseCase(),
      ]);
      emit(RoomLoaded(
        rooms: results[0] as List<Room>,
        roomTypes: results[1] as List<RoomType>,
      ));
    } catch (e) {
      emit(RoomFailure(e.toString()));
    }
  }

  Future<void> _onCreateRoom(CreateRoomEvent event, Emitter<RoomState> emit) async {
    try {
      await createRoomUseCase(event.room);
      add(LoadRoomsAndTypesEvent());
    } catch (e) {
      emit(RoomFailure(e.toString()));
    }
  }

  Future<void> _onUpdateRoom(UpdateRoomEvent event, Emitter<RoomState> emit) async {
    try {
      await updateRoomUseCase(event.room);
      add(LoadRoomsAndTypesEvent());
    } catch (e) {
      emit(RoomFailure(e.toString()));
    }
  }

  Future<void> _onDeleteRoom(DeleteRoomEvent event, Emitter<RoomState> emit) async {
    try {
      await deleteRoomUseCase(event.id);
      add(LoadRoomsAndTypesEvent());
    } catch (e) {
      emit(RoomFailure(e.toString()));
    }
  }

  Future<void> _onCreateRoomType(CreateRoomTypeEvent event, Emitter<RoomState> emit) async {
    try {
      await createRoomTypeUseCase(event.type, imageFile: event.imageFile);
      add(LoadRoomsAndTypesEvent());
    } catch (e) {
      emit(RoomFailure(e.toString()));
    }
  }

  Future<void> _onUpdateRoomType(UpdateRoomTypeEvent event, Emitter<RoomState> emit) async {
    try {
      await updateRoomTypeUseCase(event.type, imageFile: event.imageFile);
      add(LoadRoomsAndTypesEvent());
    } catch (e) {
      emit(RoomFailure(e.toString()));
    }
  }

  Future<void> _onDeleteRoomType(DeleteRoomTypeEvent event, Emitter<RoomState> emit) async {
    try {
      await deleteRoomTypeUseCase(event.id);
      add(LoadRoomsAndTypesEvent());
    } catch (e) {
      emit(RoomFailure(e.toString()));
    }
  }
}
