class ArrivalDeparture {
  final int id;
  final String reference;
  final String clientNom;
  final String typeChambre;
  final String checkIn;
  final String checkOut;
  final int adultes;
  final int? enfants;
  final String statutCheckin;
  final String statutCheckout;
  final String? chambreAttribuee;
  final double? prixTotal;

  ArrivalDeparture({
    required this.id,
    required this.reference,
    required this.clientNom,
    required this.typeChambre,
    required this.checkIn,
    required this.checkOut,
    required this.adultes,
    this.enfants,
    required this.statutCheckin,
    required this.statutCheckout,
    this.chambreAttribuee,
    this.prixTotal,
  });
}
