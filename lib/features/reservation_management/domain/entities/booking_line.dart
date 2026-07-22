class BookingLine {
  final String id;
  final String roomTypeName;
  final double price;
  final String checkIn;
  final String checkOut;
  final String? occupantName;
  final String? roomNumber;
  final String? chambreId;

  const BookingLine({
    required this.id,
    required this.roomTypeName,
    required this.price,
    required this.checkIn,
    required this.checkOut,
    this.occupantName,
    this.roomNumber,
    this.chambreId,
  });
}

