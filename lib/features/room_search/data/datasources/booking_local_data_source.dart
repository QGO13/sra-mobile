import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sra_hotel/core/database/local_database.dart';
import 'package:sra_hotel/features/room_search/data/models/room_model.dart';

abstract class BookingLocalDataSource {
  Future<void> cacheAvailableRooms(List<RoomModel> rooms);
  Future<List<RoomModel>> getCachedAvailableRooms();
}

class BookingLocalDataSourceImpl implements BookingLocalDataSource {
  final LocalDatabase localDatabase;

  BookingLocalDataSourceImpl({required this.localDatabase});

  @override
  Future<void> cacheAvailableRooms(List<RoomModel> rooms) async {
    if (kIsWeb) return;
    final db = await localDatabase.database;
    if (db == null) return;
    await db.transaction((txn) async {
      for (var room in rooms) {
        // Insert category if it does not exist
        await txn.insert(
          'type_de_chambre',
          {
            'id_type_de_chambre': room.idTypeDeChambre,
            'nom': room.categoryName,
            'prix_nuit': room.prixNuit,
            'capacite': (room.idTypeDeChambre.contains('suite') || room.idTypeDeChambre == '3' || room.idTypeDeChambre == '24') ? 4 : 2,
            'description': '${room.categoryName} category room',
          },
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );

        // Insert or replace room details
        await txn.insert(
          'chambres',
          {
            'id_chambre': room.id,
            'numero': room.numero,
            'id_type_de_chambre': room.idTypeDeChambre,
            'statut': room.statut,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  @override
  Future<List<RoomModel>> getCachedAvailableRooms() async {
    if (kIsWeb) return [];
    final db = await localDatabase.database;
    if (db == null) return [];
    
    // Joint query to retrieve complete room details including pricing
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT c.id_chambre, c.numero, c.id_type_de_chambre, c.statut, t.prix_nuit
      FROM chambres c
      LEFT JOIN type_de_chambre t ON c.id_type_de_chambre = t.id_type_de_chambre
      WHERE c.statut = 'prêt'
    ''');

    return maps.map((map) => RoomModel.fromJson(map)).toList();
  }
}

