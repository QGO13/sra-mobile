class BookingRoomType {
  final String id;
  final String nom;
  final double prixNuit;
  final int capacite;
  final String description;
  final List<String> images;
  final List<String> equipments;

  const BookingRoomType({
    required this.id,
    required this.nom,
    required this.prixNuit,
    required this.capacite,
    required this.description,
    required this.images,
    required this.equipments,
  });

  List<Object?> get props => [id, nom, prixNuit, capacite, description, images, equipments];
}
