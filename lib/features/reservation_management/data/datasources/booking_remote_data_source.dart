import 'dart:convert';
import 'package:sra_hotel/core/network/api_client.dart';
import 'package:sra_hotel/core/network/api_cache.dart';
import 'package:sra_hotel/features/reservation_management/data/models/booking_model.dart';

abstract class BookingRemoteDataSource {
  Future<List<BookingModel>> getBookings();
  Future<BookingModel> updateBooking(BookingModel booking);
  Future<void> cancelBooking(String id);
  Future<BookingModel> updateBookingLine(String bookingId, String lineId, {required double price});
  Future<BookingModel> applyGlobalDiscount(String bookingId, {required double discountPercentage});
  Future<void> payBooking(String bookingId, {required double amount, required String paymentMethod});
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final ApiClient apiClient;
  final ApiCache apiCache;

  BookingRemoteDataSourceImpl({required this.apiClient, required this.apiCache});

  @override
  Future<List<BookingModel>> getBookings() async {
    final account = await _fetchCurrentAccount();
    final role = _extractRole(account);
    final accountId = account['id'] as String?;

    if (_isAdminScope(role)) {
      return _fetchBookings('/reservation/');
    }

    // Pour le volet client, on utilise uniquement l'endpoint du compte connecté.
    try {
      return await _fetchBookings('/me/reservations');
    } catch (_) {
      // On tente ensuite l'alias compte quand il existe.
    }

    if (accountId != null) {
      try {
        return await _fetchBookings('/accounts/$accountId/reservations');
      } catch (_) {
        // On évite volontairement tout repli vers la route admin.
      }
    }

    throw Exception('Unable to load client reservations');
  }

  Future<List<BookingModel>> _fetchBookings(String path) async {
    final cacheKey = 'bookings_${path.replaceAll('/', '_')}';
    try {
      final response = await apiClient.get(path, queryParameters: {'limit': 100});
      if (response.statusCode == 200) {
        await apiCache.save(cacheKey, jsonEncode(response.data));
        final Map<String, dynamic> body = response.data as Map<String, dynamic>;
        final List<dynamic> data = body['data'] as List<dynamic>;
        return data.map((json) => BookingModel.fromJson(json as Map<String, dynamic>)).toList();
      }
      throw Exception('Server Error : ${response.statusMessage}');
    } catch (e) {
      final cachedStr = await apiCache.get(cacheKey);
      if (cachedStr != null) {
        final decoded = jsonDecode(cachedStr) as Map<String, dynamic>;
        final List<dynamic> data = decoded['data'] as List<dynamic>;
        return data.map((json) => BookingModel.fromJson(json as Map<String, dynamic>)).toList();
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _fetchCurrentAccount() async {
    try {
      final response = await apiClient.get('/accounts/me');
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
    } catch (_) {
      // Ignore and fall back to the client flow.
    }
    return const <String, dynamic>{};
  }

  String _extractRole(Map<String, dynamic> account) {
    return (account['role'] ?? '').toString().toLowerCase();
  }

  bool _isAdminScope(String role) {
    return role.contains('admin') || role.contains('reception');
  }

  @override
  Future<BookingModel> updateBooking(BookingModel booking) async {
    final response = await apiClient.dio.patch('/reservation/${booking.id}', data: {
      'status': booking.statutBooking,
    });
    return BookingModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> cancelBooking(String id) async {
    await apiClient.post('/reservation/$id/cancel');
  }

  @override
  Future<BookingModel> updateBookingLine(String bookingId, String lineId, {required double price}) async {
    final response = await apiClient.dio.patch(
      '/reservation/$bookingId/reservation-line/$lineId',
      data: {'price': price},
    );
    return BookingModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<BookingModel> applyGlobalDiscount(String bookingId, {required double discountPercentage}) async {
    final response = await apiClient.dio.patch(
      '/reservation/$bookingId',
      data: {'discount_percentage': discountPercentage},
    );
    return BookingModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> payBooking(String bookingId, {required double amount, required String paymentMethod}) async {
    // Simuler le paiement réseau (le backend n'a pas de route /pay)
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
