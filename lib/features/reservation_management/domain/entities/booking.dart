import 'package:sra_hotel/features/reservation_management/domain/entities/booking_line.dart';

class Booking {
  final String id;
  final String reference;
  final String clientNom;
  final String typeChambre;
  final String checkIn;
  final String checkOut;
  final int adultes;
  final int? enfants;
  final String statutBooking;
  final double prixTotal;
  final double totalPaid;
  final double balanceDue;
  final String? folioId;
  final double discountPercentage;
  final List<BookingLine> lines;

  Booking({
    required this.id,
    required this.reference,
    required this.clientNom,
    required this.typeChambre,
    required this.checkIn,
    required this.checkOut,
    required this.adultes,
    this.enfants,
    required this.statutBooking,
    required this.prixTotal,
    this.totalPaid = 0.0,
    this.balanceDue = 0.0,
    this.folioId,
    this.discountPercentage = 0.0,
    this.lines = const [],
  });

  /// Le client a-t-il réglé l'acompte de 50% minimum obligatoire pour le check-in ?
  bool get hasMinDepositPaid => totalPaid >= (prixTotal * 0.5);
}
