import 'package:sra_hotel/features/backoffice_kpis/domain/entities/history_data.dart';

class HistoryModel extends HistoryData {
  HistoryModel({
    required super.labels,
    required super.revenue,
    required super.occupancy,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      labels: List<String>.from(json['labels'] as List),
      revenue: (json['revenue'] as List).map((e) => (e as num).toDouble()).toList(),
      occupancy: (json['occupancy'] as List).map((e) => (e as num).toDouble()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'labels': labels,
      'revenue': revenue,
      'occupancy': occupancy,
    };
  }
}
