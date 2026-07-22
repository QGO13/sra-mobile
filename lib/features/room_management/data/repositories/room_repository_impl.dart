import 'package:image_picker/image_picker.dart';
import 'package:sra_hotel/features/room_management/data/datasources/room_remote_data_source.dart';
import 'package:sra_hotel/features/room_management/data/models/room_model.dart';
import 'package:sra_hotel/features/room_management/data/models/room_type_model.dart';
import 'package:sra_hotel/features/room_management/domain/entities/room.dart';
import 'package:sra_hotel/features/room_management/domain/entities/room_type.dart';
import 'package:sra_hotel/features/room_management/domain/repositories/room_repository.dart';

class RoomRepositoryImpl implements RoomRepository {
  final RoomRemoteDataSource remoteDataSource;

  RoomRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Room>> getRooms() async {
    return await remoteDataSource.getRooms();
  }

  @override
  Future<Room> createRoom(Room room) async {
    return await remoteDataSource.createRoom(
      RoomModel(
        id: room.id,
        numero: room.numero,
        idTypeDeChambre: room.idTypeDeChambre,
        type: room.type,
        etage: room.etage,
        statutMenage: room.statutMenage,
        estActive: room.estActive,
        occupee: room.occupee,
        clientActuel: room.clientActuel,
      ),
    );
  }

  @override
  Future<Room> updateRoom(Room room) async {
    return await remoteDataSource.updateRoom(
      RoomModel(
        id: room.id,
        numero: room.numero,
        idTypeDeChambre: room.idTypeDeChambre,
        type: room.type,
        etage: room.etage,
        statutMenage: room.statutMenage,
        estActive: room.estActive,
        occupee: room.occupee,
        clientActuel: room.clientActuel,
      ),
    );
  }

  @override
  Future<void> deleteRoom(String id) async {
    await remoteDataSource.deleteRoom(id);
  }

  @override
  Future<List<RoomType>> getRoomTypes() async {
    return await remoteDataSource.getRoomTypes();
  }

  @override
  Future<RoomType> createRoomType(RoomType type, {XFile? imageFile}) async {
    return await remoteDataSource.createRoomType(
      RoomTypeModel(
        id: type.id,
        nom: type.nom,
        prixNuit: type.prixNuit,
        capacite: type.capacite,
        description: type.description,
        images: type.images,
      ),
      imageFile: imageFile,
    );
  }

  @override
  Future<RoomType> updateRoomType(RoomType type, {XFile? imageFile}) async {
    return await remoteDataSource.updateRoomType(
      RoomTypeModel(
        id: type.id,
        nom: type.nom,
        prixNuit: type.prixNuit,
        capacite: type.capacite,
        description: type.description,
        images: type.images,
      ),
      imageFile: imageFile,
    );
  }

  @override
  Future<void> deleteRoomType(String id) async {
    await remoteDataSource.deleteRoomType(id);
  }
}
