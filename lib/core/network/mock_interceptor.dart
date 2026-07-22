import 'package:dio/dio.dart';

// In-memory collections to maintain backoffice state across requests
List<Map<String, dynamic>>? _mockServices;
List<Map<String, dynamic>>? _mockRooms;
List<Map<String, dynamic>>? _mockRoomTypes;
List<Map<String, dynamic>>? _mockUsers;
List<Map<String, dynamic>>? _mockBookings;
List<Map<String, dynamic>>? _mockInvoices;
List<Map<String, dynamic>>? _mockArrivees;
List<Map<String, dynamic>>? _mockDeparts;
List<Map<String, dynamic>>? _mockEquipments;

void _initializeMocksIfNeeded() {
  _mockEquipments ??= [
    { "id": 1, "name": "Climatiseur", "description": "Climatisation split performante", "status": "AVAILABLE" },
    { "id": 2, "name": "Téléviseur 4K", "description": "Téléviseur LED connecté 55 pouces", "status": "AVAILABLE" },
    { "id": 3, "name": "Mini-bar", "description": "Réfrigérateur garni de boissons fraîches", "status": "AVAILABLE" },
  ];
  _mockRoomTypes ??= [
    {
      "id_type_de_chambre": 1,
      "nom": "Chambre Standard",
      "prix_nuit": 60000.0,
      "capacite": 2,
      "description": "Chambre élégante et fonctionnelle, équipée d'un lit Queen size, espace bureau et Wi-Fi haut débit.",
      "images": ["https://images.unsplash.com/photo-1631049552057-403cdb8f0658?w=800&q=80"]
    },
    {
      "id_type_de_chambre": 2,
      "nom": "Chambre Premium",
      "prix_nuit": 85000.0,
      "capacite": 2,
      "description": "Chambre spacieuse avec coin salon, machine espresso, lit King size et baignoire relaxante.",
      "images": ["https://images.unsplash.com/photo-1618773928121-c32242e63f39?w=800&q=80"]
    },
    {
      "id_type_de_chambre": 3,
      "nom": "Suite",
      "prix_nuit": 150000.0,
      "capacite": 4,
      "description": "Notre suite haut de gamme disposant d'un salon séparé, service de majordome sur demande et terrasse panoramique.",
      "images": ["https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800&q=80"]
    },
  ];

  _mockRooms ??= [
    { "id_chambre": 1, "numero": "101", "id_type_de_chambre": 1, "type": "Chambre Standard", "etage": 1, "statut_menage": "PROPRE", "est_active": 1, "occupee": 0 },
    { "id_chambre": 2, "numero": "102", "id_type_de_chambre": 1, "type": "Chambre Standard", "etage": 1, "statut_menage": "SALE", "est_active": 1, "occupee": 0 },
    { "id_chambre": 3, "numero": "103", "id_type_de_chambre": 2, "type": "Chambre Premium", "etage": 1, "statut_menage": "PROPRE", "est_active": 1, "occupee": 1, "client_actuel": "M. Konan" },
    { "id_chambre": 4, "numero": "104", "id_type_de_chambre": 2, "type": "Chambre Premium", "etage": 1, "statut_menage": "EN_COURS", "est_active": 1, "occupee": 0 },
    { "id_chambre": 5, "numero": "105", "id_type_de_chambre": 1, "type": "Chambre Standard", "etage": 1, "statut_menage": "PROPRE", "est_active": 1, "occupee": 1, "client_actuel": "M. Traoré I." },
    { "id_chambre": 6, "numero": "106", "id_type_de_chambre": 1, "type": "Chambre Standard", "etage": 1, "statut_menage": "MAINTENANCE", "est_active": 0, "occupee": 0 },
    { "id_chambre": 7, "numero": "112", "id_type_de_chambre": 2, "type": "Chambre Premium", "etage": 1, "statut_menage": "PROPRE", "est_active": 1, "occupee": 1, "client_actuel": "Mme Ouattara" },
    { "id_chambre": 8, "numero": "201", "id_type_de_chambre": 2, "type": "Chambre Premium", "etage": 2, "statut_menage": "PROPRE", "est_active": 1, "occupee": 0 },
    { "id_chambre": 9, "numero": "202", "id_type_de_chambre": 2, "type": "Chambre Premium", "etage": 2, "statut_menage": "SALE", "est_active": 1, "occupee": 0 },
    { "id_chambre": 10, "numero": "203", "id_type_de_chambre": 1, "type": "Chambre Standard", "etage": 2, "statut_menage": "PROPRE", "est_active": 1, "occupee": 0 },
    { "id_chambre": 11, "numero": "204", "id_type_de_chambre": 3, "type": "Suite", "etage": 2, "statut_menage": "PROPRE", "est_active": 1, "occupee": 1, "client_actuel": "Mme Traoré I." },
    { "id_chambre": 12, "numero": "205", "id_type_de_chambre": 3, "type": "Suite", "etage": 2, "statut_menage": "EN_COURS", "est_active": 1, "occupee": 0 },
    { "id_chambre": 13, "numero": "215", "id_type_de_chambre": 2, "type": "Chambre Premium", "etage": 2, "statut_menage": "PROPRE", "est_active": 1, "occupee": 1, "client_actuel": "M. Bamba" },
  ];

  _mockServices ??= [
    {
      "id": 1,
      "nom": "Petit-déjeuner Continental",
      "categorie": "RESTAURATION",
      "description": "Viennoiseries fraîches, jus de fruits, café ou thé, fruits tropicaux de saison.",
      "prix_unitaire": 8500.0,
      "est_disponible": true,
      "photo": "https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?w=600&q=80",
    },
    {
      "id": 2,
      "nom": "Menu du Chef — Midi",
      "categorie": "RESTAURATION",
      "description": "Entrée + plat + dessert élaborés par notre chef. Cuisine ivoirienne revisitée.",
      "prix_unitaire": 22000.0,
      "est_disponible": true,
      "photo": "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600&q=80",
    },
    {
      "id": 3,
      "nom": "Plateau Apéritif",
      "categorie": "RESTAURATION",
      "description": "Assortiment de fromages, charcuteries fines, crackers et crudités.",
      "prix_unitaire": 15000.0,
      "est_disponible": true,
      "photo": "https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=600&q=80",
    },
    {
      "id": 4,
      "nom": "Massage Relaxant 60 min",
      "categorie": "SPA",
      "description": "Massage aux huiles essentielles pour un relâchement total des tensions.",
      "prix_unitaire": 45000.0,
      "est_disponible": true,
      "photo": "https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=600&q=80",
    },
    {
      "id": 5,
      "nom": "Transfert Aéroport",
      "categorie": "VEHICULE",
      "description": "Véhicule climatisé avec chauffeur privé. Aéroport Félix Houphouët-Boigny.",
      "prix_unitaire": 25000.0,
      "est_disponible": true,
      "photo": "https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?w=600&q=80",
    },
  ];

  _mockUsers ??= [
    { "id": "admin-id-1234", "login": "admin@sra-hotel.com", "role": "admin", "nom": "Koné", "prenoms": "Mamadou", "telephone": "+2250701010101", "sexe": "M", "pays": "Côte d'Ivoire", "adresse": "Abidjan, Cocody", "is_active": 1 },
    { "id": "reception-id-5678", "login": "reception@sra-hotel.com", "role": "reception", "nom": "Diabaté", "prenoms": "Fatou", "telephone": "+2250702020202", "sexe": "F", "pays": "Côte d'Ivoire", "adresse": "Abidjan, Plateau", "is_active": 1 },
    { "id": "menage-id-9012", "login": "menage@sra-hotel.com", "role": "menage", "nom": "Coulibaly", "prenoms": "Aminata", "telephone": "+2250703030303", "sexe": "F", "pays": "Côte d'Ivoire", "adresse": "Abidjan, Marcory", "is_active": 1 },
    { "id": "client-id-3456", "login": "client@sra-hotel.com", "role": "client", "nom": "Traoré", "prenoms": "Ibrahima", "telephone": "+2250704040404", "sexe": "M", "pays": "Côte d'Ivoire", "adresse": "Abidjan, Yopougon", "is_active": 1 },
  ];
  final now = DateTime.now();
  final todayStr = now.toIso8601String().split('T').first;
  final yesterdayStr = now.subtract(const Duration(days: 1)).toIso8601String().split('T').first;
  final tomorrowStr = now.add(const Duration(days: 1)).toIso8601String().split('T').first;
  final dayAfterTomorrowStr = now.add(const Duration(days: 2)).toIso8601String().split('T').first;
  final day3LaterStr = now.add(const Duration(days: 3)).toIso8601String().split('T').first;
  final day6LaterStr = now.add(const Duration(days: 6)).toIso8601String().split('T').first;
  final day7LaterStr = now.add(const Duration(days: 7)).toIso8601String().split('T').first;

  _mockBookings ??= [
    {
      "id_reservation": "res-1",
      "numero_reservation": "SRA-20260610-001",
      "statut": "CONFIRMEE",
      "date_creation": "2026-06-10T14:32:00",
      "prix_total": 290000.0,
      "contact_nom": "Traoré",
      "contact_email": "client@sra-hotel.com",
      "contact_telephone": "+225 07 12 34 56",
      "check_in": yesterdayStr,
      "check_out": dayAfterTomorrowStr,
      "lignes": [
        {
          "chambre_id": 11,
          "chambre_numero": "204",
          "type_chambre": "Suite",
          "check_in": yesterdayStr,
          "check_out": dayAfterTomorrowStr,
          "adultes": 2,
          "enfants": 0,
          "prix_unitaire_nuit": 130000.0,
          "prix_total_ligne": 260000.0
        }
      ]
    },
    {
      "id_reservation": "res-2",
      "numero_reservation": "SRA-20260520-007",
      "statut": "TERMINEE",
      "date_creation": "2026-05-20T09:15:00",
      "prix_total": 360000.0,
      "contact_nom": "Traoré",
      "contact_email": "client@sra-hotel.com",
      "contact_telephone": "+225 07 12 34 56",
      "check_in": day3LaterStr,
      "check_out": day6LaterStr,
      "lignes": [
        {
          "chambre_id": 13,
          "chambre_numero": "215",
          "type_chambre": "Chambre Premium",
          "check_in": day3LaterStr,
          "check_out": day6LaterStr,
          "adultes": 3,
          "enfants": 1,
          "prix_unitaire_nuit": 180000.0,
          "prix_total_ligne": 360000.0
        }
      ]
    }
  ];

  _mockInvoices ??= [
    { "id_folio": "inv-1", "reference": "FAC-20260710-01", "client_nom": "Ibrahima Traoré", "client_email": "client@sra-hotel.com", "id_reservation": "res-1", "prix_total": 290000.0, "statut": "PAYE", "create_at": "2026-07-10T11:00:00" },
    { "id_folio": "inv-2", "reference": "FAC-20260603-04", "client_nom": "Ibrahima Traoré", "client_email": "client@sra-hotel.com", "id_reservation": "res-2", "prix_total": 360000.0, "statut": "PAYE", "create_at": "2026-06-03T10:00:00" },
  ];

  _mockArrivees ??= [
    { "id": 1, "reference": "SRA-20260618-023", "client_nom": "M. Diallo Sékou", "type_chambre": "Suite", "chambre_attribuee": null, "check_in": todayStr, "check_out": dayAfterTomorrowStr, "adultes": 2, "enfants": 0, "statut_checkin": "EN_ATTENTE" },
    { "id": 2, "reference": "SRA-20260618-024", "client_nom": "Mme Koné Adjoua", "type_chambre": "Chambre Premium", "chambre_attribuee": "201", "check_in": todayStr, "check_out": tomorrowStr, "adultes": 1, "enfants": 0, "statut_checkin": "EFFECTUE" },
    { "id": 3, "reference": "SRA-20260618-025", "client_nom": "Famille N'Guessan", "type_chambre": "Suite", "chambre_attribuee": null, "check_in": todayStr, "check_out": day7LaterStr, "adultes": 2, "enfants": 3, "statut_checkin": "EN_ATTENTE" },
  ];

  _mockDeparts ??= [
    { "id": 5, "reference": "SRA-20260614-018", "client_nom": "M. Sanogo Pierre", "type_chambre": "Chambre Premium", "chambre_attribuee": "103", "check_in": yesterdayStr, "check_out": todayStr, "statut_checkout": "EN_ATTENTE", "prix_total": 85000.0 },
    { "id": 6, "reference": "SRA-20260615-019", "client_nom": "Mme Touré Hawa", "type_chambre": "Suite", "chambre_attribuee": "204", "check_in": yesterdayStr, "check_out": todayStr, "statut_checkout": "EFFECTUE", "prix_total": 300000.0 },
  ];
}

class MockInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    const useMocks = bool.fromEnvironment('USE_MOCKS', defaultValue: false);
    
    if (!useMocks) {
      return handler.next(options); // Continue normally to the network
    }

    _initializeMocksIfNeeded();

    // Simulate network latency (400ms)
    await Future.delayed(const Duration(milliseconds: 400));

    final path = options.path;
    final method = options.method;

    Map<String, dynamic> mapToReadAccount(Map<String, dynamic> u) {
      final idStr = u['id'].toString().replaceAll('user-uuid-', '');
      final idInt = int.tryParse(idStr) ?? DateTime.now().millisecondsSinceEpoch;
      return {
        'id': idInt,
        'email': u['login'],
        'role': u['role'] ?? 'client',
        'is_active': u['is_active'] == 1 || u['is_active'] == true,
        'user_id': idInt * 10,
        'user': {
          'id': idInt * 10,
          'first_name': u['prenoms'] ?? '',
          'last_name': u['nom'] ?? '',
          'phone': u['telephone'] ?? '',
          'email': u['login'],
          'address': u['adresse'],
          'gender': u['sexe'],
          'country': u['pays'],
        }
      };
    }

    // A. /token or /auth/login
    if ((path.endsWith('/auth/login') || path.endsWith('/token')) && method == 'POST') {
      final String email;
      if (options.data is Map) {
        email = (options.data['email'] ?? options.data['username'] ?? 'admin@sra-hotel.com').toString();
      } else {
        email = 'admin@sra-hotel.com';
      }
      
      String role = 'client';
      if (email.contains('admin')) {
        role = 'admin';
      } else if (email.contains('reception')) {
        role = 'reception';
      } else if (email.contains('menage')) {
        role = 'menage';
      }

      final matchingUser = _mockUsers?.firstWhere(
        (u) => u['login'] == email,
        orElse: () => {
          "id": "8f4b5a31-6284-4e4b-91c2-1b1a1c1d1e1f",
          "login": email,
          "role": role,
          "nom": "Steward",
          "prenoms": "Rufus",
          "telephone": "+2250707070707",
          "sexe": "M",
          "pays": "Côte d'Ivoire",
          "adresse": "Abidjan, Cocody",
          "is_active": 1
        },
      );

      final responseData = {
        "access_token": "mock_jwt_token_${role}_12345",
        "token_type": "bearer",
        "user": matchingUser
      };

      return handler.resolve(
        Response(requestOptions: options, data: responseData, statusCode: 200),
      );
    }

    // B. /me or /accounts/me
    if ((path.endsWith('/accounts/me') || path.endsWith('/me')) && method == 'GET') {
      final authHeader = options.headers['Authorization'] as String?;
      String role = 'admin';
      if (authHeader != null) {
        if (authHeader.contains('reception')) role = 'reception';
        if (authHeader.contains('menage') || authHeader.contains('housekeeper')) role = 'housekeeper';
        if (authHeader.contains('client')) role = 'client';
      }
      final email = '$role@sra-hotel.com';
      final matchingUser = _mockUsers?.firstWhere(
        (u) => u['login'] == email,
        orElse: () => {
          "id": "8f4b5a31-6284-4e4b-91c2-1b1a1c1d1e1f",
          "login": email,
          "role": role == 'housekeeper' ? 'housekeeper' : role,
          "nom": "Steward",
          "prenoms": "Rufus",
          "telephone": "+2250707070707",
          "sexe": "M",
          "pays": "Côte d'Ivoire",
          "adresse": "Abidjan, Cocody",
          "is_active": 1
        },
      );
      return handler.resolve(
        Response(requestOptions: options, data: mapToReadAccount(matchingUser ?? const <String, dynamic>{}), statusCode: 200),
      );
    }

    // C. /me/account (PATCH)
    if (path.endsWith('/me/account') && method == 'PATCH') {
      final data = options.data as Map<String, dynamic>;
      final authHeader = options.headers['Authorization'] as String?;
      String role = 'admin';
      if (authHeader != null) {
        if (authHeader.contains('reception')) role = 'reception';
        if (authHeader.contains('menage') || authHeader.contains('housekeeper')) role = 'housekeeper';
        if (authHeader.contains('client')) role = 'client';
      }
      final email = '$role@sra-hotel.com';
      final index = _mockUsers?.indexWhere((u) => u['login'] == email) ?? -1;
      if (index != -1) {
        final u = _mockUsers![index];
        _mockUsers![index] = {
          ...u,
          if (data.containsKey('first_name')) 'prenoms': data['first_name'],
          if (data.containsKey('last_name')) 'nom': data['last_name'],
          if (data.containsKey('phone')) 'telephone': data['phone'],
          if (data.containsKey('address')) 'adresse': data['address'],
          if (data.containsKey('gender')) 'sexe': data['gender'],
          if (data.containsKey('country')) 'pays': data['country'],
          if (data.containsKey('email')) 'login': data['email'],
        };
        return handler.resolve(
          Response(requestOptions: options, data: mapToReadAccount(_mockUsers![index]), statusCode: 200),
        );
      }
    }

    // D. /me/reservations (GET)
    if (path.endsWith('/me/reservations') && method == 'GET') {
      final List<Map<String, dynamic>> mapped = _mockBookings?.map((b) {
        final idStr = b['id_reservation']?.toString() ?? '';
        final intId = int.tryParse(idStr.replaceAll('res-', '')) ?? 0;
        final List lignesList = b['lignes'] as List? ?? [];
        final firstLine = lignesList.isNotEmpty ? (lignesList.first as Map<String, dynamic>) : {};
        return {
          'id': intId,
          'id_reservation': b['id_reservation'],
          'no_references': b['numero_reservation'] ?? b['reference'],
          'reference': b['numero_reservation'] ?? b['reference'],
          'client_nom': b['contact_nom'] ?? b['client_nom'] ?? 'Client SRA',
          'type_chambre': firstLine['type_chambre'] ?? 'Chambre Standard',
          'check_in': b['check_in'],
          'check_out': b['check_out'],
          'adultes': firstLine['adultes'] ?? 1,
          'enfants': firstLine['enfants'] ?? 0,
          'status': b['statut'] ?? 'EN_ATTENTE',
          'statut_booking': b['statut'] ?? 'EN_ATTENTE',
          'prix_total': b['prix_total'],
          'reservation_lines': lignesList.map((l) {
            final lMap = l as Map<String, dynamic>;
            return {
              'id': lMap['chambre_id'] ?? 0,
              'price': lMap['prix_unitaire_nuit']?.toString() ?? '0',
              'check_in': lMap['check_in'] ?? b['check_in'],
              'check_out': lMap['check_out'] ?? b['check_out'],
              'occupant_name': b['contact_nom'] ?? b['client_nom'],
              'room_type': {
                'name': lMap['type_chambre'] ?? 'Chambre Standard',
              },
              'chambre_numero': lMap['chambre_numero']?.toString(),
              'chambre_id': lMap['chambre_id'],
            };
          }).toList(),
        };
      }).toList() ?? [];
      return handler.resolve(
        Response(requestOptions: options, data: {'data': mapped, 'total': mapped.length}, statusCode: 200),
      );
    }

    // E. /accounts (GET/POST/PATCH/DELETE)
    if (path.contains('/accounts')) {
      if (method == 'GET') {
        final mapped = _mockUsers?.map(mapToReadAccount).toList() ?? [];
        return handler.resolve(
          Response(requestOptions: options, data: {'data': mapped, 'total': mapped.length}, statusCode: 200),
        );
      }
      if (method == 'POST') {
        final data = options.data as Map<String, dynamic>;
        final newUser = {
          "id": "user-uuid-${DateTime.now().millisecondsSinceEpoch}",
          "login": data['email'] ?? 'newstaff@sra-hotel.com',
          "role": data['role'] ?? 'receptionist',
          "nom": 'Nom',
          "prenoms": 'Prénom',
          "telephone": '',
          "sexe": 'M',
          "pays": 'Côte d\'Ivoire',
          "adresse": '',
          "is_active": 1,
        };
        _mockUsers?.add(newUser);
        return handler.resolve(
          Response(requestOptions: options, data: mapToReadAccount(newUser), statusCode: 201),
        );
      }
      if (method == 'PATCH') {
        final idStr = path.split('/').last;
        final data = options.data as Map<String, dynamic>;
        final index = _mockUsers?.indexWhere((u) {
          final acc = mapToReadAccount(u);
          return acc['id'].toString() == idStr;
        }) ?? -1;
        if (index != -1) {
          final u = _mockUsers![index];
          _mockUsers![index] = {
            ...u,
            if (data.containsKey('email')) 'login': data['email'],
            if (data.containsKey('role')) 'role': data['role'],
            if (data.containsKey('is_active')) 'is_active': (data['is_active'] == true ? 1 : 0),
          };
          return handler.resolve(
            Response(requestOptions: options, data: mapToReadAccount(_mockUsers![index]), statusCode: 200),
          );
        }
      }
      if (method == 'DELETE') {
        final idStr = path.split('/').last;
        final index = _mockUsers?.indexWhere((u) {
          final acc = mapToReadAccount(u);
          return acc['id'].toString() == idStr;
        }) ?? -1;
        if (index != -1) {
          _mockUsers![index]['is_active'] = 0;
          return handler.resolve(
            Response(requestOptions: options, statusCode: 204),
          );
        }
      }
    }

    // F. /signup (POST)
    if (path.endsWith('/signup') && method == 'POST') {
      final data = options.data as Map<String, dynamic>;
      final newUser = {
        "id": "user-uuid-${DateTime.now().millisecondsSinceEpoch}",
        "login": data['email'] ?? '',
        "role": 'client',
        "nom": data['last_name'] ?? '',
        "prenoms": data['first_name'] ?? '',
        "telephone": data['phone'] ?? '',
        "sexe": data['gender'] ?? 'M',
        "pays": data['country'] ?? 'Côte d\'Ivoire',
        "adresse": data['address'] ?? '',
        "is_active": 1,
      };
      _mockUsers?.add(newUser);
      return handler.resolve(
        Response(requestOptions: options, data: mapToReadAccount(newUser), statusCode: 201),
      );
    }

    // G. /users (PATCH)
    if (path.contains('/users/') && method == 'PATCH') {
      final idStr = path.split('/').last;
      final data = options.data as Map<String, dynamic>;
      final index = _mockUsers?.indexWhere((u) {
        final acc = mapToReadAccount(u);
        return acc['user']['id'].toString() == idStr;
      }) ?? -1;
      if (index != -1) {
        final u = _mockUsers![index];
        _mockUsers![index] = {
          ...u,
          if (data.containsKey('first_name')) 'prenoms': data['first_name'],
          if (data.containsKey('last_name')) 'nom': data['last_name'],
          if (data.containsKey('phone')) 'telephone': data['phone'],
          if (data.containsKey('address')) 'adresse': data['address'],
          if (data.containsKey('gender')) 'sexe': data['gender'],
          if (data.containsKey('country')) 'pays': data['country'],
        };
        final acc = mapToReadAccount(_mockUsers![index]);
        return handler.resolve(
          Response(requestOptions: options, data: acc['user'], statusCode: 200),
        );
      }
    }

    // H. /equipments (GET/POST/PATCH/DELETE)
    if (path.contains('/equipments')) {
      if (method == 'GET') {
        if (path.contains('/room-types/')) {
          return handler.resolve(Response(requestOptions: options, data: [], statusCode: 200));
        }
        return handler.resolve(
          Response(requestOptions: options, data: {'data': _mockEquipments, 'total': _mockEquipments?.length ?? 0}, statusCode: 200),
        );
      }
      if (method == 'POST') {
        if (path.contains('/room-types/')) {
          return handler.resolve(Response(requestOptions: options, data: {"success": true}, statusCode: 201));
        }
        final data = options.data as Map<String, dynamic>;
        final newId = (_mockEquipments?.map((e) => e['id'] as int).fold(0, (max, e) => e > max ? e : max) ?? 0) + 1;
        final newEq = {
          "id": newId,
          "name": data['name'] ?? 'Nouvel Équipement',
          "description": data['description'] ?? '',
          "status": data['status'] ?? 'AVAILABLE'
        };
        _mockEquipments?.add(newEq);
        return handler.resolve(Response(requestOptions: options, data: newEq, statusCode: 201));
      }
      if (method == 'PATCH') {
        if (path.contains('/room-types/')) {
          return handler.resolve(Response(requestOptions: options, data: {"success": true}, statusCode: 200));
        }
        final data = options.data as Map<String, dynamic>;
        final idStr = path.split('/').last;
        final id = int.tryParse(idStr);
        final index = _mockEquipments?.indexWhere((e) => e['id'] == id) ?? -1;
        if (index != -1) {
          _mockEquipments![index] = {
            ..._mockEquipments![index],
            if (data.containsKey('name')) 'name': data['name'],
            if (data.containsKey('description')) 'description': data['description'],
            if (data.containsKey('status')) 'status': data['status'],
          };
          return handler.resolve(Response(requestOptions: options, data: _mockEquipments![index], statusCode: 200));
        }
      }
      if (method == 'DELETE') {
        if (path.contains('/room-types/')) {
          return handler.resolve(Response(requestOptions: options, statusCode: 204));
        }
        final idStr = path.split('/').last;
        final id = int.tryParse(idStr);
        if (id != null) {
          _mockEquipments?.removeWhere((e) => e['id'] == id);
          return handler.resolve(Response(requestOptions: options, statusCode: 204));
        }
      }
    }

    // I. /pay (POST)
    if (path.contains('/pay') && method == 'POST') {
      final parts = path.split('/');
      final payIndex = parts.indexOf('pay');
      if (payIndex > 0) {
        final reservId = parts[payIndex - 1];
        final index = _mockBookings?.indexWhere((b) => b['id_reservation'] == reservId || b['id_reservation'] == "res-$reservId") ?? -1;
        if (index != -1) {
          _mockBookings![index]['payment_status'] = 'PAYE';
          _mockBookings![index]['statut'] = 'CONFIRMEE';
        }
        return handler.resolve(Response(requestOptions: options, data: {"success": true, "message": "Paiement enregistré avec succès"}, statusCode: 200));
      }
    }

    // J. /reservation-line (PATCH)
    if (path.contains('/reservation-line/') && method == 'PATCH') {
      final data = options.data as Map<String, dynamic>;
      final parts = path.split('/');
      final lineIdStr = parts.last;
      final reservIdStr = parts[parts.length - 3];
      
      final index = _mockBookings?.indexWhere((b) => b['id_reservation'] == reservIdStr || b['id_reservation'] == "res-$reservIdStr") ?? -1;
      if (index != -1) {
        final b = _mockBookings![index];
        final currentLines = List<Map<String, dynamic>>.from(b['lignes'] as List);
        final lineIndex = currentLines.indexWhere((l) => (l['chambre_id'] ?? 0).toString() == lineIdStr || (l['id'] ?? 0).toString() == lineIdStr);
        if (lineIndex != -1) {
          final l = currentLines[lineIndex];
          currentLines[lineIndex] = {
            ...l,
            if (data.containsKey('price')) 'prix_unitaire_nuit': data['price'],
            if (data.containsKey('chambre_id') || data.containsKey('room_id')) 
              'chambre_id': data['chambre_id'] ?? data['room_id'],
            if (data.containsKey('chambre_numero') || data.containsKey('room_number')) 
              'chambre_numero': (data['chambre_numero'] ?? data['room_number']).toString(),
            if (data.containsKey('check_in')) 'check_in': data['check_in'].toString(),
            if (data.containsKey('check_out')) 'check_out': data['check_out'].toString(),
            if (data.containsKey('occupant_name')) 'occupant_name': data['occupant_name'].toString(),
          };
          _mockBookings![index]['lignes'] = currentLines;
          
          final mappedB = {
            'id': int.tryParse(b['id_reservation'].toString().replaceAll('res-', '')) ?? 0,
            'id_reservation': b['id_reservation'],
            'no_references': b['numero_reservation'] ?? b['reference'],
            'reference': b['numero_reservation'] ?? b['reference'],
            'client_nom': b['contact_nom'] ?? b['client_nom'] ?? 'Client SRA',
            'type_chambre': currentLines[0]['type_chambre'] ?? 'Chambre Standard',
            'check_in': b['check_in'],
            'check_out': b['check_out'],
            'adultes': currentLines[0]['adultes'] ?? 1,
            'enfants': currentLines[0]['enfants'] ?? 0,
            'status': b['statut'] ?? 'EN_ATTENTE',
            'statut_booking': b['statut'] ?? 'EN_ATTENTE',
            'prix_total': b['prix_total'],
            'reservation_lines': currentLines.map((lMap) {
              return {
                'id': lMap['chambre_id'] ?? 0,
                'price': lMap['prix_unitaire_nuit']?.toString() ?? '0',
                'check_in': lMap['check_in'] ?? b['check_in'],
                'check_out': lMap['check_out'] ?? b['check_out'],
                'occupant_name': b['contact_nom'] ?? b['client_nom'],
                'room_type': {
                  'name': lMap['type_chambre'] ?? 'Chambre Standard',
                },
                'chambre_numero': lMap['chambre_numero']?.toString(),
                'chambre_id': lMap['chambre_id'],
              };
            }).toList(),
          };
          return handler.resolve(Response(requestOptions: options, data: mappedB, statusCode: 200));
        }
      }
    }

    // 1. Simulate Login (POST /auth/login)
    if (path.endsWith('/auth/login') && method == 'POST') {
      final email = options.data['email'] ?? 'admin@sra-hotel.com';
      
      String role = 'client';
      if (email.contains('admin')) {
        role = 'admin';
      } else if (email.contains('reception')) {
        role = 'reception';
      } else if (email.contains('menage')) {
        role = 'menage';
      }

      final matchingUser = _mockUsers?.firstWhere(
        (u) => u['login'] == email,
        orElse: () => {
          "id": "8f4b5a31-6284-4e4b-91c2-1b1a1c1d1e1f",
          "login": email,
          "role": role,
          "nom": "Steward",
          "prenoms": "Rufus",
          "telephone": "+2250707070707",
          "sexe": "M",
          "pays": "Côte d'Ivoire",
          "adresse": "Abidjan, Cocody",
          "is_active": 1
        },
      );

      final responseData = {
        "access_token": "mock_jwt_token_${role}_12345",
        "token_type": "bearer",
        "user": matchingUser
      };

      return handler.resolve(
        Response(
          requestOptions: options,
          data: responseData,
          statusCode: 200,
        ),
      );
    }

    // 2. Simulate Particulier Register (POST /auth/register/particulier)
    if (path.endsWith('/auth/register/particulier') && method == 'POST') {
      final data = options.data as Map<String, dynamic>;
      final email = data['email'];
      final nom = data['nom'];
      final prenoms = data['prenoms'];
      final telephone = data['telephone'];
      final sexe = data['sexe'];
      final pays = data['pays'];
      final adresse = data['adresse'];

      final newUser = {
        "id": "mock-uuid-particulier-${DateTime.now().millisecondsSinceEpoch}",
        "login": email,
        "role": "client",
        "nom": nom,
        "prenoms": prenoms,
        "telephone": telephone,
        "sexe": sexe,
        "pays": pays,
        "adresse": adresse,
        "is_active": 1
      };
      _mockUsers?.add(newUser);

      final responseData = {
        "access_token": "mock_jwt_token_particulier_998877",
        "token_type": "bearer",
        "user": newUser
      };

      return handler.resolve(
        Response(
          requestOptions: options,
          data: responseData,
          statusCode: 201,
        ),
      );
    }

    // 3. Simulate Company Register (POST /auth/register/company)
    if (path.endsWith('/auth/register/company') && method == 'POST') {
      final data = options.data as Map<String, dynamic>;
      final email = data['email'];
      final companyName = data['companyName'];
      final telephone = data['telephone'];
      final pays = data['pays'];
      final adresse = data['adresse'];
      final isExterne = data['isExterne'] ?? false;

      final newUser = {
        "id": "mock-uuid-company-${DateTime.now().millisecondsSinceEpoch}",
        "login": email,
        "role": "client",
        "nom": companyName,
        "prenoms": isExterne ? "Agence" : "Corporate",
        "telephone": telephone,
        "sexe": "N/A",
        "pays": pays,
        "adresse": adresse,
        "is_active": 1
      };
      _mockUsers?.add(newUser);

      final responseData = {
        "access_token": "mock_jwt_token_company_998877",
        "token_type": "bearer",
        "user": newUser
      };

      return handler.resolve(
        Response(
          requestOptions: options,
          data: responseData,
          statusCode: 201,
        ),
      );
    }

    // ── BACKOFFICE API ENDPOINTS ──

    // GET KPIs (/backoffice/kpis)
    if (path.endsWith('/backoffice/kpis') && method == 'GET') {
      final responseData = {
        "ca_mensuel": 6800000,
        "ca_delta": "+8%",
        "taux_occupation": 78,
        "taux_delta": "+5pp",
        "revpar": 74100,
        "revpar_delta": "+3%",
        "panier_moyen": 234000,
        "panier_delta": "-2%"
      };

      return handler.resolve(
        Response(requestOptions: options, data: responseData, statusCode: 200),
      );
    }

    // GET Trend History (/backoffice/history)
    if (path.endsWith('/backoffice/history') && method == 'GET') {
      final responseData = {
        "labels": ["Jan", "Fév", "Mar", "Avr", "Mai", "Jun"],
        "revenue": [4200000, 5100000, 3800000, 6500000, 7200000, 6800000],
        "occupancy": [62, 71, 54, 82, 89, 78]
      };

      return handler.resolve(
        Response(requestOptions: options, data: responseData, statusCode: 200),
      );
    }

    // CRUD /services
    if (path.contains('/services')) {
      if (method == 'GET') {
        return handler.resolve(
          Response(requestOptions: options, data: {'data': _mockServices, 'total': _mockServices?.length ?? 0}, statusCode: 200),
        );
      }
      if (method == 'POST') {
        final data = options.data as Map<String, dynamic>;
        final newId = (_mockServices?.map((e) => e['id'] as int).fold(0, (max, e) => e > max ? e : max) ?? 0) + 1;
        final newService = {
          "id": newId,
          "nom": data['nom'] ?? 'Nouveau Service',
          "categorie": data['categorie'] ?? 'AUTRE',
          "description": data['description'] ?? '',
          "prix_unitaire": (data['prix_unitaire'] as num?)?.toDouble() ?? 0.0,
          "est_disponible": data['est_disponible'] ?? true,
          "photo": data['photo'] ?? 'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?w=600&q=80'
        };
        _mockServices?.add(newService);
        return handler.resolve(
          Response(requestOptions: options, data: newService, statusCode: 201),
        );
      }
      if (method == 'PUT' || method == 'PATCH') {
        final data = options.data as Map<String, dynamic>;
        final lastPart = path.split('/').last;
        final id = (data['id'] as int?) ?? int.tryParse(lastPart) ?? 0;
        final index = _mockServices?.indexWhere((s) => s['id'] == id) ?? -1;
        if (index != -1) {
          _mockServices![index] = {
            ..._mockServices![index],
            if (data.containsKey('nom')) 'nom': data['nom'],
            if (data.containsKey('categorie')) 'categorie': data['categorie'],
            if (data.containsKey('description')) 'description': data['description'],
            if (data.containsKey('prix_unitaire')) 'prix_unitaire': (data['prix_unitaire'] as num).toDouble(),
            if (data.containsKey('est_disponible')) 'est_disponible': data['est_disponible'],
            if (data.containsKey('photo')) 'photo': data['photo'],
          };
          return handler.resolve(
            Response(requestOptions: options, data: _mockServices![index], statusCode: 200),
          );
        }
      }
      if (method == 'DELETE') {
        final idStr = path.split('/').last;
        final id = int.tryParse(idStr);
        if (id != null) {
          _mockServices?.removeWhere((s) => s['id'] == id);
          return handler.resolve(
            Response(requestOptions: options, data: {"success": true}, statusCode: 200),
          );
        }
      }
    }

    // CRUD /backoffice/rooms
    if (path.contains('/backoffice/rooms')) {
      if (method == 'GET') {
        return handler.resolve(
          Response(requestOptions: options, data: _mockRooms, statusCode: 200),
        );
      }
      if (method == 'POST') {
        final data = options.data as Map<String, dynamic>;
        final newId = (_mockRooms?.map((e) => e['id_chambre'] as int).fold(0, (max, e) => e > max ? e : max) ?? 0) + 1;
        final newRoom = {
          "id_chambre": newId,
          "numero": data['numero'] ?? '999',
          "id_type_de_chambre": data['id_type_de_chambre'] ?? 1,
          "type": data['type'] ?? 'Chambre Standard',
          "etage": data['etage'] ?? 1,
          "statut_menage": data['statut_menage'] ?? 'PROPRE',
          "est_active": data['est_active'] ?? 1,
          "occupee": data['occupee'] ?? 0
        };
        _mockRooms?.add(newRoom);
        return handler.resolve(
          Response(requestOptions: options, data: newRoom, statusCode: 201),
        );
      }
      if (method == 'PUT') {
        final data = options.data as Map<String, dynamic>;
        final id = data['id_chambre'] as int;
        final index = _mockRooms?.indexWhere((r) => r['id_chambre'] == id) ?? -1;
        if (index != -1) {
          _mockRooms![index] = {
            ..._mockRooms![index],
            if (data.containsKey('numero')) 'numero': data['numero'],
            if (data.containsKey('id_type_de_chambre')) 'id_type_de_chambre': data['id_type_de_chambre'],
            if (data.containsKey('type')) 'type': data['type'],
            if (data.containsKey('etage')) 'etage': data['etage'],
            if (data.containsKey('statut_menage')) 'statut_menage': data['statut_menage'],
            if (data.containsKey('est_active')) 'est_active': data['est_active'],
            if (data.containsKey('occupee')) 'occupee': data['occupee'],
            if (data.containsKey('client_actuel')) 'client_actuel': data['client_actuel'],
          };
          return handler.resolve(
            Response(requestOptions: options, data: _mockRooms![index], statusCode: 200),
          );
        }
      }
      if (method == 'DELETE') {
        final idStr = path.split('/').last;
        final id = int.tryParse(idStr);
        if (id != null) {
          _mockRooms?.removeWhere((r) => r['id_chambre'] == id);
          return handler.resolve(
            Response(requestOptions: options, data: {"success": true}, statusCode: 200),
          );
        }
      }
    }

    // CRUD /room-types
    if (path.contains('/room-types') && !path.contains('/equipments')) {
      if (method == 'GET') {
        return handler.resolve(
          Response(requestOptions: options, data: {'data': _mockRoomTypes, 'total': _mockRoomTypes?.length ?? 0}, statusCode: 200),
        );
      }
      if (method == 'POST') {
        final Map<String, dynamic> bodyFields;
        if (options.data is FormData) {
          final formData = options.data as FormData;
          bodyFields = {
            for (final entry in formData.fields) entry.key: entry.value,
          };
          if (formData.files.isNotEmpty) {
            bodyFields['images'] = ["https://images.unsplash.com/photo-1631049552057-403cdb8f0658?w=800&q=80"];
          }
        } else if (options.data is Map) {
          bodyFields = Map<String, dynamic>.from(options.data as Map);
        } else {
          bodyFields = {};
        }

        final newId = (_mockRoomTypes?.map((e) => e['id_type_de_chambre'] as int).fold(0, (max, e) => e > max ? e : max) ?? 0) + 1;
        final newType = {
          "id_type_de_chambre": newId,
          "nom": bodyFields['nom'] ?? 'Nouveau Type',
          "prix_nuit": double.tryParse(bodyFields['prix_nuit']?.toString() ?? '') ?? 50000.0,
          "capacite": int.tryParse(bodyFields['capacite']?.toString() ?? '') ?? 2,
          "description": bodyFields['description'] ?? '',
          "images": bodyFields['images'] ?? ["https://images.unsplash.com/photo-1631049552057-403cdb8f0658?w=800&q=80"]
        };
        _mockRoomTypes?.add(newType);
        return handler.resolve(
          Response(requestOptions: options, data: newType, statusCode: 201),
        );
      }
      if (method == 'PUT' || method == 'PATCH') {
        final Map<String, dynamic> bodyFields;
        if (options.data is FormData) {
          final formData = options.data as FormData;
          bodyFields = {
            for (final entry in formData.fields) entry.key: entry.value,
          };
          if (formData.files.isNotEmpty) {
            bodyFields['images'] = ["https://images.unsplash.com/photo-1631049552057-403cdb8f0658?w=800&q=80"];
          }
        } else if (options.data is Map) {
          bodyFields = Map<String, dynamic>.from(options.data as Map);
        } else {
          bodyFields = {};
        }

        final lastPart = path.split('/').last;
        final id = (bodyFields['id_type_de_chambre'] as int?) ?? int.tryParse(lastPart) ?? 0;
        final index = _mockRoomTypes?.indexWhere((t) => t['id_type_de_chambre'] == id) ?? -1;
        if (index != -1) {
          _mockRoomTypes![index] = {
            ..._mockRoomTypes![index],
            if (bodyFields.containsKey('nom')) 'nom': bodyFields['nom'],
            if (bodyFields.containsKey('prix_nuit')) 'prix_nuit': double.tryParse(bodyFields['prix_nuit'].toString()) ?? _mockRoomTypes![index]['prix_nuit'],
            if (bodyFields.containsKey('capacite')) 'capacite': int.tryParse(bodyFields['capacite'].toString()) ?? _mockRoomTypes![index]['capacite'],
            if (bodyFields.containsKey('description')) 'description': bodyFields['description'],
            if (bodyFields.containsKey('images')) 'images': bodyFields['images'],
          };
          return handler.resolve(
            Response(requestOptions: options, data: _mockRoomTypes![index], statusCode: 200),
          );
        }
      }
      if (method == 'DELETE') {
        final idStr = path.split('/').last;
        final id = int.tryParse(idStr);
        if (id != null) {
          _mockRoomTypes?.removeWhere((t) => t['id_type_de_chambre'] == id);
          return handler.resolve(
            Response(requestOptions: options, data: {"success": true}, statusCode: 200),
          );
        }
      }
    }

    // CRUD /backoffice/users
    if (path.contains('/backoffice/users')) {
      if (method == 'GET') {
        return handler.resolve(
          Response(requestOptions: options, data: _mockUsers, statusCode: 200),
        );
      }
      if (method == 'POST') {
        final data = options.data as Map<String, dynamic>;
        final newUser = {
          "id": "user-uuid-${DateTime.now().millisecondsSinceEpoch}",
          "login": data['login'] ?? 'newstaff@sra-hotel.com',
          "role": data['role'] ?? 'reception',
          "nom": data['nom'] ?? '',
          "prenoms": data['prenoms'] ?? '',
          "telephone": data['telephone'] ?? '',
          "sexe": data['sexe'] ?? 'M',
          "pays": data['pays'] ?? 'Côte d\'Ivoire',
          "adresse": data['adresse'] ?? '',
          "is_active": data['is_active'] ?? 1
        };
        _mockUsers?.add(newUser);
        return handler.resolve(
          Response(requestOptions: options, data: newUser, statusCode: 201),
        );
      }
      if (method == 'PUT') {
        final data = options.data as Map<String, dynamic>;
        final id = data['id'] as String;
        final index = _mockUsers?.indexWhere((u) => u['id'] == id) ?? -1;
        if (index != -1) {
          _mockUsers![index] = {
            ..._mockUsers![index],
            if (data.containsKey('nom')) 'nom': data['nom'],
            if (data.containsKey('prenoms')) 'prenoms': data['prenoms'],
            if (data.containsKey('telephone')) 'telephone': data['telephone'],
            if (data.containsKey('role')) 'role': data['role'],
            if (data.containsKey('is_active')) 'is_active': data['is_active'],
          };
          return handler.resolve(
            Response(requestOptions: options, data: _mockUsers![index], statusCode: 200),
          );
        }
      }
      if (method == 'DELETE') {
        final id = path.split('/').last;
        _mockUsers?.removeWhere((u) => u['id'] == id);
        return handler.resolve(
          Response(requestOptions: options, data: {"success": true}, statusCode: 200),
        );
      }
    }

    // CRUD /reservation/ and /backoffice/bookings & check-in/out
    if (path.contains('/backoffice/bookings') || path.contains('/reservation')) {
      // helper function to map bookings to what the model expects
      List<Map<String, dynamic>> getMappedBookings() {
        return _mockBookings?.map((b) {
          final idStr = b['id_reservation']?.toString() ?? '';
          final intId = int.tryParse(idStr.replaceAll('res-', '')) ?? 0;
          final List lignesList = b['lignes'] as List? ?? [];
          final firstLine = lignesList.isNotEmpty ? (lignesList.first as Map<String, dynamic>) : {};
          return {
            'id': intId,
            'id_reservation': b['id_reservation'],
            'no_references': b['numero_reservation'] ?? b['reference'],
            'reference': b['numero_reservation'] ?? b['reference'],
            'client_nom': b['contact_nom'] ?? b['client_nom'] ?? 'Client SRA',
            'type_chambre': firstLine['type_chambre'] ?? 'Chambre Standard',
            'check_in': b['check_in'],
            'check_out': b['check_out'],
            'adultes': firstLine['adultes'] ?? 1,
            'enfants': firstLine['enfants'] ?? 0,
            'status': b['statut'] ?? 'EN_ATTENTE',
            'statut_booking': b['statut'] ?? 'EN_ATTENTE',
            'prix_total': b['prix_total'],
            'discount_percentage': b['discount_percentage'] ?? 0.0,
            'reservation_lines': lignesList.map((l) {
              final lMap = l as Map<String, dynamic>;
              return {
                'id': lMap['chambre_id'] ?? 0,
                'price': lMap['prix_unitaire_nuit']?.toString() ?? '0',
                'check_in': lMap['check_in'] ?? b['check_in'],
                'check_out': lMap['check_out'] ?? b['check_out'],
                'occupant_name': b['contact_nom'] ?? b['client_nom'],
                'room_type': {
                  'name': lMap['type_chambre'] ?? 'Chambre Standard',
                },
                'chambre_numero': lMap['chambre_numero']?.toString(),
                'chambre_id': lMap['chambre_id'],
              };
            }).toList(),
          };
        }).toList() ?? [];
      }

      if (method == 'GET') {
        final data = getMappedBookings();
        final parts = path.split('/');
        final lastPart = parts.last;
        final intId = int.tryParse(lastPart);
        if (intId != null || lastPart.startsWith('res-')) {
          final targetId = intId ?? lastPart;
          final item = data.firstWhere(
            (b) => b['id'] == targetId || b['id_reservation'] == targetId,
            orElse: () => <String, dynamic>{},
          );
          if (item.isNotEmpty) {
            return handler.resolve(Response(requestOptions: options, data: item, statusCode: 200));
          } else {
            return handler.reject(DioException(
              requestOptions: options,
              response: Response(requestOptions: options, statusCode: 404, statusMessage: "Booking not found"),
            ));
          }
        }

        return handler.resolve(
          Response(requestOptions: options, data: {'data': data}, statusCode: 200),
        );
      }

      if (method == 'POST') {
        final data = options.data as Map<String, dynamic>;
        final newId = (_mockBookings?.map((e) => int.tryParse(e['id_reservation'].toString().replaceAll('res-', '')) ?? 0).fold(0, (max, e) => e > max ? e : max) ?? 0) + 1;
        final newRef = "SRA-${DateTime.now().year}${(DateTime.now().month).toString().padLeft(2, '0')}${(DateTime.now().day).toString().padLeft(2, '0')}-${newId.toString().padLeft(3, '0')}";
        
        final checkInStr = data['check_in'] ?? DateTime.now().toIso8601String().split('T').first;
        final checkOutStr = data['check_out'] ?? DateTime.now().add(const Duration(days: 2)).toIso8601String().split('T').first;
        
        final newBooking = {
          "id_reservation": "res-$newId",
          "numero_reservation": newRef,
          "statut": data['status'] ?? data['statut'] ?? "CONFIRMEE",
          "date_creation": DateTime.now().toIso8601String(),
          "prix_total": (data['prix_total'] as num?)?.toDouble() ?? 150000.0,
          "contact_nom": data['client_nom'] ?? data['contact_nom'] ?? "Nouveau Client",
          "contact_email": data['contact_email'] ?? "client@sra-hotel.com",
          "contact_telephone": data['contact_telephone'] ?? "+2250700000000",
          "check_in": checkInStr,
          "check_out": checkOutStr,
          "lignes": [
            {
              "chambre_id": data['chambre_id'] ?? 11,
              "chambre_numero": data['chambre_numero'] ?? "204",
              "type_chambre": data['type_chambre'] ?? "Suite",
              "check_in": checkInStr,
              "check_out": checkOutStr,
              "adultes": data['adultes'] ?? 1,
              "enfants": data['enfants'] ?? 0,
              "prix_unitaire_nuit": 75000.0,
              "prix_total_ligne": 150000.0
            }
          ]
        };
        _mockBookings?.add(newBooking);
        return handler.resolve(Response(requestOptions: options, data: newBooking, statusCode: 201));
      }

      if (method == 'PUT' || method == 'PATCH') {
        final data = options.data as Map<String, dynamic>;
        final parts = path.split('/');
        final lastPart = parts.last;
        final intId = int.tryParse(lastPart);
        final String targetId = intId != null ? "res-$intId" : (lastPart.startsWith('res-') ? lastPart : (data['id_reservation'] ?? data['id'] ?? '').toString());
        
        final index = _mockBookings?.indexWhere((b) => b['id_reservation'] == targetId || b['id_reservation'] == lastPart || b['id_reservation'] == "res-$lastPart") ?? -1;
        if (index != -1) {
          final existing = _mockBookings![index];
          final currentLines = List<Map<String, dynamic>>.from(existing['lignes'] as List);
          
          if (currentLines.isNotEmpty) {
            final firstLine = currentLines[0];
            currentLines[0] = {
              ...firstLine,
              if (data.containsKey('chambre_numero') || data.containsKey('room_number')) 
                'chambre_numero': (data['chambre_numero'] ?? data['room_number']).toString(),
              if (data.containsKey('chambre_id') || data.containsKey('room_id')) 
                'chambre_id': data['chambre_id'] ?? data['room_id'],
              if (data.containsKey('type_chambre') || data.containsKey('room_type')) 
                'type_chambre': (data['type_chambre'] ?? data['room_type'] ?? firstLine['type_chambre']).toString(),
              if (data.containsKey('check_in')) 'check_in': data['check_in'].toString(),
              if (data.containsKey('check_out')) 'check_out': data['check_out'].toString(),
              if (data.containsKey('adultes')) 'adultes': data['adultes'] as int,
              if (data.containsKey('enfants')) 'enfants': data['enfants'] as int,
            };
          }
          
          double discountPercentage = 0.0;
          if (data.containsKey('discount_percentage')) {
            discountPercentage = double.tryParse(data['discount_percentage'].toString()) ?? 0.0;
          } else {
            discountPercentage = (existing['discount_percentage'] as num?)?.toDouble() ?? 0.0;
          }
          
          double sumLines = currentLines.fold(0.0, (sum, line) {
            final p = line['prix_unitaire_nuit'];
            final pDouble = p != null ? double.tryParse(p.toString()) ?? 0.0 : 0.0;
            return sum + pDouble;
          });
          
          double prixTotal = sumLines * (1.0 - discountPercentage / 100.0);
          
          _mockBookings![index] = {
            ...existing,
            if (data.containsKey('status')) 'statut': data['status'].toString().toUpperCase(),
            if (data.containsKey('statut')) 'statut': data['statut'].toString().toUpperCase(),
            if (data.containsKey('statut_booking')) 'statut': data['statut_booking'].toString().toUpperCase(),
            if (data.containsKey('client_nom')) 'contact_nom': data['client_nom'].toString(),
            if (data.containsKey('contact_nom')) 'contact_nom': data['contact_nom'].toString(),
            if (data.containsKey('check_in')) 'check_in': data['check_in'].toString(),
            if (data.containsKey('check_out')) 'check_out': data['check_out'].toString(),
            'lignes': currentLines,
            'prix_total': data.containsKey('discount_percentage') || data.containsKey('prix_total') ? prixTotal : existing['prix_total'],
            'discount_percentage': discountPercentage,
          };

          final ref = existing['numero_reservation'];
          final arrIndex = _mockArrivees?.indexWhere((a) => a['reference'] == ref) ?? -1;
          if (arrIndex != -1) {
            final roomNo = currentLines.isNotEmpty ? currentLines[0]['chambre_numero']?.toString() : null;
            if (roomNo != null) {
              _mockArrivees![arrIndex]['chambre_attribuee'] = roomNo;
            }
            if (data['status'] == 'CONFIRME' || data['status'] == 'CONFIRMEE' || data['statut'] == 'CONFIRME' || data['statut'] == 'CONFIRMEE') {
              _mockArrivees![arrIndex]['statut_checkin'] = 'EFFECTUE';
            }
          }

          final allMapped = getMappedBookings();
          final updatedMapped = allMapped.firstWhere((element) => element['id_reservation'] == targetId || element['id_reservation'] == lastPart || element['id_reservation'] == "res-$lastPart");
          return handler.resolve(
            Response(requestOptions: options, data: updatedMapped, statusCode: 200),
          );
        } else {
          return handler.reject(DioException(
            requestOptions: options,
            response: Response(requestOptions: options, statusCode: 404, statusMessage: "Booking to update not found"),
          ));
        }
      }
    }

    // GET /backoffice/invoices
    if (path.contains('/backoffice/invoices')) {
      if (method == 'GET') {
        return handler.resolve(
          Response(requestOptions: options, data: _mockInvoices, statusCode: 200),
        );
      }
      if (method == 'POST') {
        final data = options.data as Map<String, dynamic>;
        final newInvoice = {
          "id_folio": "inv-${DateTime.now().millisecondsSinceEpoch}",
          "reference": "FAC-${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, '0')}-new",
          "client_nom": data['client_nom'] ?? 'Client Inconnu',
          "client_email": data['client_email'] ?? '',
          "id_reservation": data['id_reservation'] ?? '',
          "prix_total": (data['prix_total'] as num?)?.toDouble() ?? 0.0,
          "statut": data['statut'] ?? 'NON_PAYE',
          "create_at": DateTime.now().toIso8601String()
        };
        _mockInvoices?.add(newInvoice);
        return handler.resolve(
          Response(requestOptions: options, data: newInvoice, statusCode: 201),
        );
      }
    }

    // GET /backoffice/arrivals & departures (Reception desk list view)
    if (path.endsWith('/backoffice/arrivals') && method == 'GET') {
      return handler.resolve(
        Response(requestOptions: options, data: _mockArrivees, statusCode: 200),
      );
    }
    if (path.endsWith('/backoffice/departures') && method == 'GET') {
      return handler.resolve(
        Response(requestOptions: options, data: _mockDeparts, statusCode: 200),
      );
    }

    // POST /backoffice/checkin (Attribution and check-in confirmation)
    if (path.endsWith('/backoffice/checkin') && method == 'POST') {
      final data = options.data as Map<String, dynamic>;
      final reference = data['reference'] as String;
      final roomNo = data['chambre_numero'] as String;

      final index = _mockArrivees?.indexWhere((a) => a['reference'] == reference) ?? -1;
      if (index != -1) {
        _mockArrivees![index]['chambre_attribuee'] = roomNo;
        _mockArrivees![index]['statut_checkin'] = 'EFFECTUE';
      }

      final rIndex = _mockRooms?.indexWhere((r) => r['numero'] == roomNo) ?? -1;
      if (rIndex != -1) {
        _mockRooms![rIndex]['occupee'] = 1;
        _mockRooms![rIndex]['client_actuel'] = _mockArrivees?[index]['client_nom'] ?? 'Client';
      }

      return handler.resolve(
        Response(requestOptions: options, data: {"success": true, "message": "Check-in effectué avec succès"}, statusCode: 200),
      );
    }

    // POST /backoffice/checkout (Depart confirmation)
    if (path.endsWith('/backoffice/checkout') && method == 'POST') {
      final data = options.data as Map<String, dynamic>;
      final reference = data['reference'] as String;

      final index = _mockDeparts?.indexWhere((d) => d['reference'] == reference) ?? -1;
      String roomNo = '';
      if (index != -1) {
        _mockDeparts![index]['statut_checkout'] = 'EFFECTUE';
        roomNo = _mockDeparts![index]['chambre_attribuee'] ?? '';
      }

      if (roomNo.isNotEmpty) {
        final rIndex = _mockRooms?.indexWhere((r) => r['numero'] == roomNo) ?? -1;
        if (rIndex != -1) {
          _mockRooms![rIndex]['occupee'] = 0;
          _mockRooms![rIndex]['statut_menage'] = 'SALE';
          _mockRooms![rIndex]['client_actuel'] = null;
        }
      }

      return handler.resolve(
        Response(requestOptions: options, data: {"success": true, "message": "Check-out effectué avec succès"}, statusCode: 200),
      );
    }

    // Old routes compatibility check
    if (path.endsWith('/rooms') && method == 'GET') {
      return handler.resolve(Response(requestOptions: options, data: _mockRooms, statusCode: 200));
    }
    if (path.contains('/rooms/available') && method == 'GET') {
      final cleanRooms = _mockRooms?.where((r) => r['statut_menage'] == 'PROPRE' && r['est_active'] == 1 && r['occupee'] == 0).toList();
      return handler.resolve(Response(requestOptions: options, data: cleanRooms, statusCode: 200));
    }

    // Default 404 Mock Error for other endpoints when mock is enabled
    return handler.reject(
      DioException(
        requestOptions: options,
        response: Response(
          requestOptions: options,
          statusCode: 404,
          statusMessage: "Mock Route Not Found",
        ),
      ),
    );
  }
}
