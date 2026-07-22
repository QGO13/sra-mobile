import 'package:sra_hotel/features/invoice_management/domain/entities/client_invoice.dart';

class ClientInvoiceModel extends ClientInvoice {
  ClientInvoiceModel({
    required super.id,
    required super.code,
    required super.clientNom,
    required super.prixTotal,
    required super.dateCreation,
    required super.statutFacture,
  });

  factory ClientInvoiceModel.fromJson(Map<String, dynamic> json) {
    return ClientInvoiceModel(
      id: (json['id'] ?? '').toString(),
      code: (json['code'] ?? json['no_references'] ?? '').toString(),
      clientNom: (json['client_nom'] ?? json['nom_occupant'] ?? 'Client SRA').toString(),
      prixTotal: double.tryParse((json['prix_total'] ?? json['price'] ?? 0.0).toString()) ?? 0.0,
      dateCreation: (json['date_creation'] ?? json['create_at'] ?? '').toString(),
      statutFacture: (json['statut_facture'] ?? json['status'] ?? 'EN_ATTENTE').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'client_nom': clientNom,
      'prix_total': prixTotal,
      'date_creation': dateCreation,
      'statut_facture': statutFacture,
    };
  }
}
