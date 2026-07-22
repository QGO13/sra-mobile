class ClientInvoice {
  final String id;
  final String code;
  final String clientNom;
  final double prixTotal;
  final String dateCreation;
  final String statutFacture;

  ClientInvoice({
    required this.id,
    required this.code,
    required this.clientNom,
    required this.prixTotal,
    required this.dateCreation,
    required this.statutFacture,
  });
}
