class RoomEntity {
  final String id;
  final String numero;
  final String idTypeDeChambre;
  final String statut;
  final double prixNuit;
  final String? imageUrl;

  const RoomEntity({
    required this.id,
    required this.numero,
    required this.idTypeDeChambre,
    required this.statut,
    required this.prixNuit,
    this.imageUrl,
  });

  List<Object?> get props => [id, numero, idTypeDeChambre, statut, prixNuit, imageUrl];

  // Helper getters for UI representation
  String get categoryName {
    final lower = idTypeDeChambre.toLowerCase();
    if (lower.contains('suite') || lower == '3' || lower == '24') {
      return 'Suite';
    }
    if (lower.contains('premium') || lower == '2' || lower == '23') {
      return 'Chambre Premium';
    }
    if (lower.contains('superior') || lower.contains('superieure') || lower == '22') {
      return 'Chambre Supérieure';
    }
    if (lower.contains('standard') || lower == '1' || lower == '21') {
      return 'Chambre Standard';
    }
    if (idTypeDeChambre.isNotEmpty && !idTypeDeChambre.contains('-')) {
      return idTypeDeChambre;
    }
    return 'Chambre Standard';
  }

  bool get isSuite {
    final lower = idTypeDeChambre.toLowerCase();
    return lower.contains('suite') || lower == '3' || lower == '24';
  }
}

