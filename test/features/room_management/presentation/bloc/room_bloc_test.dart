import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sra_hotel/features/room_management/domain/entities/room.dart';
import 'package:sra_hotel/features/room_management/domain/entities/room_type.dart';
import 'package:sra_hotel/features/room_management/domain/repositories/room_repository.dart';
import 'package:sra_hotel/features/room_management/domain/usecases/create_room_type_usecase.dart';
import 'package:sra_hotel/features/room_management/domain/usecases/create_room_usecase.dart';
import 'package:sra_hotel/features/room_management/domain/usecases/delete_room_type_usecase.dart';
import 'package:sra_hotel/features/room_management/domain/usecases/delete_room_usecase.dart';
import 'package:sra_hotel/features/room_management/domain/usecases/get_room_types_usecase.dart';
import 'package:sra_hotel/features/room_management/domain/usecases/get_rooms_usecase.dart';
import 'package:sra_hotel/features/room_management/domain/usecases/update_room_type_usecase.dart';
import 'package:sra_hotel/features/room_management/domain/usecases/update_room_usecase.dart';
import 'package:sra_hotel/features/room_management/presentation/bloc/room_bloc.dart';
import 'package:sra_hotel/features/room_management/presentation/bloc/room_event.dart';
import 'package:sra_hotel/features/room_management/presentation/bloc/room_state.dart';

class MockRoomRepository implements RoomRepository {
  final bool shouldThrow;

  MockRoomRepository({this.shouldThrow = false});

  @override
  Future<List<Room>> getRooms() async {
    if (shouldThrow) throw Exception('Erreur chargement chambres');
    return [
      Room(
        id: '1',
        numero: '101',
        idTypeDeChambre: '1',
        type: 'Deluxe',
        occupee: 0,
        statutMenage: 'PROPRE',
        etage: 1,
        estActive: 1,
      ),
    ];
  }

  @override
  Future<List<RoomType>> getRoomTypes() async {
    if (shouldThrow) throw Exception('Erreur chargement typologies');
    return [
      RoomType(
        id: '1',
        nom: 'Deluxe',
        prixNuit: 50000,
        capacite: 2,
        description: 'Chambre spacieuse',
        images: [],
      ),
    ];
  }

  @override
  Future<Room> createRoom(Room room) async => room;

  @override
  Future<Room> updateRoom(Room room) async => room;

  @override
  Future<void> deleteRoom(String id) async {}

  @override
  Future<RoomType> createRoomType(RoomType type, {XFile? imageFile}) async => type;

  @override
  Future<RoomType> updateRoomType(RoomType type, {XFile? imageFile}) async => type;

  @override
  Future<void> deleteRoomType(String id) async {}
}

void main() {
  group('RoomBloc Tests', () {
    late MockRoomRepository repository;
    late RoomBloc roomBloc;

    setUp(() {
      repository = MockRoomRepository();
      roomBloc = RoomBloc(
        getRoomsUseCase: GetRoomsUseCase(repository),
        createRoomUseCase: CreateRoomUseCase(repository),
        updateRoomUseCase: UpdateRoomUseCase(repository),
        deleteRoomUseCase: DeleteRoomUseCase(repository),
        getRoomTypesUseCase: GetRoomTypesUseCase(repository),
        createRoomTypeUseCase: CreateRoomTypeUseCase(repository),
        updateRoomTypeUseCase: UpdateRoomTypeUseCase(repository),
        deleteRoomTypeUseCase: DeleteRoomTypeUseCase(repository),
      );
    });

    tearDown(() {
      roomBloc.close();
    });

    test('L\'état initial doit être RoomInitial', () {
      expect(roomBloc.state, isA<RoomInitial>());
    });

    test('Doit émettre [RoomLoading, RoomLoaded] lors du chargement des chambres et types', () async {
      final expectedStates = [
        isA<RoomLoading>(),
        isA<RoomLoaded>(),
      ];

      expectLater(roomBloc.stream, emitsInOrder(expectedStates));

      roomBloc.add(LoadRoomsAndTypesEvent());
    });

    test('Doit émettre [RoomLoading, RoomFailure] en cas d\'erreur de chargement', () async {
      final failingRepo = MockRoomRepository(shouldThrow: true);
      final failingBloc = RoomBloc(
        getRoomsUseCase: GetRoomsUseCase(failingRepo),
        createRoomUseCase: CreateRoomUseCase(failingRepo),
        updateRoomUseCase: UpdateRoomUseCase(failingRepo),
        deleteRoomUseCase: DeleteRoomUseCase(failingRepo),
        getRoomTypesUseCase: GetRoomTypesUseCase(failingRepo),
        createRoomTypeUseCase: CreateRoomTypeUseCase(failingRepo),
        updateRoomTypeUseCase: UpdateRoomTypeUseCase(failingRepo),
        deleteRoomTypeUseCase: DeleteRoomTypeUseCase(failingRepo),
      );

      final expectedStates = [
        isA<RoomLoading>(),
        isA<RoomFailure>(),
      ];

      expectLater(failingBloc.stream, emitsInOrder(expectedStates));

      failingBloc.add(LoadRoomsAndTypesEvent());
    });
  });
}
