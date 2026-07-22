abstract class BookingEvent {
  const BookingEvent();

  List<Object?> get props => [];
}

class SearchRoomsRequested extends BookingEvent {
  final DateTime checkIn;
  final DateTime checkOut;
  final String? categoryId;

  const SearchRoomsRequested({
    required this.checkIn,
    required this.checkOut,
    this.categoryId,
  });

  @override
  List<Object?> get props => [checkIn, checkOut, categoryId];
}

class VerifyRoomRequested extends BookingEvent {
  final String roomId;
  final DateTime checkIn;
  final DateTime checkOut;

  const VerifyRoomRequested({
    required this.roomId,
    required this.checkIn,
    required this.checkOut,
  });

  @override
  List<Object?> get props => [roomId, checkIn, checkOut];
}

