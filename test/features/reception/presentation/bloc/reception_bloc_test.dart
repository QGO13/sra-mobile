import 'package:flutter_test/flutter_test.dart';
import 'package:sra_hotel/features/reception/domain/entities/arrival_departure.dart';
import 'package:sra_hotel/features/reception/domain/repositories/reception_repository.dart';
import 'package:sra_hotel/features/reception/domain/usecases/get_arrivals_usecase.dart';
import 'package:sra_hotel/features/reception/domain/usecases/get_departures_usecase.dart';
import 'package:sra_hotel/features/reception/domain/usecases/get_reception_rooms_usecase.dart';
import 'package:sra_hotel/features/reception/domain/usecases/perform_checkin_usecase.dart';
import 'package:sra_hotel/features/reception/domain/usecases/perform_checkout_usecase.dart';
import 'package:sra_hotel/features/reception/presentation/bloc/reception_bloc.dart';
import 'package:sra_hotel/features/reception/presentation/bloc/reception_event.dart';
import 'package:sra_hotel/features/reception/presentation/bloc/reception_state.dart';
import 'package:sra_hotel/features/room_management/domain/entities/room.dart';

class MockReceptionRepository implements ReceptionRepository {
  final bool shouldThrow;

  MockReceptionRepository({this.shouldThrow = false});

  @override
  Future<List<ArrivalDeparture>> getArrivals() async {
    if (shouldThrow) throw Exception('Erreur chargement arrivées');
    return [
      ArrivalDeparture(
        id: 1,
        reference: 'RES-101',
        clientNom: 'Koffi Paul',
        typeChambre: 'Suite',
        checkIn: '2026-07-27',
        checkOut: '2026-07-29',
        adultes: 2,
        statutCheckin: 'NON_EFFECTUE',
        statutCheckout: 'NON_EFFECTUE',
      ),
    ];
  }

  @override
  Future<List<ArrivalDeparture>> getDepartures() async {
    if (shouldThrow) throw Exception('Erreur chargement départs');
    return [];
  }

  @override
  Future<List<Room>> getRooms() async {
    if (shouldThrow) throw Exception('Erreur chargement chambres');
    return [
      Room(
        id: '1',
        numero: '101',
        idTypeDeChambre: '1',
        type: 'Suite',
        etage: 1,
        statutMenage: 'PROPRE',
        estActive: 1,
        occupee: 0,
      ),
    ];
  }

  @override
  Future<void> performCheckIn(String ref, String roomNo) async {}

  @override
  Future<void> performCheckOut(String ref) async {}
}

void main() {
  group('ReceptionBloc Tests', () {
    late MockReceptionRepository repository;
    late ReceptionBloc receptionBloc;

    setUp(() {
      repository = MockReceptionRepository();
      receptionBloc = ReceptionBloc(
        getArrivalsUseCase: GetArrivalsUseCase(repository),
        getDeparturesUseCase: GetDeparturesUseCase(repository),
        performCheckInUseCase: PerformCheckInUseCase(repository),
        performCheckOutUseCase: PerformCheckOutUseCase(repository),
        getReceptionRoomsUseCase: GetReceptionRoomsUseCase(repository),
      );
    });

    tearDown(() {
      receptionBloc.close();
    });

    test('L\'état initial doit être ReceptionInitial', () {
      expect(receptionBloc.state, isA<ReceptionInitial>());
    });

    test('Doit émettre [ReceptionLoading, ReceptionLoaded] lors du chargement', () async {
      final expectedStates = [
        isA<ReceptionLoading>(),
        isA<ReceptionLoaded>(),
      ];

      expectLater(receptionBloc.stream, emitsInOrder(expectedStates));

      receptionBloc.add(LoadReceptionDashboardEvent());
    });

    test('Doit émettre [ReceptionLoading, ReceptionFailure] en cas d\'erreur', () async {
      final failingRepo = MockReceptionRepository(shouldThrow: true);
      final failingBloc = ReceptionBloc(
        getArrivalsUseCase: GetArrivalsUseCase(failingRepo),
        getDeparturesUseCase: GetDeparturesUseCase(failingRepo),
        performCheckInUseCase: PerformCheckInUseCase(failingRepo),
        performCheckOutUseCase: PerformCheckOutUseCase(failingRepo),
        getReceptionRoomsUseCase: GetReceptionRoomsUseCase(failingRepo),
      );

      final expectedStates = [
        isA<ReceptionLoading>(),
        isA<ReceptionFailure>(),
      ];

      expectLater(failingBloc.stream, emitsInOrder(expectedStates));

      failingBloc.add(LoadReceptionDashboardEvent());
    });
  });
}
