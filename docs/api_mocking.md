# Guide de Simulation et de Mocking d'API (Dio Interceptors)

Ce document décrit comment développer et tester l'application mobile de façon autonome lorsque le Core Back-end FastAPI n'est pas disponible ou en cours de développement.

---

## 1. Principe Général du Mocking

Pour éviter de bloquer le développement de l'interface mobile, le client HTTP `Dio` intègre un système d'intercepteurs.
- Un intercepteur personnalisé `MockInterceptor` intercepte toutes les requêtes HTTP sortantes.
- Si le mode "Mock" est actif, l'intercepteur n'envoie pas la requête sur le réseau. Il intercepte l'appel, attend quelques millisecondes (pour simuler la latence réseau), et renvoie directement une réponse HTTP factice (`Response`) contenant des données de test prédéfinies sous forme de JSON.

---

## 2. Activation du Mode Mock

Le mode Mock est contrôlé par une variable d'environnement lors de l'exécution ou de la compilation de l'application Flutter.

### Lancement avec Mocks :
```bash
flutter run --dart-define=USE_MOCKS=true
```

---

## 3. Implémentation du `MockInterceptor`

L'intercepteur doit analyser la route demandée (`options.path`) et la méthode HTTP (`options.method`) pour renvoyer le payload JSON adéquat.

### Code de référence de l'intercepteur :

```dart
import 'dart:convert';
import 'package:dio/dio.dart';

class MockInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    const useMocks = bool.fromEnvironment('USE_MOCKS', defaultValue: false);
    
    if (!useMocks) {
      return handler.next(options); // Continuer normalement vers le réseau
    }

    // Simuler un délai de latence réseau (500ms)
    await Future.delayed(const Duration(milliseconds: 500));

    // 1. Simuler l'authentification (POST /auth/login)
    if (options.path.endsWith('/auth/login') && options.method == 'POST') {
      final responseData = {
        "access_token": "mock_jwt_token_12345",
        "token_type": "bearer",
        "user": {
          "id": "8f4b5a31-6284-4e4b-91c2-1b1a1c1d1e1f",
          "login": options.data['email'] ?? "admin@sra-hotel.com",
          "role": "admin"
        }
      };

      return handler.resolve(
        Response(
          requestOptions: options,
          data: responseData,
          statusCode: 200,
        ),
      );
    }

    // 2. Simuler la récupération des chambres (GET /rooms)
    if (options.path.endsWith('/rooms') && options.method == 'GET') {
      final responseData = List.generate(42, (index) {
        final id = index + 1;
        String category = 'standard';
        double price = 50000;
        if (id > 30) {
          category = 'suite';
          price = 150000;
        } else if (id > 15) {
          category = 'premium';
          price = 85000;
        }
        
        return {
          "id_chambre": id,
          "numero": "Apart ${100 + id}",
          "id_type_de_chambre": category == 'suite' ? 3 : (category == 'premium' ? 2 : 1),
          "statut": "prêt"
        };
      });

      return handler.resolve(
        Response(
          requestOptions: options,
          data: responseData,
          statusCode: 200,
        ),
      );
    }

    // 3. Simuler la création de réservation (POST /bookings/create)
    if (options.path.endsWith('/bookings/create') && options.method == 'POST') {
      final responseData = {
        "id_reservation": "res_mock_998877",
        "numero_reservation": "RES-20260704-0001",
        "status": "confirmée"
      };

      return handler.resolve(
        Response(
          requestOptions: options,
          data: responseData,
          statusCode: 201,
        ),
      );
    }

    // Par défaut, retourner un 404 Mock si la route n'est pas gérée dans l'intercepteur
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
```

---

## 4. Intégration de l'Intercepteur dans `ApiClient`

L'intercepteur doit être enregistré dans l'instance globale de `Dio` lors de l'initialisation dans [api_client.dart](file:///d:/SRA-HOTEL/Dev/front_end_mobile/lib/core/network/api_client.dart) :

```dart
// Dans le constructeur de ApiClient
dio.interceptors.add(MockInterceptor()); // Placé au tout début
dio.interceptors.add(InterceptorsWrapper(...));
```
Ceci assure que si le flag `USE_MOCKS` est à `true`, les appels réseau réels sont court-circuités de manière transparente.
