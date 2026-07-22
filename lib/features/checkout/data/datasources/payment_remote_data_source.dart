import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sra_hotel/core/network/api_client.dart';
import 'package:sra_hotel/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:sra_hotel/features/cart/presentation/bloc/cart_state.dart';

abstract class PaymentRemoteDataSource {
  Future<Map<String, dynamic>> initiatePayment({
    required double amount,
    required String phone,
    required String operator,
    required String email,
    required String clientName,
    String? targetUserId,
  });

  Future<Map<String, dynamic>> getPaymentStatus(String transactionId);
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final ApiClient apiClient;

  PaymentRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<Map<String, dynamic>> initiatePayment({
    required double amount,
    required String phone,
    required String operator,
    required String email,
    required String clientName,
    String? targetUserId,
  }) async {
    try {
      String userId;
      if (targetUserId != null) {
        userId = targetUserId;
      } else {
        // 1. Récupérer le compte connecté pour obtenir l'ID de l'utilisateur (user_id)
        final meResponse = await apiClient.get('/accounts/me');
        if (meResponse.statusCode != 200) {
          throw Exception('Impossible de récupérer l\'utilisateur connecté');
        }
        final meData = meResponse.data as Map<String, dynamic>;
        userId = (meData['user']['id'] ?? '').toString();
      }

      // 2. Récupérer le panier pour construire la réservation
      final cartBloc = GetIt.instance<CartBloc>();
      final cartState = cartBloc.state;
      if (cartState is! CartUpdated) {
        throw Exception('Le panier est vide ou non initialisé');
      }

      final checkInStr = cartState.items.first.checkIn.toIso8601String().split('T').first;
      final checkOutStr = cartState.items.first.checkOut.toIso8601String().split('T').first;

      // Regrouper les chambres par room_type_id
      final Map<String, int> roomTypeCounts = {};
      for (var item in cartState.items) {
        final typeId = item.room.idTypeDeChambre;
        roomTypeCounts[typeId] = (roomTypeCounts[typeId] ?? 0) + 1;
      }
      final roomTypesList = roomTypeCounts.entries.map((e) => {
        'room_type_id': e.key,
        'count': e.value,
        'occupant_names': <String>[], // Fournir une liste vide pour correspondre au type attendu
      }).toList();

      // 3. Créer la réservation sur le serveur FastAPI
      final resResponse = await apiClient.dio.post(
        '/reservation/',
        data: {
          'user_id': userId,
          'check_in': checkInStr,
          'check_out': checkOutStr,
          'room_types': roomTypesList,
        },
      );

      if (resResponse.statusCode == 201 || resResponse.statusCode == 200) {
        final resData = resResponse.data as Map<String, dynamic>;
        final resId = resData['id'].toString();
        
        return {
          'status': 'success',
          'transaction_id': 'tx_$resId',
          'message': 'Réservation créée avec succès sur le serveur',
        };
      } else {
        throw Exception('Erreur de réservation sur le serveur : ${resResponse.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e));
    }
  }

  @override
  Future<Map<String, dynamic>> getPaymentStatus(String transactionId) async {
    // Simuler le statut de succès immédiat
    return {
      'status': 'success',
      'transaction_id': transactionId,
    };
  }

  String _extractErrorMessage(DioException e) {
    if (e.response != null && e.response!.data != null) {
      final data = e.response!.data;
      if (data is Map<String, dynamic>) {
        if (data.containsKey('detail')) {
          final detail = data['detail'];
          if (detail is String) {
            return detail;
          } else if (detail is List) {
            final messages = detail.map((err) {
              if (err is Map<String, dynamic>) {
                final loc = err['loc'] as List?;
                final msg = err['msg'] as String?;
                final field = loc != null && loc.length > 1 ? loc[1] : '';
                if (field.isNotEmpty) {
                  return 'Champ "$field" : $msg';
                }
                return msg ?? 'Erreur de validation';
              }
              return err.toString();
            }).join('\n');
            return 'Erreurs de validation :\n$messages';
          }
        }
      }
    }
    
    if (e.response != null) {
      if (e.response!.statusCode == 422) {
        return 'Erreur 422 : Données de réservation invalides.';
      }
      return 'Erreur ${e.response!.statusCode} : ${e.response!.statusMessage ?? "Erreur serveur"}';
    }

    return e.message ?? 'Une erreur réseau est survenue.';
  }
}
