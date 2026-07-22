import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/features/reservation_management/domain/entities/booking.dart';
import 'package:sra_hotel/features/reservation_management/domain/usecases/get_bookings_usecase.dart';
import 'package:sra_hotel/features/reservation_management/domain/usecases/update_booking_usecase.dart';
import 'package:sra_hotel/features/reservation_management/domain/usecases/cancel_booking_usecase.dart';
import 'package:sra_hotel/features/reservation_management/domain/usecases/update_booking_line_usecase.dart';
import 'package:sra_hotel/features/reservation_management/domain/usecases/apply_global_discount_usecase.dart';
import 'package:sra_hotel/features/reservation_management/domain/usecases/pay_booking_usecase.dart';
import 'admin_booking_event.dart';
import 'admin_booking_state.dart';

class AdminBookingBloc extends Bloc<AdminBookingEvent, AdminBookingState> {
  final GetBookingsUseCase getBookingsUseCase;
  final UpdateBookingUseCase updateBookingUseCase;
  final CancelBookingUseCase cancelBookingUseCase;
  final UpdateBookingLineUseCase updateBookingLineUseCase;
  final ApplyGlobalDiscountUseCase applyGlobalDiscountUseCase;
  final PayBookingUseCase payBookingUseCase;

  AdminBookingBloc({
    required this.getBookingsUseCase,
    required this.updateBookingUseCase,
    required this.cancelBookingUseCase,
    required this.updateBookingLineUseCase,
    required this.applyGlobalDiscountUseCase,
    required this.payBookingUseCase,
  }) : super(AdminBookingInitial()) {
    on<LoadAdminBookingsEvent>(_onLoadBookings);
    on<CancelAdminBookingEvent>(_onCancelBooking);
    on<ValidateAdminBookingEvent>(_onValidateBooking);
    on<UpdateBookingLineEvent>(_onUpdateBookingLine);
    on<ApplyGlobalDiscountEvent>(_onApplyGlobalDiscount);
    on<PayBookingEvent>(_onPayBooking);
  }

  Future<void> _onLoadBookings(LoadAdminBookingsEvent event, Emitter<AdminBookingState> emit) async {
    emit(AdminBookingLoading());
    try {
      final list = await getBookingsUseCase();
      emit(AdminBookingLoaded(list));
    } catch (e) {
      emit(AdminBookingFailure(e.toString()));
    }
  }

  Future<void> _onCancelBooking(CancelAdminBookingEvent event, Emitter<AdminBookingState> emit) async {
    try {
      await cancelBookingUseCase(event.id);
      add(LoadAdminBookingsEvent());
    } catch (e) {
      emit(AdminBookingFailure(e.toString()));
    }
  }

  Future<void> _onValidateBooking(ValidateAdminBookingEvent event, Emitter<AdminBookingState> emit) async {
    try {
      final validated = Booking(
        id: event.booking.id,
        reference: event.booking.reference,
        clientNom: event.booking.clientNom,
        typeChambre: event.booking.typeChambre,
        checkIn: event.booking.checkIn,
        checkOut: event.booking.checkOut,
        adultes: event.booking.adultes,
        enfants: event.booking.enfants,
        statutBooking: 'CONFIRME',
        prixTotal: event.booking.prixTotal,
      );
      await updateBookingUseCase(validated);
      add(LoadAdminBookingsEvent());
    } catch (e) {
      emit(AdminBookingFailure(e.toString()));
    }
  }

  Future<void> _onUpdateBookingLine(UpdateBookingLineEvent event, Emitter<AdminBookingState> emit) async {
    try {
      await updateBookingLineUseCase(event.bookingId, event.lineId, price: event.price);
      add(LoadAdminBookingsEvent());
    } catch (e) {
      emit(AdminBookingFailure(e.toString()));
    }
  }

  Future<void> _onApplyGlobalDiscount(ApplyGlobalDiscountEvent event, Emitter<AdminBookingState> emit) async {
    try {
      await applyGlobalDiscountUseCase(event.bookingId, discountPercentage: event.discountPercentage);
      add(LoadAdminBookingsEvent());
    } catch (e) {
      emit(AdminBookingFailure(e.toString()));
    }
  }

  Future<void> _onPayBooking(PayBookingEvent event, Emitter<AdminBookingState> emit) async {
    try {
      await payBookingUseCase(event.bookingId, amount: event.amount, paymentMethod: event.paymentMethod);
      add(LoadAdminBookingsEvent());
    } catch (e) {
      emit(AdminBookingFailure(e.toString()));
    }
  }
}
