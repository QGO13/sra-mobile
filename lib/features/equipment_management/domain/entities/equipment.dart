class Equipment {
  final String id;
  final String name;
  final String codeEq;
  final int quantity;
  final String description;
  final String status;
  final String? roomNumber;

  Equipment({
    required this.id,
    required this.name,
    this.codeEq = '',
    this.quantity = 1,
    required this.description,
    required this.status,
    this.roomNumber,
  });
}
