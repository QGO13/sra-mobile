import 'package:sra_hotel/features/room_management/domain/entities/room.dart';

class RoomModel extends Room {
  RoomModel({
    required super.id,
    required super.numero,
    required super.idTypeDeChambre,
    required super.type,
    required super.etage,
    required super.statutMenage,
    required super.estActive,
    required super.occupee,
    super.clientActuel,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    final roomType = json['room_type'] as Map<String, dynamic>?;
    final backendEtat = (json['etat'] ?? json['statut_menage'] ?? 'EN_COURS').toString().toUpperCase();
    
    // Mapping du statut de ménage
    String appStatus = 'PROPRE';
    if (backendEtat == 'A_NETTOYER' || backendEtat == 'SALE') {
      appStatus = 'SALE';
    } else if (backendEtat == 'EN_COURS') {
      appStatus = 'EN_COURS';
    } else if (backendEtat == 'MAINTENANCE') {
      appStatus = 'MAINTENANCE';
    }
 
    final isRoomActive = json['is_active'] == true || json['est_active'] == 1 || json['is_active'] == 1;
 
    return RoomModel(
      id: (json['id'] ?? '').toString(),
      numero: (json['number'] ?? json['numero'] ?? '').toString(),
      idTypeDeChambre: (json['room_type_id'] ?? json['id_type_de_chambre'] ?? '').toString(),
      type: roomType != null ? (roomType['name'] as String) : (json['type'] ?? 'Chambre Standard'),
      etage: (json['etage'] ?? 1) as int,
      statutMenage: appStatus,
      estActive: isRoomActive ? 1 : 0,
      occupee: (json['occupee'] ?? 0) as int,
      clientActuel: json['client_actuel'] as String?,
    );
  }
 
  Map<String, dynamic> toJson() {
    // Convertir le statut vers le format du backend
    String backendEtat = 'EN_COURS';
    if (statutMenage.toUpperCase() == 'SALE' || statutMenage.toUpperCase() == 'A_NETTOYER') {
      backendEtat = 'A_NETTOYER';
    } else if (statutMenage.toUpperCase() == 'MAINTENANCE') {
      backendEtat = 'MAINTENANCE';
    } else if (statutMenage.toUpperCase() == 'EN_COURS') {
      backendEtat = 'EN_COURS';
    }
 
    return {
      'id': id,
      'number': int.tryParse(numero) ?? 101, // Le backend attend un entier
      'room_type_id': idTypeDeChambre,
      'etat': backendEtat,
      'is_active': estActive == 1,
      'etage': etage,
    };
  }
 
  RoomModel copyWith({
    String? id,
    String? numero,
    String? idTypeDeChambre,
    String? type,
    int? etage,
    String? statutMenage,
    int? estActive,
    int? occupee,
    String? clientActuel,
  }) {
    return RoomModel(
      id: id ?? this.id,
      numero: numero ?? this.numero,
      idTypeDeChambre: idTypeDeChambre ?? this.idTypeDeChambre,
      type: type ?? this.type,
      etage: etage ?? this.etage,
      statutMenage: statutMenage ?? this.statutMenage,
      estActive: estActive ?? this.estActive,
      occupee: occupee ?? this.occupee,
      clientActuel: clientActuel ?? this.clientActuel,
    );
  }
}
