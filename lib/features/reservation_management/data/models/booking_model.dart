import 'package:sra_hotel/features/reservation_management/domain/entities/booking.dart';
import 'package:sra_hotel/features/reservation_management/domain/entities/booking_line.dart';

class BookingModel extends Booking {
  BookingModel({
    required super.id,
    required super.reference,
    required super.clientNom,
    required super.typeChambre,
    required super.checkIn,
    required super.checkOut,
    required super.adultes,
    super.enfants,
    required super.statutBooking,
    required super.prixTotal,
    super.totalPaid = 0.0,
    super.balanceDue = 0.0,
    super.folioId,
    super.discountPercentage = 0.0,
    required super.lines,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    final lines = json['reservation_lines'] as List?;
    
    // Extraction des dates
    String checkInVal = (json['check_in'] ?? '').toString();
    String checkOutVal = (json['check_out'] ?? '').toString();
    if (lines != null && lines.isNotEmpty) {
      checkInVal = (lines[0]['check_in'] ?? checkInVal).toString();
      checkOutVal = (lines[0]['check_out'] ?? checkOutVal).toString();
    }
    
    // Nettoyer les dates s'il y a du temps (split 'T')
    checkInVal = checkInVal.split('T').first;
    checkOutVal = checkOutVal.split('T').first;

    // Calcul du prix total si présent ou somme des lignes
    double total = 0.0;
    if (json['total_price'] != null) {
      total = double.tryParse(json['total_price'].toString()) ?? 0.0;
    } else if (json['prix_total'] != null) {
      total = (json['prix_total'] as num).toDouble();
    } else if (lines != null) {
      total = lines.fold(0.0, (sum, line) {
        final priceVal = line['price'];
        final priceDouble = priceVal != null ? double.tryParse(priceVal.toString()) ?? 0.0 : 0.0;
        return sum + priceDouble;
      });
    }

    final double totalPaid = double.tryParse((json['total_paid'] ?? '0.0').toString()) ?? 0.0;
    final double balanceDue = double.tryParse((json['balance_due'] ?? '0.0').toString()) ?? (total - totalPaid);
    final String? folioId = json['folio_id']?.toString();

    // Récupérer le nom de l'occupant
    String clientName = 'Client SRA';
    if (lines != null && lines.isNotEmpty) {
      clientName = (lines[0]['occupant_name'] ?? clientName).toString();
    } else if (json['client_nom'] != null || json['nom_occupant'] != null) {
      clientName = (json['client_nom'] ?? json['nom_occupant']).toString();
    }

    // Récupérer le type de chambre
    String roomType = 'Chambre Standard';
    if (json['type_chambre'] != null) {
      roomType = json['type_chambre'].toString();
    } else if (lines != null && lines.isNotEmpty) {
      final firstLine = lines.first as Map<String, dynamic>;
      if (firstLine['room_type'] != null && firstLine['room_type']['name'] != null) {
        roomType = firstLine['room_type']['name'].toString();
      }
    }

    // Parser les BookingLines
    final parsedLines = <BookingLine>[];
    if (lines != null) {
      for (var line in lines) {
        final lineMap = line as Map<String, dynamic>;
        
        String rtName = 'Chambre Standard';
        if (lineMap['room_type'] != null && lineMap['room_type']['name'] != null) {
          rtName = lineMap['room_type']['name'].toString();
        } else {
          final typeIdStr = (lineMap['room_type_id'] ?? '').toString();
          if (typeIdStr.contains('suite') || typeIdStr == '24') rtName = 'Chambre Suite';
          if (typeIdStr.contains('premium') || typeIdStr == '23') rtName = 'Chambre Premium';
          if (typeIdStr.contains('superior') || typeIdStr == '22') rtName = 'Chambre Supérieure';
        }
        
        final priceVal = lineMap['price'];
        final priceDouble = priceVal != null ? double.tryParse(priceVal.toString()) ?? 0.0 : 0.0;
        
        parsedLines.add(
          BookingLine(
            id: (lineMap['id'] ?? '').toString(),
            roomTypeName: rtName,
            price: priceDouble,
            checkIn: (lineMap['check_in'] ?? '').toString().split('T').first,
            checkOut: (lineMap['check_out'] ?? '').toString().split('T').first,
            occupantName: lineMap['occupant_name']?.toString(),
            roomNumber: (lineMap['chambre_numero'] ?? lineMap['room_number'])?.toString(),
            chambreId: (lineMap['chambre_id'] ?? lineMap['room_id'] ?? '').toString(),
            status: (lineMap['status'] ?? 'En attente').toString(),
          ),
        );
      }
    }

    final discountPercentage = ((json['discount_percentage'] ?? 0.0) as num).toDouble();

    return BookingModel(
      id: (json['id'] ?? '').toString(),
      reference: (json['no_references'] ?? json['reference'] ?? '').toString(),
      clientNom: clientName,
      typeChambre: roomType,
      checkIn: checkInVal,
      checkOut: checkOutVal,
      adultes: (json['adultes'] ?? 1) as int,
      enfants: json['enfants'] as int?,
      statutBooking: normalizeStatus((json['status'] ?? json['statut_booking'] ?? 'EN_ATTENTE').toString()),
      prixTotal: total,
      totalPaid: totalPaid,
      balanceDue: balanceDue,
      folioId: folioId,
      discountPercentage: discountPercentage,
      lines: parsedLines,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'no_references': reference,
      'client_nom': clientNom,
      'type_chambre': typeChambre,
      'check_in': checkIn,
      'check_out': checkOut,
      'adultes': adultes,
      'enfants': enfants,
      'status': denormalizeStatus(statutBooking),
      'total_price': prixTotal.toString(),
      'total_paid': totalPaid.toString(),
      'balance_due': balanceDue.toString(),
      'folio_id': folioId,
      'discount_percentage': discountPercentage,
      'reservation_lines': lines.map((l) => {
        'id': l.id,
        'price': l.price.toString(),
        'check_in': l.checkIn,
        'check_out': l.checkOut,
        'occupant_name': l.occupantName,
        'status': l.status,
        'room_type': {
          'name': l.roomTypeName,
        },
        'chambre_numero': l.roomNumber,
        'chambre_id': l.chambreId,
      }).toList(),
    };
  }

  static String normalizeStatus(String status) {
    final s = status.toUpperCase().trim();
    if (s.contains('ATTENTE')) return 'EN_ATTENTE';
    if (s.contains('CONFIRM')) return 'CONFIRMEE';
    if (s.contains('ANNUL')) return 'ANNULEE';
    if (s.contains('EFFECTU') || s.contains('COURS') || s.contains('SEJOUR')) return 'EFFECTUE';
    if (s.contains('TERMIN') || s.contains('PASSE')) return 'TERMINEE';
    return s;
  }

  static String denormalizeStatus(String status) {
    switch (status.toUpperCase()) {
      case 'EN_ATTENTE':
      case 'CONFIRMEE':
      case 'CONFIRME':
        return 'En attente';
      case 'EFFECTUE':
        return 'En cours';
      case 'TERMINEE':
        return 'Terminée';
      case 'ANNULEE':
      case 'ANNULE':
        return 'Annulée';
      default:
        return status;
    }
  }
}
