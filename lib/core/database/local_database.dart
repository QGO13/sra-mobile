import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' show sqfliteFfiInit, databaseFactoryFfi;
import 'package:path/path.dart';

class LocalDatabase {
  static Database? _database;

  Future<Database?> get database async {
    if (kIsWeb) return null;
    if (_database != null) return _database!;
    _database = await _initDatabase();
    await _database?.execute('CREATE TABLE IF NOT EXISTS api_cache (key TEXT PRIMARY KEY, value TEXT)');
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'sra_hotel.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // 1. Personne (Données Communes)
    await db.execute('''
      CREATE TABLE personne (
        id_personne TEXT PRIMARY KEY,
        nom TEXT,
        prenoms TEXT,
        telephone TEXT,
        email TEXT UNIQUE,
        sexe TEXT,
        pays TEXT,
        adresse TEXT
      )
    ''');

    // 2. Users (Comptes Applicatifs)
    await db.execute('''
      CREATE TABLE users (
        id_user TEXT PRIMARY KEY REFERENCES personne(id_personne) ON DELETE CASCADE,
        login TEXT UNIQUE,
        password TEXT,
        is_active INTEGER DEFAULT 1,
        role TEXT
      )
    ''');

    // 3. Company (Profils Corporate & Agences)
    await db.execute('''
      CREATE TABLE company (
        id_company TEXT PRIMARY KEY,
        login_comp TEXT UNIQUE,
        password_comp TEXT,
        is_externe INTEGER DEFAULT 0
      )
    ''');

    // 4. Employer (Relation Company <-> Personne)
    await db.execute('''
      CREATE TABLE employer (
        id_company TEXT REFERENCES company(id_company) ON DELETE CASCADE,
        id_personne TEXT REFERENCES personne(id_personne) ON DELETE CASCADE,
        PRIMARY KEY (id_company, id_personne)
      )
    ''');

    // 5. Type_de_Chambre
    await db.execute('''
      CREATE TABLE type_de_chambre (
        id_type_de_chambre INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT,
        prix_nuit REAL,
        capacite INTEGER,
        description TEXT
      )
    ''');

    // 6. Chambres (Le Parc de 42 Chambres)
    await db.execute('''
      CREATE TABLE chambres (
        id_chambre INTEGER PRIMARY KEY,
        numero TEXT UNIQUE,
        id_type_de_chambre INTEGER REFERENCES type_de_chambre(id_type_de_chambre) ON DELETE SET NULL,
        statut TEXT
      )
    ''');

    // 7. Images_Chambres
    await db.execute('''
      CREATE TABLE images_chambres (
        id_images_chambres TEXT PRIMARY KEY,
        id_type_de_chambre INTEGER REFERENCES type_de_chambre(id_type_de_chambre) ON DELETE CASCADE,
        nom TEXT,
        url TEXT
      )
    ''');

    // 8. Reservations
    await db.execute('''
      CREATE TABLE reservations (
        id_reservation TEXT PRIMARY KEY,
        id_user TEXT REFERENCES users(id_user) ON DELETE SET NULL,
        numero_reservation TEXT UNIQUE,
        check_in TEXT,
        check_out TEXT,
        nom_occupant TEXT,
        statut TEXT
      )
    ''');

    // 9. Associer (Panier Multi-chambres)
    await db.execute('''
      CREATE TABLE associer (
        id_reservation TEXT REFERENCES reservations(id_reservation) ON DELETE CASCADE,
        id_chambre INTEGER REFERENCES chambres(id_chambre) ON DELETE CASCADE,
        prix_applique REAL,
        extra_bed_included INTEGER DEFAULT 0,
        PRIMARY KEY (id_reservation, id_chambre)
      )
    ''');

    // 10. Folio (Dossier Financier Global)
    await db.execute('''
      CREATE TABLE folio (
        id_folio TEXT PRIMARY KEY,
        id_reservation TEXT REFERENCES reservations(id_reservation) ON DELETE SET NULL,
        create_at TEXT,
        prix_total REAL DEFAULT 0.00,
        statut TEXT
      )
    ''');

    // 11. Moyens_de_paiements
    await db.execute('''
      CREATE TABLE moyens_de_paiements (
        id_moyens INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT,
        numero TEXT,
        staut TEXT
      )
    ''');

    // 12. Lignes_folio (Facturation DGI et extras)
    await db.execute('''
      CREATE TABLE lignes_folio (
        id_lignes_folio TEXT PRIMARY KEY,
        id_folio TEXT REFERENCES folio(id_folio) ON DELETE CASCADE,
        statut_payement TEXT,
        create_at TEXT,
        date_payement TEXT,
        prix REAL,
        id_moyens INTEGER REFERENCES moyens_de_paiements(id_moyens) ON DELETE SET NULL
      )
    ''');

    // 13. Equipements (Inventaires)
    await db.execute('''
      CREATE TABLE equipements (
        id_equipement INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT,
        etat TEXT,
        total_equipements INTEGER
      )
    ''');

    // 14. Detenir (Dotation des chambres)
    await db.execute('''
      CREATE TABLE detenir (
        id_chambre INTEGER REFERENCES chambres(id_chambre) ON DELETE CASCADE,
        id_equipement INTEGER REFERENCES equipements(id_equipement) ON DELETE CASCADE,
        quantite INTEGER DEFAULT 1,
        PRIMARY KEY (id_chambre, id_equipement)
      )
    ''');

    // 15. Synchronisation Queue Table for Offline-first operations
    await db.execute('''
      CREATE TABLE sync_queue (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        table_name TEXT,
        action_type TEXT, -- 'INSERT', 'UPDATE', 'DELETE'
        record_id TEXT,
        payload TEXT, -- JSON serialization
        sync_status INTEGER DEFAULT 0 -- 0 = FALSE, 1 = TRUE
      )
    ''');
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
    }
  }
}

