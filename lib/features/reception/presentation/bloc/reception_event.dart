abstract class ReceptionEvent {}

class LoadReceptionDashboardEvent extends ReceptionEvent {}

class PerformCheckInEvent extends ReceptionEvent {
  final String reference;
  final String roomNumber;
  PerformCheckInEvent(this.reference, this.roomNumber);
}

class PerformCheckOutEvent extends ReceptionEvent {
  final String reference;
  PerformCheckOutEvent(this.reference);
}
