import 'package:flutter_test/flutter_test.dart';
import 'package:sra_hotel/features/reservation_management/domain/entities/booking.dart';
import 'package:sra_hotel/features/reservation_management/domain/entities/booking_line.dart';
import 'package:sra_hotel/features/reservation_management/domain/repositories/booking_repository.dart';
import 'package:sra_hotel/features/reservation_management/domain/usecases/get_bookings_usecase.dart';
import 'package:sra_hotel/features/reservation_management/domain/usecases/update_booking_usecase.dart';
import 'package:sra_hotel/features/reservation_management/domain/usecases/cancel_booking_usecase.dart';
import 'package:sra_hotel/features/reservation_management/domain/usecases/update_booking_line_usecase.dart';
import 'package:sra_hotel/features/reservation_management/domain/usecases/apply_global_discount_usecase.dart';
import 'package:sra_hotel/features/reservation_management/domain/usecases/pay_booking_usecase.dart';
import 'package:sra_hotel/features/reservation_management/presentation/bloc/admin_booking_bloc.dart';
import 'package:sra_hotel/features/reservation_management/presentation/bloc/admin_booking_event.dart';
import 'package:sra_hotel/features/reservation_management/presentation/bloc/admin_booking_state.dart';

class MockBookingRepository implements BookingRepository {
  final List<Booking> bookings;

  MockBookingRepository({required this.bookings});

  @override
  Future<List<Booking>> getBookings() async => bookings;

  @override
  Future<Booking> updateBooking(Booking booking) async {
    final index = bookings.indexWhere((b) => b.id == booking.id);
    if (index != -1) {
      bookings[index] = booking;
    }
    return booking;
  }

  @override
  Future<void> cancelBooking(String id) async {
    final index = bookings.indexWhere((b) => b.id == id);
    if (index != -1) {
      bookings[index] = Booking(
        id: bookings[index].id,
        reference: bookings[index].reference,
        clientNom: bookings[index].clientNom,
        typeChambre: bookings[index].typeChambre,
        checkIn: bookings[index].checkIn,
        checkOut: bookings[index].checkOut,
        adultes: bookings[index].adultes,
        enfants: bookings[index].enfants,
        statutBooking: 'ANNULE',
        prixTotal: bookings[index].prixTotal,
        lines: bookings[index].lines,
      );
    }
  }

  @override
  Future<Booking> updateBookingLine(String bookingId, String lineId, {required double price}) async {
    final index = bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      final booking = bookings[index];
      final lineIndex = booking.lines.indexWhere((l) => l.id == lineId);
      if (lineIndex != -1) {
        final updatedLines = List<BookingLine>.from(booking.lines);
        updatedLines[lineIndex] = BookingLine(
          id: lineId,
          price: price,
          checkIn: booking.lines[lineIndex].checkIn,
          checkOut: booking.lines[lineIndex].checkOut,
          occupantName: booking.lines[lineIndex].occupantName,
          roomTypeName: booking.lines[lineIndex].roomTypeName,
          roomNumber: booking.lines[lineIndex].roomNumber,
          chambreId: booking.lines[lineIndex].chambreId,
        );
        final newSubtotal = updatedLines.fold(0.0, (sum, item) => sum + item.price);
        final newTotal = newSubtotal * (1 - booking.discountPercentage / 100);
        bookings[index] = Booking(
          id: booking.id,
          reference: booking.reference,
          clientNom: booking.clientNom,
          typeChambre: booking.typeChambre,
          checkIn: booking.checkIn,
          checkOut: booking.checkOut,
          adultes: booking.adultes,
          enfants: booking.enfants,
          statutBooking: booking.statutBooking,
          prixTotal: newTotal,
          discountPercentage: booking.discountPercentage,
          lines: updatedLines,
        );
        return bookings[index];
      }
    }
    throw Exception("Booking or line not found");
  }

  @override
  Future<Booking> applyGlobalDiscount(String bookingId, {required double discountPercentage}) async {
    final index = bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      final booking = bookings[index];
      final subtotal = booking.lines.fold(0.0, (sum, item) => sum + item.price);
      final newTotal = subtotal * (1 - discountPercentage / 100);
      bookings[index] = Booking(
        id: booking.id,
        reference: booking.reference,
        clientNom: booking.clientNom,
        typeChambre: booking.typeChambre,
        checkIn: booking.checkIn,
        checkOut: booking.checkOut,
        adultes: booking.adultes,
        enfants: booking.enfants,
        statutBooking: booking.statutBooking,
        prixTotal: newTotal,
        discountPercentage: discountPercentage,
        lines: booking.lines,
      );
      return bookings[index];
    }
    throw Exception("Booking not found");
  }

  @override
  Future<void> payBooking(String bookingId, {required double amount, required String paymentMethod}) async {
    final index = bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      bookings[index] = Booking(
        id: bookings[index].id,
        reference: bookings[index].reference,
        clientNom: bookings[index].clientNom,
        typeChambre: bookings[index].typeChambre,
        checkIn: bookings[index].checkIn,
        checkOut: bookings[index].checkOut,
        adultes: bookings[index].adultes,
        enfants: bookings[index].enfants,
        statutBooking: 'CONFIRMEE',
        prixTotal: bookings[index].prixTotal,
        discountPercentage: bookings[index].discountPercentage,
        lines: bookings[index].lines,
      );
    }
  }
}

void main() {
  group('AdminBookingBloc Tests', () {
    late AdminBookingBloc bloc;
    late MockBookingRepository repository;
    late GetBookingsUseCase getBookingsUseCase;
    late UpdateBookingUseCase updateBookingUseCase;
    late CancelBookingUseCase cancelBookingUseCase;
    late UpdateBookingLineUseCase updateBookingLineUseCase;
    late ApplyGlobalDiscountUseCase applyGlobalDiscountUseCase;
    late PayBookingUseCase payBookingUseCase;

    final mockBookings = [
      Booking(
        id: '1',
        reference: 'SRA-1234',
        clientNom: 'Koffi Amedee',
        typeChambre: 'Chambre Prestige',
        checkIn: '2026-07-10',
        checkOut: '2026-07-15',
        adultes: 2,
        enfants: 1,
        statutBooking: 'EN_ATTENTE',
        prixTotal: 150000.0,
        discountPercentage: 0.0,
        lines: [
          BookingLine(
            id: '10',
            price: 150000.0,
            checkIn: '2026-07-10',
            checkOut: '2026-07-15',
            occupantName: 'Koffi Amedee',
            roomTypeName: 'Chambre Prestige',
            roomNumber: '201',
            chambreId: '1',
          )
        ],
      ),
    ];

    setUp(() {
      repository = MockBookingRepository(bookings: List.from(mockBookings));
      getBookingsUseCase = GetBookingsUseCase(repository);
      updateBookingUseCase = UpdateBookingUseCase(repository);
      cancelBookingUseCase = CancelBookingUseCase(repository);
      updateBookingLineUseCase = UpdateBookingLineUseCase(repository);
      applyGlobalDiscountUseCase = ApplyGlobalDiscountUseCase(repository);
      payBookingUseCase = PayBookingUseCase(repository);

      bloc = AdminBookingBloc(
        getBookingsUseCase: getBookingsUseCase,
        updateBookingUseCase: updateBookingUseCase,
        cancelBookingUseCase: cancelBookingUseCase,
        updateBookingLineUseCase: updateBookingLineUseCase,
        applyGlobalDiscountUseCase: applyGlobalDiscountUseCase,
        payBookingUseCase: payBookingUseCase,
      );
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state should be AdminBookingInitial', () {
      expect(bloc.state, isA<AdminBookingInitial>());
    });

    test('should emit [AdminBookingLoading, AdminBookingLoaded] when LoadAdminBookingsEvent is added', () async {
      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<AdminBookingLoading>(),
          isA<AdminBookingLoaded>(),
        ]),
      );
      bloc.add(LoadAdminBookingsEvent());
    });

    test('should reload bookings when UpdateBookingLineEvent is added', () async {
      bloc.add(LoadAdminBookingsEvent());
      await bloc.stream.firstWhere((state) => state is AdminBookingLoaded);

      bloc.add(UpdateBookingLineEvent(bookingId: '1', lineId: '10', price: 120000.0));
      await bloc.stream.firstWhere((state) => state is AdminBookingLoaded);

      final state = bloc.state as AdminBookingLoaded;
      expect(state.bookings.first.lines.first.price, 120000.0);
      expect(state.bookings.first.prixTotal, 120000.0);
    });

    test('should reload bookings and update total when ApplyGlobalDiscountEvent is added', () async {
      bloc.add(LoadAdminBookingsEvent());
      await bloc.stream.firstWhere((state) => state is AdminBookingLoaded);

      bloc.add(ApplyGlobalDiscountEvent(bookingId: '1', discountPercentage: 10.0));
      await bloc.stream.firstWhere((state) => state is AdminBookingLoaded);

      final state = bloc.state as AdminBookingLoaded;
      expect(state.bookings.first.discountPercentage, 10.0);
      expect(state.bookings.first.prixTotal, 135000.0); // 150000 * 0.9
    });

    test('should mark booking as paid (statutBooking = CONFIRMEE) when PayBookingEvent is added', () async {
      bloc.add(LoadAdminBookingsEvent());
      await bloc.stream.firstWhere((state) => state is AdminBookingLoaded);

      bloc.add(PayBookingEvent(bookingId: '1', amount: 150000.0, paymentMethod: 'CASH'));
      await bloc.stream.firstWhere((state) => state is AdminBookingLoaded);

      final state = bloc.state as AdminBookingLoaded;
      expect(state.bookings.first.statutBooking, 'CONFIRMEE');
    });
  });
}
