import 'package:sra_hotel/features/reception/domain/entities/arrival_departure.dart';

class ArrivalDepartureModel extends ArrivalDeparture {
  ArrivalDepartureModel({
    required super.id,
    required super.reference,
    required super.clientNom,
    required super.typeChambre,
    required super.checkIn,
    required super.checkOut,
    required super.adultes,
    super.enfants,
    required super.statutCheckin,
    required super.statutCheckout,
    super.chambreAttribuee,
    super.prixTotal,
  });

  factory ArrivalDepartureModel.fromJson(Map<String, dynamic> json) {
    return ArrivalDepartureModel(
      id: json['id'] as int,
      reference: json['reference'] as String,
      clientNom: json['client_nom'] as String,
      typeChambre: json['type_chambre'] as String,
      checkIn: json['check_in'] as String,
      checkOut: json['check_out'] as String,
      adultes: json['adultes'] as int,
      enfants: json['enfants'] as int?,
      statutCheckin: json['statut_checkin'] as String,
      statutCheckout: json['statut_checkout'] as String,
      chambreAttribuee: json['chambre_attribuee'] as String?,
      prixTotal: json['prix_total'] != null ? (json['prix_total'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reference': reference,
      'client_nom': clientNom,
      'type_chambre': typeChambre,
      'check_in': checkIn,
      'check_out': checkOut,
      'adultes': adultes,
      'enfants': enfants,
      'statut_checkin': statutCheckin,
      'statut_checkout': statutCheckout,
      'chambre_attribuee': chambreAttribuee,
      'prix_total': prixTotal,
    };
  }
}
