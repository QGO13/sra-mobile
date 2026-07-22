class Room {
  final String id;
  final String numero;
  final String idTypeDeChambre;
  final String type;
  final int etage;
  final String statutMenage;
  final int estActive;
  final int occupee;
  final String? clientActuel;

  Room({
    required this.id,
    required this.numero,
    required this.idTypeDeChambre,
    required this.type,
    required this.etage,
    required this.statutMenage,
    required this.estActive,
    required this.occupee,
    this.clientActuel,
  });
}
