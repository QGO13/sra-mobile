class BookingRoom {
  final String id;
  final String numero;
  final String idTypeDeChambre;
  final String statut;
  final double prixNuit;
  final String? imageUrl;

  const BookingRoom({
    required this.id,
    required this.numero,
    required this.idTypeDeChambre,
    required this.statut,
    required this.prixNuit,
    this.imageUrl,
  });

  List<Object?> get props => [id, numero, idTypeDeChambre, statut, prixNuit, imageUrl];

  // Helper getters matching client needs
  String get categoryName {
    final lower = idTypeDeChambre.toLowerCase();
    if (lower.contains('suite') || lower == '3' || lower == '24') {
      return 'Suite';
    }
    if (lower.contains('premium') || lower == '2' || lower == '23') {
      return 'Premium';
    }
    return 'Standard';
  }

  bool get isSuite {
    final lower = idTypeDeChambre.toLowerCase();
    return lower.contains('suite') || lower == '3' || lower == '24';
  }
}
