# Module Gestion des Utilisateurs & Personnel (Jet 1 & Jet 3)

Ce document décrit l'architecture et les spécifications visuelles du module **Gestion des Utilisateurs & Personnel** (`user_management`).

---

## 1. Clean Architecture & Structuration

Le module suit la Clean Architecture sous `lib/features/user_management/` :

*   **👥 Domain Layer :**
    *   `StaffUser` : Entité représentant les collaborateurs et utilisateurs du système (id, login, nom, prénom, rôle, téléphone, adresse, statut d'activation).
    *   `GetUsersUseCase`, `CreateUserUseCase`, `UpdateUserUseCase`, `DeleteUserUseCase`.
*   **🗄️ Data Layer :**
    *   `UserModel` : Parsing des utilisateurs depuis/vers JSON (`CreateUser` schéma de `openai.json`).
    *   `UserRemoteDataSource` : Interface REST vers `/api/v1/users`.
    *   `UserRepositoryImpl` : Implémentation concrète.
*   **🎨 Presentation Layer :**
    *   `UserBloc` : BLoC de gestion d'état (`UserInitial`, `UserLoading`, `UserLoaded`, `UserFailure`).
    *   `AdminUsersView` : Vue d'administration avec barre de recherche, filtres par rôle (`Admin`, `Réceptionniste`, `Gouvernante`, `Client`) et modale d'invitation/édition.

---

## 2. Spécifications Visuelles & Responsive

*   **Data Grid & Responsive Cards :** Affichage optimisé en grille Desktop-First sur grand écran et cartes empilées sur mobile via `ResponsiveListGridView`.
*   **Rôles & Accès :** Pastilles sémantiques `SraStatusBadge` distinguant les 5 profils (Admin, Réceptionniste, Gouvernante, Femme de ménage, Client).
*   **Qualité Code :** Tests unitaires validés (`user_bloc_test.dart`), `flutter analyze` sans erreur.
