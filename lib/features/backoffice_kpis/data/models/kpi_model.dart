import 'package:sra_hotel/features/backoffice_kpis/domain/entities/kpi_data.dart';

class KpiModel extends KpiData {
  KpiModel({
    required super.caMensuel,
    required super.caDelta,
    required super.tauxOccupation,
    required super.tauxDelta,
    required super.revpar,
    required super.revparDelta,
    required super.panierMoyen,
    required super.panierDelta,
  });

  factory KpiModel.fromJson(Map<String, dynamic> json) {
    return KpiModel(
      caMensuel: (json['ca_mensuel'] as num).toDouble(),
      caDelta: json['ca_delta'] as String,
      tauxOccupation: (json['taux_occupation'] as num).toDouble(),
      tauxDelta: json['taux_delta'] as String,
      revpar: (json['revpar'] as num).toDouble(),
      revparDelta: json['revpar_delta'] as String,
      panierMoyen: (json['panier_moyen'] as num).toDouble(),
      panierDelta: json['panier_delta'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ca_mensuel': caMensuel,
      'ca_delta': caDelta,
      'taux_occupation': tauxOccupation,
      'taux_delta': tauxDelta,
      'revpar': revpar,
      'revpar_delta': revparDelta,
      'panier_moyen': panierMoyen,
      'panier_delta': panierDelta,
    };
  }
}
