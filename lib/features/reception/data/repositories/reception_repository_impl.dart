import 'package:sra_hotel/features/reception/data/datasources/reception_remote_data_source.dart';
import 'package:sra_hotel/features/reception/domain/entities/arrival_departure.dart';
import 'package:sra_hotel/features/room_management/domain/entities/room.dart';
import 'package:sra_hotel/features/reception/domain/repositories/reception_repository.dart';

class ReceptionRepositoryImpl implements ReceptionRepository {
  final ReceptionRemoteDataSource remoteDataSource;

  ReceptionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ArrivalDeparture>> getArrivals() async {
    return await remoteDataSource.getArrivals();
  }

  @override
  Future<List<ArrivalDeparture>> getDepartures() async {
    return await remoteDataSource.getDepartures();
  }

  @override
  Future<void> performCheckIn(String ref, String roomNo) async {
    await remoteDataSource.performCheckIn(ref, roomNo);
  }

  @override
  Future<void> performCheckOut(String ref) async {
    await remoteDataSource.performCheckOut(ref);
  }

  @override
  Future<List<Room>> getRooms() async {
    return await remoteDataSource.getRooms();
  }
}
