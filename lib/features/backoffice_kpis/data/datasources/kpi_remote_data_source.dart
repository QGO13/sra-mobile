import 'dart:convert';
import 'package:sra_hotel/core/network/api_client.dart';
import 'package:sra_hotel/core/network/api_cache.dart';
import 'package:intl/intl.dart';
import 'package:sra_hotel/features/reservation_management/data/models/booking_model.dart';
import 'package:sra_hotel/features/backoffice_kpis/data/models/kpi_model.dart';
import 'package:sra_hotel/features/backoffice_kpis/data/models/history_model.dart';

class _KpiSourceSnapshot {
  final List<BookingModel> reservations;
  final int roomCount;

  const _KpiSourceSnapshot({required this.reservations, required this.roomCount});
}

abstract class KpiRemoteDataSource {
  Future<KpiModel> getKpis();
  Future<HistoryModel> getHistory();
}

class KpiRemoteDataSourceImpl implements KpiRemoteDataSource {
  final ApiClient apiClient;
  final ApiCache apiCache;

  KpiRemoteDataSourceImpl({required this.apiClient, required this.apiCache});

  @override
  Future<KpiModel> getKpis() async {
    final snapshot = await _loadSnapshot();
    final currentMonth = DateTime.now();
    final previousMonth = DateTime(currentMonth.year, currentMonth.month - 1, 1);

    final currentReservations = _reservationsForMonth(snapshot.reservations, currentMonth);
    final previousReservations = _reservationsForMonth(snapshot.reservations, previousMonth);

    final currentRevenue = _revenueForReservations(currentReservations);
    final previousRevenue = _revenueForReservations(previousReservations);
    final currentCount = currentReservations.length;
    final previousCount = previousReservations.length;
    final roomCount = snapshot.roomCount > 0 ? snapshot.roomCount : 1;

    final occupancyRate = (currentCount / roomCount) * 100;
    final previousOccupancyRate = (previousCount / roomCount) * 100;

    return KpiModel(
      caMensuel: currentRevenue,
      caDelta: _formatDelta(currentRevenue, previousRevenue),
      tauxOccupation: occupancyRate.clamp(0, 100),
      tauxDelta: _formatDelta(occupancyRate, previousOccupancyRate),
      revpar: currentRevenue / roomCount,
      revparDelta: _formatDelta(currentRevenue / roomCount, previousRevenue / roomCount),
      panierMoyen: currentCount > 0 ? currentRevenue / currentCount : 0,
      panierDelta: _formatDelta(
        currentCount > 0 ? currentRevenue / currentCount : 0,
        previousCount > 0 ? previousRevenue / previousCount : 0,
      ),
    );
  }

  @override
  Future<HistoryModel> getHistory() async {
    final snapshot = await _loadSnapshot();
    final months = List.generate(6, (index) {
      return DateTime(DateTime.now().year, DateTime.now().month - 5 + index, 1);
    });

    final labels = months.map((month) => DateFormat('MMM', 'fr_FR').format(month)).toList();
    final revenue = months
        .map((month) => _revenueForReservations(_reservationsForMonth(snapshot.reservations, month)))
        .toList();
    final occupancy = months
        .map((month) {
          final monthReservations = _reservationsForMonth(snapshot.reservations, month);
          return snapshot.roomCount > 0 ? (monthReservations.length / snapshot.roomCount) * 100 : 0;
        })
        .map((value) => value.toDouble())
        .toList();

    return HistoryModel(
      labels: labels,
      revenue: revenue,
      occupancy: occupancy,
    );
  }

  Future<_KpiSourceSnapshot> _loadSnapshot() async {
    final reservations = await _loadReservations();
    final roomCount = await _countItems('/rooms/');
    return _KpiSourceSnapshot(reservations: reservations, roomCount: roomCount);
  }

  Future<List<BookingModel>> _loadReservations() async {
    try {
      final response = await apiClient.get('/reservation/', queryParameters: {'limit': 100});
      if (response.statusCode == 200) {
        await apiCache.save('kpi_reservations', jsonEncode(response.data));
        final body = response.data as Map<String, dynamic>;
        final data = body['data'] as List<dynamic>;
        return data.map((json) => BookingModel.fromJson(json as Map<String, dynamic>)).toList();
      }
      throw Exception('Server Error : ${response.statusMessage}');
    } catch (e) {
      final cachedStr = await apiCache.get('kpi_reservations');
      if (cachedStr != null) {
        final decoded = jsonDecode(cachedStr) as Map<String, dynamic>;
        final data = decoded['data'] as List<dynamic>;
        return data.map((json) => BookingModel.fromJson(json as Map<String, dynamic>)).toList();
      }
      rethrow;
    }
  }

  Future<int> _countItems(String path) async {
    final cacheKey = 'kpi_count_${path.replaceAll('/', '_')}';
    try {
      final response = await apiClient.get(path, queryParameters: {'limit': 100});
      if (response.statusCode == 200) {
        await apiCache.save(cacheKey, jsonEncode(response.data));
        final body = response.data as Map<String, dynamic>;
        return (body['total'] as num?)?.toInt() ?? 0;
      }
      return 0;
    } catch (e) {
      final cachedStr = await apiCache.get(cacheKey);
      if (cachedStr != null) {
        final decoded = jsonDecode(cachedStr) as Map<String, dynamic>;
        return (decoded['total'] as num?)?.toInt() ?? 0;
      }
      rethrow;
    }
  }

  List<BookingModel> _reservationsForMonth(List<BookingModel> reservations, DateTime month) {
    return reservations.where((reservation) {
      final checkIn = DateTime.tryParse(reservation.checkIn);
      if (checkIn == null) {
        return false;
      }
      return checkIn.year == month.year && checkIn.month == month.month;
    }).toList();
  }

  double _revenueForReservations(List<BookingModel> reservations) {
    return reservations.fold<double>(0, (sum, reservation) => sum + reservation.prixTotal);
  }

  String _formatDelta(double current, double previous) {
    if (previous == 0) {
      if (current == 0) {
        return '0%';
      }
      return '+100%';
    }
    final delta = ((current - previous) / previous) * 100;
    final rounded = delta.abs().toStringAsFixed(0);
    return '${delta >= 0 ? '+' : '-'}$rounded%';
  }
}
