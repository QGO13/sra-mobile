class RoomType {
  final String id;
  final String nom;
  final double prixNuit;
  final int capacite;
  final String description;
  final List<String> images;

  RoomType({
    required this.id,
    required this.nom,
    required this.prixNuit,
    required this.capacite,
    required this.description,
    required this.images,
  });
}
