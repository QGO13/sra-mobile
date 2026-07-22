# Module d'Authentification et de Profilage (Jet 1, Module 1)

Ce document décrit le fonctionnement et la structure technique du module d'authentification (`auth`) et de l'espace d'accueil / profil client (`home`).

---

## 1. Clean Architecture & Structuration du Code

Le module d'authentification a été restructuré pour isoler strictement l'authentification de l'espace d'accueil. Il est maintenant divisé en deux modules distincts :

### A. Module d'Authentification (`lib/features/auth/`)
Gère exclusivement la session utilisateur, la connexion et l'inscription.

*   **👥 Domain Layer (Couche Métier) :**
    *   `UserEntity` : représente l'utilisateur avec ses informations de profil (nom, prénom, e-mail, téléphone, sexe, pays, adresse) héritées de la structure relationnelle *Personne*.
    *   `AuthRepository` : contrat abstrait définissant les opérations d'authentification (`login`, `logout`, `getAuthenticatedUser`) et d'inscription (`registerParticulier`, `registerCompany`).
    *   `LoginUseCase` : encapsulation de l'appel de connexion.
    *   `RegisterUseCase` : encapsulation des deux types de création de comptes (Particulier et Corporate/Agence).
*   **🗄️ Data Layer (Couche Données) :**
    *   `UserModel` : étend `UserEntity` et contient les parseurs de données JSON (`fromJson` et `toJson`) pour la sérialisation API.
    *   `AuthRemoteDataSource` : effectue les requêtes HTTP (via `ApiClient`) vers le serveur FastAPI pour se connecter ou s'inscrire.
    *   `AuthLocalDataSource` : persiste de façon sécurisée le jeton JWT dans le trousseau système (via `flutter_secure_storage`) et met en cache l'utilisateur dans les tables SQLite locales (`personne`, `users`, `company`, `employer`).
    *   `AuthRepositoryImpl` : implémente `AuthRepository` en unifiant la source de données distante et locale.
*   **🎨 Presentation Layer (Couche UI) :**
    *   `AuthBloc` : gère les états applicatifs (`AuthInitial`, `AuthLoading`, `Authenticated`, `Unauthenticated`, `AuthFailure`) en réponse aux événements utilisateurs (`AuthCheckRequested`, `LoginSubmitted`, `LogoutRequested`, `RegisterParticulierSubmitted`, `RegisterCompanySubmitted`).
    *   `LoginPage` : formulaire de connexion doté d'une esthétique haut de gamme (fond crème `#f7f5f1`, carte blanche épurée à bordure fine `#ede9e2`), validateurs de saisie et de la bannière déroulante `DemoAccountsBanner`.
    *   `RegisterPage` : écran d'inscription dynamique avec sélecteur d'onglets Or Champagne (`#c5985b`) pour basculer entre les profils Particulier, Corporate et Agence.

### B. Module d'Accueil (`lib/features/home/`)
Affiche le tableau de bord de l'utilisateur connecté et ses informations de compte.

*   **🎨 Presentation Layer (Couche UI) :**
    *   `HomePage` : affiche le profil client, les détails du rôle et fournit un bouton d'accès rapide à la recherche de chambres. Il lit directement l'état de l'utilisateur à partir d'un `BlocBuilder<AuthBloc, AuthState>` global sans nécessiter de BLoC propre.

---

## 2. Modèle de Données SQLite Local (Persistance & Mode Dégradé)

Lorsqu'un utilisateur se connecte avec succès, ses données sont persistées de manière transactionnelle dans SQLite locale (`sra_hotel.db`) afin d'assurer que l'application puisse fonctionner en mode dégradé hors-ligne.

### Remplacement relationnel en base locale :
*   **Particulier :** Une ligne est insérée dans `personne` (données physiques) et une ligne correspondante dans `users` (identifiants et rôles) avec le rôle `'client'`.
*   **Corporate / Agence :** Une ligne est insérée dans `personne` (avec le nom de l'entreprise/agence comme `nom` et `'Corporate'` ou `'Agence'` comme `prenoms`), une dans `users`, et des lignes additionnelles sont créées dans `company` (liaison entreprise) et `employer` (liaison relationnelle representative) pour correspondre au schéma d'héritage.

---

## 3. Simulation des APIs (Dio Interceptor)

Pour tester de manière autonome l'application sans nécessiter de backend FastAPI actif, un `MockInterceptor` est configuré. Il s'active en lançant l'application avec :
```bash
flutter run --dart-define=USE_MOCKS=true
```

### Endpoints gérés et payloads de simulation :

1.  **Connexion :** `POST /api/v1/auth/login`
    *   *Payload d'entrée :* `{"email": "...", "password": "..."}`
    *   *Payload de retour (200 OK) :*
        ```json
        {
          "access_token": "mock_jwt_token_[role]_12345",
          "token_type": "bearer",
          "user": {
            "id": "8f4b5a31-6284-4e4b-91c2-1b1a1c1d1e1f",
            "login": "email",
            "role": "admin",
            "nom": "Steward",
            "prenoms": "Rufus",
            "telephone": "+2250707070707",
            "sexe": "M",
            "pays": "Côte d'Ivoire",
            "adresse": "Abidjan, Cocody"
          }
        }
        ```

2.  **Inscription Particulier :** `POST /api/v1/auth/register/particulier`
    *   *Payload d'entrée :* `{"email": "...", "password": "...", "nom": "...", "prenoms": "...", "telephone": "...", "sexe": "...", "pays": "...", "adresse": "..."}`
    *   *Payload de retour (201 Created) :* Renvoie le token d'accès et l'entité utilisateur correspondante.

3.  **Inscription Entreprise / Agence :** `POST /api/v1/auth/register/company`
    *   *Payload d'entrée :* `{"email": "...", "password": "...", "companyName": "...", "telephone": "...", "pays": "...", "adresse": "...", "isExterne": false/true}`
    *   *Payload de retour (201 Created) :* Renvoie le token d'accès et le profil entreprise mappé.
