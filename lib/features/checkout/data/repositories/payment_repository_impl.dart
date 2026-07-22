import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sra_hotel/core/database/local_database.dart';
import 'package:sra_hotel/features/checkout/data/datasources/payment_remote_data_source.dart';
import 'package:sra_hotel/features/checkout/domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;
  final LocalDatabase localDatabase;

  PaymentRepositoryImpl({
    required this.remoteDataSource,
    required this.localDatabase,
  });

  @override
  Future<Map<String, dynamic>> initiatePayment({
    required double amount,
    required String phone,
    required String operator,
    required String email,
    required String clientName,
  }) async {
    return await remoteDataSource.initiatePayment(
      amount: amount,
      phone: phone,
      operator: operator,
      email: email,
      clientName: clientName,
    );
  }

  @override
  Future<bool> verifyPaymentStatus(String transactionId) async {
    final statusData = await remoteDataSource.getPaymentStatus(transactionId);
    final status = statusData['status']?.toString().toLowerCase();
    
    final isApproved = status == 'approved' || status == 'success';
    
    if (isApproved) {
      // Local SQLite persistence on payment approval
      await _saveInvoiceAndReservationLocally(transactionId, statusData);
    }
    
    return isApproved;
  }

  Future<void> _saveInvoiceAndReservationLocally(
    String transactionId, 
    Map<String, dynamic> statusData,
  ) async {
    if (kIsWeb) return;
    
    try {
      final db = await localDatabase.database;
      if (db == null) return;

      final nowStr = DateTime.now().toIso8601String();
      
      await db.transaction((txn) async {
        // 1. Insert reservation
        final reservationId = 'res_$transactionId';
        final resNo = 'RES-${transactionId.substring(transactionId.length - 6).toUpperCase()}';
        
        await txn.insert(
          'reservations',
          {
            'id_reservation': reservationId,
            'id_user': null, // Set null as user is already authenticated remotely
            'numero_reservation': resNo,
            'check_in': nowStr,
            'check_out': nowStr,
            'nom_occupant': 'Client SRA',
            'statut': 'confirmée',
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        // 2. Insert folio
        final folioId = 'folio_$transactionId';
        await txn.insert(
          'folio',
          {
            'id_folio': folioId,
            'id_reservation': reservationId,
            'create_at': nowStr,
            'prix_total': 0.0,
            'statut': 'payé',
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        // 3. Insert lignes_folio
        await txn.insert(
          'lignes_folio',
          {
            'id_lignes_folio': 'line_$transactionId',
            'id_folio': folioId,
            'statut_payement': 'payé',
            'create_at': nowStr,
            'date_payement': nowStr,
            'prix': 0.0,
            'id_moyens': 1,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        // 4. Queue synchronization event
        await txn.insert(
          'sync_queue',
          {
            'table_name': 'reservations',
            'action_type': 'INSERT',
            'record_id': reservationId,
            'payload': '{"transaction_id": "$transactionId", "status": "approved"}',
            'sync_status': 0,
          },
        );
      });
    } catch (e) {
      // Gracefully catch local database errors in testing/development environments
      debugPrint("Erreur lors de l'enregistrement local de la facture : $e");
    }
  }
}

