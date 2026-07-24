import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('zh'),
  ];

  /// Le titre de l'application
  ///
  /// In fr, this message translates to:
  /// **'SRA Hôtel'**
  String get appTitle;

  /// No description provided for @welcomeMessage.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue chez SRA Hôtel'**
  String get welcomeMessage;

  /// No description provided for @slogan.
  ///
  /// In fr, this message translates to:
  /// **'Make yourself at home'**
  String get slogan;

  /// No description provided for @login.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get logout;

  /// No description provided for @email.
  ///
  /// In fr, this message translates to:
  /// **'Adresse Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get password;

  /// No description provided for @room.
  ///
  /// In fr, this message translates to:
  /// **'Chambre'**
  String get room;

  /// No description provided for @bookings.
  ///
  /// In fr, this message translates to:
  /// **'Réservations'**
  String get bookings;

  /// No description provided for @governance.
  ///
  /// In fr, this message translates to:
  /// **'Gouvernance'**
  String get governance;

  /// No description provided for @adminDashboardTitle.
  ///
  /// In fr, this message translates to:
  /// **'DASHBOARD ADMIN'**
  String get adminDashboardTitle;

  /// No description provided for @receptionTitle.
  ///
  /// In fr, this message translates to:
  /// **'RÉCEPTION'**
  String get receptionTitle;

  /// No description provided for @reportsTab.
  ///
  /// In fr, this message translates to:
  /// **'Rapports'**
  String get reportsTab;

  /// No description provided for @roomsTab.
  ///
  /// In fr, this message translates to:
  /// **'Chambres'**
  String get roomsTab;

  /// No description provided for @roomTypesTab.
  ///
  /// In fr, this message translates to:
  /// **'Typologies'**
  String get roomTypesTab;

  /// No description provided for @servicesTab.
  ///
  /// In fr, this message translates to:
  /// **'Services'**
  String get servicesTab;

  /// No description provided for @personnelTab.
  ///
  /// In fr, this message translates to:
  /// **'Personnel'**
  String get personnelTab;

  /// No description provided for @reservationsTab.
  ///
  /// In fr, this message translates to:
  /// **'Réservations'**
  String get reservationsTab;

  /// No description provided for @invoicesTab.
  ///
  /// In fr, this message translates to:
  /// **'Factures'**
  String get invoicesTab;

  /// No description provided for @moreTab.
  ///
  /// In fr, this message translates to:
  /// **'Plus'**
  String get moreTab;

  /// No description provided for @arrivalsTab.
  ///
  /// In fr, this message translates to:
  /// **'Arrivées (Check-in)'**
  String get arrivalsTab;

  /// No description provided for @departuresTab.
  ///
  /// In fr, this message translates to:
  /// **'Départs (Check-out)'**
  String get departuresTab;

  /// No description provided for @roomGridTab.
  ///
  /// In fr, this message translates to:
  /// **'Plan Chambres'**
  String get roomGridTab;

  /// No description provided for @kpiTitle.
  ///
  /// In fr, this message translates to:
  /// **'Indicateurs clés de performance'**
  String get kpiTitle;

  /// No description provided for @caMensuel.
  ///
  /// In fr, this message translates to:
  /// **'CA MENSUEL'**
  String get caMensuel;

  /// No description provided for @occupationRate.
  ///
  /// In fr, this message translates to:
  /// **'OCCUPATION'**
  String get occupationRate;

  /// No description provided for @revpar.
  ///
  /// In fr, this message translates to:
  /// **'REVPAR'**
  String get revpar;

  /// No description provided for @panierMoyen.
  ///
  /// In fr, this message translates to:
  /// **'PANIER MOYEN'**
  String get panierMoyen;

  /// No description provided for @vsLastMonth.
  ///
  /// In fr, this message translates to:
  /// **'vs mois dernier'**
  String get vsLastMonth;

  /// No description provided for @revenueHistoryTitle.
  ///
  /// In fr, this message translates to:
  /// **'CHIFFRE D\'AFFAIRES — 6 DERNIERS MOIS'**
  String get revenueHistoryTitle;

  /// No description provided for @occupancyHistoryTitle.
  ///
  /// In fr, this message translates to:
  /// **'TAUX D\'OCCUPATION DES CHAMBRES (%)'**
  String get occupancyHistoryTitle;

  /// No description provided for @searchRoomPlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une chambre...'**
  String get searchRoomPlaceholder;

  /// No description provided for @addRoom.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une chambre'**
  String get addRoom;

  /// No description provided for @editRoom.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la chambre'**
  String get editRoom;

  /// No description provided for @roomNumberLabel.
  ///
  /// In fr, this message translates to:
  /// **'Numéro de chambre'**
  String get roomNumberLabel;

  /// No description provided for @floorLabel.
  ///
  /// In fr, this message translates to:
  /// **'Étage'**
  String get floorLabel;

  /// No description provided for @typeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Typologie'**
  String get typeLabel;

  /// No description provided for @roomInitialStatusLabel.
  ///
  /// In fr, this message translates to:
  /// **'Statut initial'**
  String get roomInitialStatusLabel;

  /// No description provided for @roomStatusAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Disponible'**
  String get roomStatusAvailable;

  /// No description provided for @roomStatusToClean.
  ///
  /// In fr, this message translates to:
  /// **'À nettoyer'**
  String get roomStatusToClean;

  /// No description provided for @roomStatusMaintenance.
  ///
  /// In fr, this message translates to:
  /// **'Maintenance'**
  String get roomStatusMaintenance;

  /// No description provided for @requiredField.
  ///
  /// In fr, this message translates to:
  /// **'Obligatoire'**
  String get requiredField;

  /// No description provided for @horsService.
  ///
  /// In fr, this message translates to:
  /// **'HORS SERVICE'**
  String get horsService;

  /// No description provided for @libre.
  ///
  /// In fr, this message translates to:
  /// **'LIBRE'**
  String get libre;

  /// No description provided for @occupee.
  ///
  /// In fr, this message translates to:
  /// **'OCCUPÉE'**
  String get occupee;

  /// No description provided for @roomTypesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Typologies de chambre'**
  String get roomTypesTitle;

  /// No description provided for @addTypology.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une typologie'**
  String get addTypology;

  /// No description provided for @editTypology.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la typologie'**
  String get editTypology;

  /// No description provided for @typologyNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom de la typologie'**
  String get typologyNameLabel;

  /// No description provided for @pricePerNightLabel.
  ///
  /// In fr, this message translates to:
  /// **'Tarif par nuit (FCFA)'**
  String get pricePerNightLabel;

  /// No description provided for @priceLabel.
  ///
  /// In fr, this message translates to:
  /// **'Tarif'**
  String get priceLabel;

  /// No description provided for @capacityLabel.
  ///
  /// In fr, this message translates to:
  /// **'Capacité adulte'**
  String get capacityLabel;

  /// No description provided for @descriptionLabel.
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @imageUrlLabel.
  ///
  /// In fr, this message translates to:
  /// **'URL de l\'image'**
  String get imageUrlLabel;

  /// No description provided for @addService.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un service'**
  String get addService;

  /// No description provided for @editService.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le service'**
  String get editService;

  /// No description provided for @serviceNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom du service'**
  String get serviceNameLabel;

  /// No description provided for @categoryLabel.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie'**
  String get categoryLabel;

  /// No description provided for @restorationCat.
  ///
  /// In fr, this message translates to:
  /// **'Restauration'**
  String get restorationCat;

  /// No description provided for @spaCat.
  ///
  /// In fr, this message translates to:
  /// **'Spa / Bien-être'**
  String get spaCat;

  /// No description provided for @transportCat.
  ///
  /// In fr, this message translates to:
  /// **'Transport / Navette'**
  String get transportCat;

  /// No description provided for @searchStaffPlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un collaborateur...'**
  String get searchStaffPlaceholder;

  /// No description provided for @addStaff.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un collaborateur'**
  String get addStaff;

  /// No description provided for @editStaff.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le collaborateur'**
  String get editStaff;

  /// No description provided for @emailLabel.
  ///
  /// In fr, this message translates to:
  /// **'Email (Identifiant)'**
  String get emailLabel;

  /// No description provided for @lastNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get lastNameLabel;

  /// No description provided for @firstNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Prénoms'**
  String get firstNameLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone'**
  String get phoneLabel;

  /// No description provided for @roleLabel.
  ///
  /// In fr, this message translates to:
  /// **'Rôle'**
  String get roleLabel;

  /// No description provided for @adminRole.
  ///
  /// In fr, this message translates to:
  /// **'Admin'**
  String get adminRole;

  /// No description provided for @receptionistRole.
  ///
  /// In fr, this message translates to:
  /// **'Réceptionniste'**
  String get receptionistRole;

  /// No description provided for @housekeeperRole.
  ///
  /// In fr, this message translates to:
  /// **'Gouvernante / Femme de ménage'**
  String get housekeeperRole;

  /// No description provided for @clientRole.
  ///
  /// In fr, this message translates to:
  /// **'Client'**
  String get clientRole;

  /// No description provided for @bookingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Réservations clients'**
  String get bookingsTitle;

  /// No description provided for @adultsCount.
  ///
  /// In fr, this message translates to:
  /// **'adulte(s)'**
  String get adultsCount;

  /// No description provided for @kidsCount.
  ///
  /// In fr, this message translates to:
  /// **'enfant(s)'**
  String get kidsCount;

  /// No description provided for @cancelLabel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancelLabel;

  /// No description provided for @validateLabel.
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get validateLabel;

  /// No description provided for @invoicesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Factures & Règlements'**
  String get invoicesTitle;

  /// No description provided for @dateLabel.
  ///
  /// In fr, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @paidStatus.
  ///
  /// In fr, this message translates to:
  /// **'PAYÉE'**
  String get paidStatus;

  /// No description provided for @pendingStatus.
  ///
  /// In fr, this message translates to:
  /// **'EN ATTENTE'**
  String get pendingStatus;

  /// No description provided for @effectueStatus.
  ///
  /// In fr, this message translates to:
  /// **'EFFECTUÉ'**
  String get effectueStatus;

  /// No description provided for @todayLabel.
  ///
  /// In fr, this message translates to:
  /// **'Aujourd\'hui'**
  String get todayLabel;

  /// No description provided for @arrivalsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune arrivée prévue aujourd\'hui.'**
  String get arrivalsTitle;

  /// No description provided for @departuresTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun départ prévu aujourd\'hui.'**
  String get departuresTitle;

  /// No description provided for @assignedRoomLabel.
  ///
  /// In fr, this message translates to:
  /// **'Chambre attribuée :'**
  String get assignedRoomLabel;

  /// No description provided for @assignRoomLabel.
  ///
  /// In fr, this message translates to:
  /// **'Attribuer une chambre :'**
  String get assignRoomLabel;

  /// No description provided for @selectOption.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner'**
  String get selectOption;

  /// No description provided for @confirmCheckinButton.
  ///
  /// In fr, this message translates to:
  /// **'CONFIRMER LE CHECK-IN'**
  String get confirmCheckinButton;

  /// No description provided for @invoiceBalanceLabel.
  ///
  /// In fr, this message translates to:
  /// **'Solde Facture'**
  String get invoiceBalanceLabel;

  /// No description provided for @settleCheckoutButton.
  ///
  /// In fr, this message translates to:
  /// **'RÉGLER & CHECK-OUT'**
  String get settleCheckoutButton;

  /// No description provided for @interactivePlanTitle.
  ///
  /// In fr, this message translates to:
  /// **'Plan interactif des chambres'**
  String get interactivePlanTitle;

  /// No description provided for @interactivePlanSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez une chambre pour voir les détails d\'occupation et propreté.'**
  String get interactivePlanSubtitle;

  /// No description provided for @maintenanceStatus.
  ///
  /// In fr, this message translates to:
  /// **'Maintenance'**
  String get maintenanceStatus;

  /// No description provided for @cleanStatus.
  ///
  /// In fr, this message translates to:
  /// **'Propre'**
  String get cleanStatus;

  /// No description provided for @dirtyStatus.
  ///
  /// In fr, this message translates to:
  /// **'Sale'**
  String get dirtyStatus;

  /// No description provided for @cleaningStatus.
  ///
  /// In fr, this message translates to:
  /// **'Ménage en cours'**
  String get cleaningStatus;

  /// No description provided for @activeOccupantLabel.
  ///
  /// In fr, this message translates to:
  /// **'OCCUPANT ACTUEL'**
  String get activeOccupantLabel;

  /// No description provided for @roomAvailableMessage.
  ///
  /// In fr, this message translates to:
  /// **'Chambre disponible à la location.'**
  String get roomAvailableMessage;

  /// No description provided for @roomMaintenanceMessage.
  ///
  /// In fr, this message translates to:
  /// **'Chambre hors service.'**
  String get roomMaintenanceMessage;

  /// No description provided for @closeButton.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get closeButton;

  /// No description provided for @welcomeBack.
  ///
  /// In fr, this message translates to:
  /// **'Bon retour parmi nous'**
  String get welcomeBack;

  /// No description provided for @loginSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous à votre espace client'**
  String get loginSubtitle;

  /// No description provided for @noAccountYet.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de compte ?'**
  String get noAccountYet;

  /// No description provided for @createAccount.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get createAccount;

  /// No description provided for @backToHome.
  ///
  /// In fr, this message translates to:
  /// **'Retour à l\'accueil'**
  String get backToHome;

  /// No description provided for @joinSlogan.
  ///
  /// In fr, this message translates to:
  /// **'Rejoignez Sweet Rest Aparthotel'**
  String get joinSlogan;

  /// No description provided for @genderLabel.
  ///
  /// In fr, this message translates to:
  /// **'GENRE / SEXE'**
  String get genderLabel;

  /// No description provided for @maleGender.
  ///
  /// In fr, this message translates to:
  /// **'Masculin'**
  String get maleGender;

  /// No description provided for @femaleGender.
  ///
  /// In fr, this message translates to:
  /// **'Féminin'**
  String get femaleGender;

  /// No description provided for @companyNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Raison Sociale'**
  String get companyNameLabel;

  /// No description provided for @createProfileButton.
  ///
  /// In fr, this message translates to:
  /// **'Créer le profil'**
  String get createProfileButton;

  /// No description provided for @physicalAddressLabel.
  ///
  /// In fr, this message translates to:
  /// **'Adresse physique'**
  String get physicalAddressLabel;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In fr, this message translates to:
  /// **'Déjà un compte ?'**
  String get alreadyHaveAccount;

  /// No description provided for @countryLabel.
  ///
  /// In fr, this message translates to:
  /// **'Pays'**
  String get countryLabel;

  /// No description provided for @addedToCart.
  ///
  /// In fr, this message translates to:
  /// **'Chambres ajoutées au panier !'**
  String get addedToCart;

  /// No description provided for @addedToCartSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous poursuivre vos réservations ou valider directement ce que vous avez déjà fait ?'**
  String get addedToCartSubtitle;

  /// No description provided for @poursuivre.
  ///
  /// In fr, this message translates to:
  /// **'Poursuivre'**
  String get poursuivre;

  /// No description provided for @validerDirectement.
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get validerDirectement;

  /// No description provided for @errorNoConnectionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune connexion'**
  String get errorNoConnectionTitle;

  /// No description provided for @errorNoConnectionSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Vérifiez votre connexion internet et réessayez.'**
  String get errorNoConnectionSubtitle;

  /// No description provided for @errorServerTitle.
  ///
  /// In fr, this message translates to:
  /// **'Erreur serveur'**
  String get errorServerTitle;

  /// No description provided for @errorServerSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Le serveur de l\'hôtel rencontre des difficultés. Veuillez réessayer.'**
  String get errorServerSubtitle;

  /// No description provided for @errorUnexpectedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Erreur inattendue'**
  String get errorUnexpectedTitle;

  /// No description provided for @errorUnexpectedSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur s\'est produite. Veuillez réessayer.'**
  String get errorUnexpectedSubtitle;

  /// No description provided for @errorRetryButton.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get errorRetryButton;

  /// No description provided for @emptyStateDefaultTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune donnée disponible'**
  String get emptyStateDefaultTitle;

  /// No description provided for @emptyStateDefaultSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Il n\'y a rien à afficher pour le moment.'**
  String get emptyStateDefaultSubtitle;

  /// No description provided for @searchRoomsTab.
  ///
  /// In fr, this message translates to:
  /// **'Recherche de Chambres'**
  String get searchRoomsTab;

  /// No description provided for @myCartTab.
  ///
  /// In fr, this message translates to:
  /// **'Mon Panier'**
  String get myCartTab;

  /// No description provided for @myProfileTab.
  ///
  /// In fr, this message translates to:
  /// **'Mon Profil'**
  String get myProfileTab;

  /// No description provided for @phoneNumberHint.
  ///
  /// In fr, this message translates to:
  /// **'07 07 07 07 07'**
  String get phoneNumberHint;

  /// No description provided for @selectCountryDialCode.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner l\'indicatif'**
  String get selectCountryDialCode;

  /// No description provided for @searchCountry.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un pays...'**
  String get searchCountry;

  /// No description provided for @confirmLogoutTitle.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer la déconnexion'**
  String get confirmLogoutTitle;

  /// No description provided for @confirmLogoutMessage.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir vous déconnecter ?'**
  String get confirmLogoutMessage;

  /// No description provided for @confirmDeleteTitle.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer la suppression'**
  String get confirmDeleteTitle;

  /// No description provided for @confirmDeleteMessage.
  ///
  /// In fr, this message translates to:
  /// **'Cette action est irréversible. Voulez-vous continuer ?'**
  String get confirmDeleteMessage;

  /// No description provided for @deleteRoomTypeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer la typologie'**
  String get deleteRoomTypeTitle;

  /// No description provided for @deleteRoomTypeMessage.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir supprimer cette typologie de chambre ?'**
  String get deleteRoomTypeMessage;

  /// No description provided for @deleteServiceTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le service'**
  String get deleteServiceTitle;

  /// No description provided for @deleteServiceMessage.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir supprimer ce service ?'**
  String get deleteServiceMessage;

  /// No description provided for @removeCartItemTitle.
  ///
  /// In fr, this message translates to:
  /// **'Retirer du panier'**
  String get removeCartItemTitle;

  /// No description provided for @removeCartItemMessage.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir retirer cette chambre du panier ?'**
  String get removeCartItemMessage;

  /// No description provided for @deleteLabel.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get deleteLabel;

  /// No description provided for @confirmLabel.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get confirmLabel;

  /// No description provided for @filterAll.
  ///
  /// In fr, this message translates to:
  /// **'Tous'**
  String get filterAll;

  /// No description provided for @filterConfirmed.
  ///
  /// In fr, this message translates to:
  /// **'Confirmé'**
  String get filterConfirmed;

  /// No description provided for @filterPast.
  ///
  /// In fr, this message translates to:
  /// **'Passé'**
  String get filterPast;

  /// No description provided for @filterCancelled.
  ///
  /// In fr, this message translates to:
  /// **'Annulé'**
  String get filterCancelled;

  /// No description provided for @filterCheckIn.
  ///
  /// In fr, this message translates to:
  /// **'Check-in'**
  String get filterCheckIn;

  /// No description provided for @filterCheckOut.
  ///
  /// In fr, this message translates to:
  /// **'Check-out'**
  String get filterCheckOut;

  /// No description provided for @searchBookingsPlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une réservation...'**
  String get searchBookingsPlaceholder;

  /// No description provided for @visioPlanningTab.
  ///
  /// In fr, this message translates to:
  /// **'Visio Planning'**
  String get visioPlanningTab;

  /// No description provided for @kanbanTab.
  ///
  /// In fr, this message translates to:
  /// **'Tableau Kanban'**
  String get kanbanTab;

  /// No description provided for @calendarViewTab.
  ///
  /// In fr, this message translates to:
  /// **'Vue Calendrier'**
  String get calendarViewTab;

  /// No description provided for @editBookingTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la réservation'**
  String get editBookingTitle;

  /// No description provided for @assignedRoom.
  ///
  /// In fr, this message translates to:
  /// **'Chambre assignée'**
  String get assignedRoom;

  /// No description provided for @changeRoomLabel.
  ///
  /// In fr, this message translates to:
  /// **'Changer la chambre'**
  String get changeRoomLabel;

  /// No description provided for @checkInDate.
  ///
  /// In fr, this message translates to:
  /// **'Date d\'arrivée (Check-in)'**
  String get checkInDate;

  /// No description provided for @checkOutDate.
  ///
  /// In fr, this message translates to:
  /// **'Date de départ (Check-out)'**
  String get checkOutDate;

  /// No description provided for @occupantName.
  ///
  /// In fr, this message translates to:
  /// **'Nom de l\'occupant'**
  String get occupantName;

  /// No description provided for @statusLabel.
  ///
  /// In fr, this message translates to:
  /// **'Statut'**
  String get statusLabel;

  /// No description provided for @adultsLabel.
  ///
  /// In fr, this message translates to:
  /// **'Adultes'**
  String get adultsLabel;

  /// No description provided for @kidsLabel.
  ///
  /// In fr, this message translates to:
  /// **'Enfants'**
  String get kidsLabel;

  /// No description provided for @dateOverlapError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur : chevauchement de dates avec une autre réservation !'**
  String get dateOverlapError;

  /// No description provided for @roomChangeSuccess.
  ///
  /// In fr, this message translates to:
  /// **'La chambre a été réassignée avec succès.'**
  String get roomChangeSuccess;

  /// No description provided for @saveSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Modifications enregistrées avec succès.'**
  String get saveSuccess;

  /// No description provided for @roomAssignmentTitle.
  ///
  /// In fr, this message translates to:
  /// **'Affectations Chambres'**
  String get roomAssignmentTitle;

  /// No description provided for @editPrice.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le prix'**
  String get editPrice;

  /// No description provided for @adjustDiscount.
  ///
  /// In fr, this message translates to:
  /// **'Ajuster la réduction'**
  String get adjustDiscount;

  /// No description provided for @globalDiscount.
  ///
  /// In fr, this message translates to:
  /// **'Réduction globale'**
  String get globalDiscount;

  /// No description provided for @discountPercentageLabel.
  ///
  /// In fr, this message translates to:
  /// **'Pourcentage de réduction (%)'**
  String get discountPercentageLabel;

  /// No description provided for @payBooking.
  ///
  /// In fr, this message translates to:
  /// **'Régler la réservation'**
  String get payBooking;

  /// No description provided for @paymentSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Règlement effectué avec succès'**
  String get paymentSuccess;

  /// No description provided for @paymentMethod.
  ///
  /// In fr, this message translates to:
  /// **'Mode de règlement'**
  String get paymentMethod;

  /// No description provided for @amountToPay.
  ///
  /// In fr, this message translates to:
  /// **'Montant à régler'**
  String get amountToPay;

  /// No description provided for @confirmPayment.
  ///
  /// In fr, this message translates to:
  /// **'Valider le règlement'**
  String get confirmPayment;

  /// No description provided for @cashMethod.
  ///
  /// In fr, this message translates to:
  /// **'Espèces'**
  String get cashMethod;

  /// No description provided for @cardMethod.
  ///
  /// In fr, this message translates to:
  /// **'Carte Bancaire'**
  String get cardMethod;

  /// No description provided for @mobileMoneyMethod.
  ///
  /// In fr, this message translates to:
  /// **'Mobile Money'**
  String get mobileMoneyMethod;

  /// No description provided for @stayLabel.
  ///
  /// In fr, this message translates to:
  /// **'Séjour :'**
  String get stayLabel;

  /// No description provided for @nightsLabel.
  ///
  /// In fr, this message translates to:
  /// **'nuit(s)'**
  String get nightsLabel;

  /// No description provided for @occupantLabel.
  ///
  /// In fr, this message translates to:
  /// **'Occupant :'**
  String get occupantLabel;

  /// No description provided for @roomLabel.
  ///
  /// In fr, this message translates to:
  /// **'Chambre :'**
  String get roomLabel;

  /// No description provided for @financialSummary.
  ///
  /// In fr, this message translates to:
  /// **'RÉCAPITULATIF FINANCIER'**
  String get financialSummary;

  /// No description provided for @subtotal.
  ///
  /// In fr, this message translates to:
  /// **'Sous-total :'**
  String get subtotal;

  /// No description provided for @taxesAndServices.
  ///
  /// In fr, this message translates to:
  /// **'Taxes & Services :'**
  String get taxesAndServices;

  /// No description provided for @included.
  ///
  /// In fr, this message translates to:
  /// **'Inclus'**
  String get included;

  /// No description provided for @totalPrice.
  ///
  /// In fr, this message translates to:
  /// **'PRIX TOTAL (TTC) :'**
  String get totalPrice;

  /// No description provided for @accommodationLabel.
  ///
  /// In fr, this message translates to:
  /// **'HÉBERGEMENT · {type}'**
  String accommodationLabel(String type);

  /// No description provided for @roomNumberPrefix.
  ///
  /// In fr, this message translates to:
  /// **'Chambre {number}'**
  String roomNumberPrefix(String number);

  /// No description provided for @freeWifi.
  ///
  /// In fr, this message translates to:
  /// **'Wifi gratuit'**
  String get freeWifi;

  /// No description provided for @airConditioned.
  ///
  /// In fr, this message translates to:
  /// **'Climatisé'**
  String get airConditioned;

  /// No description provided for @privateLounge.
  ///
  /// In fr, this message translates to:
  /// **'Salon privé'**
  String get privateLounge;

  /// No description provided for @optionalExtraBed.
  ///
  /// In fr, this message translates to:
  /// **'Lit d\'appoint optionnel'**
  String get optionalExtraBed;

  /// No description provided for @extraBedPrice.
  ///
  /// In fr, this message translates to:
  /// **'+ 15 000 FCFA / nuit'**
  String get extraBedPrice;

  /// No description provided for @startingFrom.
  ///
  /// In fr, this message translates to:
  /// **'À partir de'**
  String get startingFrom;

  /// No description provided for @reserveButton.
  ///
  /// In fr, this message translates to:
  /// **'RÉSERVER'**
  String get reserveButton;

  /// No description provided for @unavailableButton.
  ///
  /// In fr, this message translates to:
  /// **'INDISPONIBLE'**
  String get unavailableButton;

  /// No description provided for @chooseButton.
  ///
  /// In fr, this message translates to:
  /// **'CHOISIR'**
  String get chooseButton;

  /// No description provided for @priceFormat.
  ///
  /// In fr, this message translates to:
  /// **'{price} FCFA / nuit'**
  String priceFormat(String price);

  /// No description provided for @subtotalRoom.
  ///
  /// In fr, this message translates to:
  /// **'Sous-total chambre :'**
  String get subtotalRoom;

  /// No description provided for @nightsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} nuit(s)'**
  String nightsCount(int count);

  /// No description provided for @normalizedTaxReceipt.
  ///
  /// In fr, this message translates to:
  /// **'Reçu Fiscal Normalisé'**
  String get normalizedTaxReceipt;

  /// No description provided for @billingVerification.
  ///
  /// In fr, this message translates to:
  /// **'Vérification de votre facturation et règlement.'**
  String get billingVerification;

  /// No description provided for @billingInformation.
  ///
  /// In fr, this message translates to:
  /// **'Informations Facturation'**
  String get billingInformation;

  /// No description provided for @clientType.
  ///
  /// In fr, this message translates to:
  /// **'Type de client :'**
  String get clientType;

  /// No description provided for @selectClient.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner le Client'**
  String get selectClient;

  /// No description provided for @bookOnBehalfOf.
  ///
  /// In fr, this message translates to:
  /// **'Réserver pour le compte de...'**
  String get bookOnBehalfOf;

  /// No description provided for @individualClient.
  ///
  /// In fr, this message translates to:
  /// **'Client Individuel'**
  String get individualClient;

  /// No description provided for @individual.
  ///
  /// In fr, this message translates to:
  /// **'Particulier'**
  String get individual;

  /// No description provided for @partnerAgency.
  ///
  /// In fr, this message translates to:
  /// **'Agence Partenaire'**
  String get partnerAgency;

  /// No description provided for @corporate.
  ///
  /// In fr, this message translates to:
  /// **'Entreprise / Corporate'**
  String get corporate;

  /// No description provided for @socialReason.
  ///
  /// In fr, this message translates to:
  /// **'Raison Sociale'**
  String get socialReason;

  /// No description provided for @companyNamePlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'Nom entreprise'**
  String get companyNamePlaceholder;

  /// No description provided for @socialReasonRequired.
  ///
  /// In fr, this message translates to:
  /// **'La raison sociale est requise.'**
  String get socialReasonRequired;

  /// No description provided for @clientLabel.
  ///
  /// In fr, this message translates to:
  /// **'Client :'**
  String get clientLabel;

  /// No description provided for @ifuLabel.
  ///
  /// In fr, this message translates to:
  /// **'Numéro IFU (DGI)'**
  String get ifuLabel;

  /// No description provided for @ifuRequiredError.
  ///
  /// In fr, this message translates to:
  /// **'L\'IFU est obligatoire pour les professionnels.'**
  String get ifuRequiredError;

  /// No description provided for @ifuLengthError.
  ///
  /// In fr, this message translates to:
  /// **'L\'IFU doit comporter au moins 10 chiffres.'**
  String get ifuLengthError;

  /// No description provided for @ifuBilled.
  ///
  /// In fr, this message translates to:
  /// **'IFU Facturé :'**
  String get ifuBilled;

  /// No description provided for @confirmBookingLabel.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer la Réservation'**
  String get confirmBookingLabel;

  /// No description provided for @printingTaxReceipt.
  ///
  /// In fr, this message translates to:
  /// **'Impression du reçu fiscal lancée...'**
  String get printingTaxReceipt;

  /// No description provided for @printDgiInvoice.
  ///
  /// In fr, this message translates to:
  /// **'Imprimer la Facture DGI'**
  String get printDgiInvoice;

  /// No description provided for @bookingDetailsTitle.
  ///
  /// In fr, this message translates to:
  /// **'DÉTAILS DES RÉSERVATIONS'**
  String get bookingDetailsTitle;

  /// No description provided for @extraBedBilled.
  ///
  /// In fr, this message translates to:
  /// **'  • Lit d\'appoint inclus (+15 000 FCFA/nuit)'**
  String get extraBedBilled;

  /// No description provided for @breakfastBilled.
  ///
  /// In fr, this message translates to:
  /// **'  • Petit déjeuner ×{count} (+5 000 FCFA/unité)'**
  String breakfastBilled(int count);

  /// No description provided for @roomBaseHt.
  ///
  /// In fr, this message translates to:
  /// **'Base Chambres HT'**
  String get roomBaseHt;

  /// No description provided for @extrasBaseHt.
  ///
  /// In fr, this message translates to:
  /// **'Base Extras HT'**
  String get extrasBaseHt;

  /// No description provided for @totalNetHt.
  ///
  /// In fr, this message translates to:
  /// **'Total Net HT'**
  String get totalNetHt;

  /// No description provided for @tvaLabel.
  ///
  /// In fr, this message translates to:
  /// **'TVA (18%)'**
  String get tvaLabel;

  /// No description provided for @tstLabel.
  ///
  /// In fr, this message translates to:
  /// **'TST (2.5%)'**
  String get tstLabel;

  /// No description provided for @stayTaxLabel.
  ///
  /// In fr, this message translates to:
  /// **'Taxe de Séjour Municipale'**
  String get stayTaxLabel;

  /// No description provided for @totalTtcLabel.
  ///
  /// In fr, this message translates to:
  /// **'TOTAL TTC'**
  String get totalTtcLabel;

  /// No description provided for @dgiInvoiceCertified.
  ///
  /// In fr, this message translates to:
  /// **'FACTURE CERTIFIÉE DGI'**
  String get dgiInvoiceCertified;

  /// No description provided for @dgiSignature.
  ///
  /// In fr, this message translates to:
  /// **'Signature'**
  String get dgiSignature;

  /// No description provided for @paymentDate.
  ///
  /// In fr, this message translates to:
  /// **'Date paiement'**
  String get paymentDate;

  /// No description provided for @ifuAcquirer.
  ///
  /// In fr, this message translates to:
  /// **'IFU Acquéreur'**
  String get ifuAcquirer;

  /// No description provided for @bookingDetailTitle.
  ///
  /// In fr, this message translates to:
  /// **'Détail Réservation'**
  String get bookingDetailTitle;

  /// No description provided for @cancelledStatus.
  ///
  /// In fr, this message translates to:
  /// **'Annulée'**
  String get cancelledStatus;

  /// No description provided for @stayDuration.
  ///
  /// In fr, this message translates to:
  /// **'Durée du séjour :'**
  String get stayDuration;

  /// No description provided for @clientInformationHeader.
  ///
  /// In fr, this message translates to:
  /// **'INFORMATIONS CLIENT'**
  String get clientInformationHeader;

  /// No description provided for @occupantNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom de l\'occupant :'**
  String get occupantNameLabel;

  /// No description provided for @adultsCountLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nombre d\'adultes :'**
  String get adultsCountLabel;

  /// No description provided for @childrenCountLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nombre d\'enfants :'**
  String get childrenCountLabel;

  /// No description provided for @reservedItemsHeader.
  ///
  /// In fr, this message translates to:
  /// **'ÉLÉMENTS RÉSERVÉS'**
  String get reservedItemsHeader;

  /// No description provided for @noBookingFoundTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune réservation trouvée'**
  String get noBookingFoundTitle;

  /// No description provided for @noBookingMatchingCriteria.
  ///
  /// In fr, this message translates to:
  /// **'Aucune réservation ne correspond à vos critères de recherche.'**
  String get noBookingMatchingCriteria;

  /// No description provided for @noBookingYet.
  ///
  /// In fr, this message translates to:
  /// **'Vous n\'avez pas encore effectué de réservation chez nous.'**
  String get noBookingYet;

  /// No description provided for @resetFilters.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser les filtres'**
  String get resetFilters;

  /// No description provided for @bookNow.
  ///
  /// In fr, this message translates to:
  /// **'Réserver maintenant'**
  String get bookNow;

  /// No description provided for @periodOfStay.
  ///
  /// In fr, this message translates to:
  /// **'Période de séjour'**
  String get periodOfStay;

  /// No description provided for @totalAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant total'**
  String get totalAmount;

  /// No description provided for @cancelBookingTitle.
  ///
  /// In fr, this message translates to:
  /// **'Annuler la réservation'**
  String get cancelBookingTitle;

  /// No description provided for @cancelBookingConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir annuler votre réservation {reference} ?'**
  String cancelBookingConfirm(String reference);

  /// No description provided for @chooseDatesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Choix des dates'**
  String get chooseDatesTitle;

  /// No description provided for @verifyAvailability.
  ///
  /// In fr, this message translates to:
  /// **'Vérifier la disponibilité'**
  String get verifyAvailability;

  /// No description provided for @toLabel.
  ///
  /// In fr, this message translates to:
  /// **'au'**
  String get toLabel;

  /// No description provided for @quantityChoiceTitle.
  ///
  /// In fr, this message translates to:
  /// **'Choix de la quantité'**
  String get quantityChoiceTitle;

  /// No description provided for @unitPriceLabel.
  ///
  /// In fr, this message translates to:
  /// **'Prix unitaire'**
  String get unitPriceLabel;

  /// No description provided for @nightLabel.
  ///
  /// In fr, this message translates to:
  /// **'nuit'**
  String get nightLabel;

  /// No description provided for @roomsQuantityToBook.
  ///
  /// In fr, this message translates to:
  /// **'Quantité de chambres à réserver'**
  String get roomsQuantityToBook;

  /// No description provided for @availableRoomsCount.
  ///
  /// In fr, this message translates to:
  /// **'({count} chambre(s) disponible(s) sur cette période)'**
  String availableRoomsCount(int count);

  /// No description provided for @estimatedTotal.
  ///
  /// In fr, this message translates to:
  /// **'Total estimé'**
  String get estimatedTotal;

  /// No description provided for @professionalSpace.
  ///
  /// In fr, this message translates to:
  /// **'Espace Professionnel'**
  String get professionalSpace;

  /// No description provided for @clientSpace.
  ///
  /// In fr, this message translates to:
  /// **'Espace Client'**
  String get clientSpace;

  /// No description provided for @idEmailLabel.
  ///
  /// In fr, this message translates to:
  /// **'Identifiant / Email :'**
  String get idEmailLabel;

  /// No description provided for @profileLabel.
  ///
  /// In fr, this message translates to:
  /// **'Profil :'**
  String get profileLabel;

  /// No description provided for @phoneLabelWithColon.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone :'**
  String get phoneLabelWithColon;

  /// No description provided for @notSpecified.
  ///
  /// In fr, this message translates to:
  /// **'Non renseigné'**
  String get notSpecified;

  /// No description provided for @systemRoleLabel.
  ///
  /// In fr, this message translates to:
  /// **'Rôle système :'**
  String get systemRoleLabel;

  /// No description provided for @countryLabelWithColon.
  ///
  /// In fr, this message translates to:
  /// **'Pays :'**
  String get countryLabelWithColon;

  /// No description provided for @addressLabelWithColon.
  ///
  /// In fr, this message translates to:
  /// **'Adresse :'**
  String get addressLabelWithColon;

  /// No description provided for @searchRoom.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une chambre'**
  String get searchRoom;

  /// No description provided for @authSessionExpired.
  ///
  /// In fr, this message translates to:
  /// **'Erreur d\'authentification ou session expirée.'**
  String get authSessionExpired;

  /// No description provided for @passwordChangeComingSoon.
  ///
  /// In fr, this message translates to:
  /// **'La modification du mot de passe sera bientôt disponible dans une future mise à jour.'**
  String get passwordChangeComingSoon;

  /// No description provided for @aboutUsTitle.
  ///
  /// In fr, this message translates to:
  /// **'À propos de nous'**
  String get aboutUsTitle;

  /// No description provided for @myAccountSection.
  ///
  /// In fr, this message translates to:
  /// **'Mon Compte'**
  String get myAccountSection;

  /// No description provided for @updatePasswordSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Mettre à jour votre mot de passe'**
  String get updatePasswordSubtitle;

  /// No description provided for @preferencesSection.
  ///
  /// In fr, this message translates to:
  /// **'Préférences'**
  String get preferencesSection;

  /// No description provided for @appThemeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Thème de l\'application'**
  String get appThemeTitle;

  /// No description provided for @chooseThemeSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisir le mode d\'affichage'**
  String get chooseThemeSubtitle;

  /// No description provided for @systemTheme.
  ///
  /// In fr, this message translates to:
  /// **'Système'**
  String get systemTheme;

  /// No description provided for @lightTheme.
  ///
  /// In fr, this message translates to:
  /// **'Clair'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In fr, this message translates to:
  /// **'Sombre'**
  String get darkTheme;

  /// No description provided for @languageTitle.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get languageTitle;

  /// No description provided for @changeLanguageSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Changer la langue de l\'application'**
  String get changeLanguageSubtitle;

  /// No description provided for @notificationsSecuritySection.
  ///
  /// In fr, this message translates to:
  /// **'Notifications & Sécurité'**
  String get notificationsSecuritySection;

  /// No description provided for @notificationsPushTitle.
  ///
  /// In fr, this message translates to:
  /// **'Notifications Push'**
  String get notificationsPushTitle;

  /// No description provided for @notificationsPushSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Recevoir des alertes de réservation'**
  String get notificationsPushSubtitle;

  /// No description provided for @biometricSecurityTitle.
  ///
  /// In fr, this message translates to:
  /// **'Sécurité Biométrique'**
  String get biometricSecurityTitle;

  /// No description provided for @biometricSecuritySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Connexion par empreinte / FaceID'**
  String get biometricSecuritySubtitle;

  /// No description provided for @applicationSection.
  ///
  /// In fr, this message translates to:
  /// **'Application'**
  String get applicationSection;

  /// No description provided for @discoverAparthotelSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Découvrir Sweet Rest Aperthotel'**
  String get discoverAparthotelSubtitle;

  /// No description provided for @checkInLabel.
  ///
  /// In fr, this message translates to:
  /// **'Arrivée'**
  String get checkInLabel;

  /// No description provided for @checkOutLabel.
  ///
  /// In fr, this message translates to:
  /// **'Départ'**
  String get checkOutLabel;

  /// No description provided for @equipmentsTab.
  ///
  /// In fr, this message translates to:
  /// **'Équipements'**
  String get equipmentsTab;

  /// No description provided for @searchEquipmentPlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un équipement...'**
  String get searchEquipmentPlaceholder;

  /// No description provided for @equipment.
  ///
  /// In fr, this message translates to:
  /// **'Équipement'**
  String get equipment;

  /// No description provided for @allFilter.
  ///
  /// In fr, this message translates to:
  /// **'Tout'**
  String get allFilter;

  /// No description provided for @availableStatus.
  ///
  /// In fr, this message translates to:
  /// **'Disponible'**
  String get availableStatus;

  /// No description provided for @unavailableStatus.
  ///
  /// In fr, this message translates to:
  /// **'Indisponible'**
  String get unavailableStatus;

  /// No description provided for @addEquipment.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un équipement'**
  String get addEquipment;

  /// No description provided for @editEquipment.
  ///
  /// In fr, this message translates to:
  /// **'Modifier l\'équipement'**
  String get editEquipment;

  /// No description provided for @equipmentNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom de l\'équipement'**
  String get equipmentNameLabel;

  /// No description provided for @deleteEquipmentTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer l\'équipement'**
  String get deleteEquipmentTitle;

  /// No description provided for @deleteEquipmentConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir supprimer l\'équipement {name} ?'**
  String deleteEquipmentConfirm(Object name);

  /// No description provided for @noDescription.
  ///
  /// In fr, this message translates to:
  /// **'Aucune description'**
  String get noDescription;

  /// No description provided for @restrictToTypology.
  ///
  /// In fr, this message translates to:
  /// **'Restreindre à la typologie ({type})'**
  String restrictToTypology(Object type);

  /// No description provided for @completedStatus.
  ///
  /// In fr, this message translates to:
  /// **'Terminée'**
  String get completedStatus;

  /// No description provided for @confirmedStatus.
  ///
  /// In fr, this message translates to:
  /// **'Confirmée'**
  String get confirmedStatus;

  /// No description provided for @selectRoomPlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner une chambre'**
  String get selectRoomPlaceholder;

  /// No description provided for @currentRoomLabel.
  ///
  /// In fr, this message translates to:
  /// **'Actuelle'**
  String get currentRoomLabel;

  /// No description provided for @overlapWarning.
  ///
  /// In fr, this message translates to:
  /// **'Attention : Chevauchement'**
  String get overlapWarning;

  /// No description provided for @settingsTab.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settingsTab;

  /// No description provided for @proforma.
  ///
  /// In fr, this message translates to:
  /// **'PROFORMA'**
  String get proforma;

  /// No description provided for @addToCart.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter au panier'**
  String get addToCart;

  /// No description provided for @selectAll.
  ///
  /// In fr, this message translates to:
  /// **'Tout sélectionner'**
  String get selectAll;

  /// No description provided for @selectedRoomsCount.
  ///
  /// In fr, this message translates to:
  /// **'{selected} / {total} cochée(s)'**
  String selectedRoomsCount(int selected, int total);

  /// No description provided for @cartSummaryTitle.
  ///
  /// In fr, this message translates to:
  /// **'RÉSUMÉ DE LA SÉLECTION'**
  String get cartSummaryTitle;

  /// No description provided for @selectedAccommodations.
  ///
  /// In fr, this message translates to:
  /// **'Hébergements sélectionnés'**
  String get selectedAccommodations;

  /// No description provided for @freeBreakfastIncluded.
  ///
  /// In fr, this message translates to:
  /// **'Petit-déjeuner inclus (Offert)'**
  String get freeBreakfastIncluded;

  /// No description provided for @taxesIncludedNote.
  ///
  /// In fr, this message translates to:
  /// **'Taxes de séjour & TVA incluses'**
  String get taxesIncludedNote;

  /// No description provided for @proceedToBooking.
  ///
  /// In fr, this message translates to:
  /// **'Passer à la réservation ({count} chambre(s))'**
  String proceedToBooking(int count);

  /// No description provided for @selectAtLeastOneRoom.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez au moins une chambre'**
  String get selectAtLeastOneRoom;

  /// No description provided for @addMoreRooms.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter d\'autres chambres'**
  String get addMoreRooms;

  /// No description provided for @emptyCartTitle.
  ///
  /// In fr, this message translates to:
  /// **'Votre panier est vide'**
  String get emptyCartTitle;

  /// No description provided for @emptyCartSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Découvrez nos hébergements et ajoutez vos chambres préférées pour commencer votre séjour.'**
  String get emptyCartSubtitle;

  /// No description provided for @viewAvailability.
  ///
  /// In fr, this message translates to:
  /// **'Voir les disponibilités'**
  String get viewAvailability;

  /// No description provided for @loginValidationError.
  ///
  /// In fr, this message translates to:
  /// **'Renseignez une adresse e-mail valide et un mot de passe d’au moins 6 caractères.'**
  String get loginValidationError;

  /// No description provided for @yourSweetRestSpace.
  ///
  /// In fr, this message translates to:
  /// **'VOTRE ESPACE SWEET REST'**
  String get yourSweetRestSpace;

  /// No description provided for @signedOutSuccessMessage.
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes maintenant déconnecté(e) en toute sécurité.'**
  String get signedOutSuccessMessage;

  /// No description provided for @emailAddressRequired.
  ///
  /// In fr, this message translates to:
  /// **'ADRESSE E-MAIL *'**
  String get emailAddressRequired;

  /// No description provided for @emailPlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'vous@exemple.com'**
  String get emailPlaceholder;

  /// No description provided for @passwordRequired.
  ///
  /// In fr, this message translates to:
  /// **'MOT DE PASSE *'**
  String get passwordRequired;

  /// No description provided for @rememberMe.
  ///
  /// In fr, this message translates to:
  /// **'Rester connecté(e)'**
  String get rememberMe;

  /// No description provided for @changePasswordTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le mot de passe'**
  String get changePasswordTitle;

  /// No description provided for @continueButton.
  ///
  /// In fr, this message translates to:
  /// **'CONTINUER →'**
  String get continueButton;

  /// No description provided for @fillAllRequiredFields.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez remplir tous les champs obligatoires.'**
  String get fillAllRequiredFields;

  /// No description provided for @passwordTooShort.
  ///
  /// In fr, this message translates to:
  /// **'Le mot de passe doit contenir au moins 6 caractères.'**
  String get passwordTooShort;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In fr, this message translates to:
  /// **'Les mots de passe ne correspondent pas.'**
  String get passwordsDoNotMatch;

  /// No description provided for @accountCreationHeader.
  ///
  /// In fr, this message translates to:
  /// **'CRÉATION DE COMPTE'**
  String get accountCreationHeader;

  /// No description provided for @joinUsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Rejoignez-nous.'**
  String get joinUsTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Créez votre compte pour réserver votre séjour et accéder à nos services.'**
  String get registerSubtitle;

  /// No description provided for @firstNameRequired.
  ///
  /// In fr, this message translates to:
  /// **'PRÉNOM *'**
  String get firstNameRequired;

  /// No description provided for @firstNamePlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'Jean'**
  String get firstNamePlaceholder;

  /// No description provided for @lastNameRequired.
  ///
  /// In fr, this message translates to:
  /// **'NOM *'**
  String get lastNameRequired;

  /// No description provided for @lastNamePlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'Dupont'**
  String get lastNamePlaceholder;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In fr, this message translates to:
  /// **'CONFIRMER MOT DE PASSE *'**
  String get confirmPasswordRequired;

  /// No description provided for @createMyAccountButton.
  ///
  /// In fr, this message translates to:
  /// **'CRÉER MON COMPTE →'**
  String get createMyAccountButton;

  /// No description provided for @fillAllFields.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez remplir tous les champs.'**
  String get fillAllFields;

  /// No description provided for @newPasswordTooShort.
  ///
  /// In fr, this message translates to:
  /// **'Le nouveau mot de passe doit contenir au moins 8 caractères.'**
  String get newPasswordTooShort;

  /// No description provided for @passwordChangedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe modifié avec succès.'**
  String get passwordChangedSuccess;

  /// No description provided for @resetHeader.
  ///
  /// In fr, this message translates to:
  /// **'SÉCURITÉ DU COMPTE'**
  String get resetHeader;

  /// No description provided for @changePasswordSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez votre mot de passe actuel ainsi que le nouveau.'**
  String get changePasswordSubtitle;

  /// No description provided for @currentPasswordRequired.
  ///
  /// In fr, this message translates to:
  /// **'MOT DE PASSE ACTUEL *'**
  String get currentPasswordRequired;

  /// No description provided for @newPasswordRequired.
  ///
  /// In fr, this message translates to:
  /// **'NOUVEAU MOT DE PASSE *'**
  String get newPasswordRequired;

  /// No description provided for @confirmNewPasswordRequired.
  ///
  /// In fr, this message translates to:
  /// **'CONFIRMER NOUVEAU MOT DE PASSE *'**
  String get confirmNewPasswordRequired;

  /// No description provided for @changeMyPasswordButton.
  ///
  /// In fr, this message translates to:
  /// **'MODIFIER MON MOT DE PASSE →'**
  String get changeMyPasswordButton;

  /// No description provided for @cancelAndReturn.
  ///
  /// In fr, this message translates to:
  /// **'← Annuler et revenir'**
  String get cancelAndReturn;

  /// No description provided for @enterFullSixDigitCode.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez saisir le code complet à 6 chiffres.'**
  String get enterFullSixDigitCode;

  /// No description provided for @secureVerificationHeader.
  ///
  /// In fr, this message translates to:
  /// **'VÉRIFICATION SÉCURISÉE'**
  String get secureVerificationHeader;

  /// No description provided for @confirmationCodeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Code de confirmation'**
  String get confirmationCodeTitle;

  /// No description provided for @enterCodeSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez le code à 6 chiffres envoyé sur votre adresse e-mail.'**
  String get enterCodeSubtitle;

  /// No description provided for @verifyCodeButton.
  ///
  /// In fr, this message translates to:
  /// **'VÉRIFIER LE CODE →'**
  String get verifyCodeButton;

  /// No description provided for @didNotReceiveCode.
  ///
  /// In fr, this message translates to:
  /// **'Vous n\'avez rien reçu ? '**
  String get didNotReceiveCode;

  /// No description provided for @newCodeSentSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Un nouveau code a été envoyé.'**
  String get newCodeSentSuccess;

  /// No description provided for @resendCode.
  ///
  /// In fr, this message translates to:
  /// **'Renvoyer le code'**
  String get resendCode;

  /// No description provided for @endOfSessionHeader.
  ///
  /// In fr, this message translates to:
  /// **'FIN DE SESSION'**
  String get endOfSessionHeader;

  /// No description provided for @leavingUsAlreadyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vous nous quittez déjà ?'**
  String get leavingUsAlreadyTitle;

  /// No description provided for @logoutSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Votre session sera fermée sur cet appareil. Vous pourrez vous reconnecter à tout moment.'**
  String get logoutSubtitle;

  /// No description provided for @logoutSecurityNotice.
  ///
  /// In fr, this message translates to:
  /// **'Pour votre sécurité, fermez votre navigateur après la déconnexion sur un appareil partagé.'**
  String get logoutSecurityNotice;

  /// No description provided for @sessionStillActive.
  ///
  /// In fr, this message translates to:
  /// **'Votre session reste active.'**
  String get sessionStillActive;

  /// No description provided for @staySignedIn.
  ///
  /// In fr, this message translates to:
  /// **'Rester connecté(e)'**
  String get staySignedIn;

  /// No description provided for @logMeOutButton.
  ///
  /// In fr, this message translates to:
  /// **'Me déconnecter'**
  String get logMeOutButton;

  /// No description provided for @needHelpContactReception.
  ///
  /// In fr, this message translates to:
  /// **'Besoin d\'aide ? Contactez la réception Sweet Rest.'**
  String get needHelpContactReception;

  /// No description provided for @haveAReservation.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez une réservation ?'**
  String get haveAReservation;

  /// No description provided for @accessMyStay.
  ///
  /// In fr, this message translates to:
  /// **'Accéder à mon séjour'**
  String get accessMyStay;

  /// No description provided for @modifyEmail.
  ///
  /// In fr, this message translates to:
  /// **'Modifier l\'e-mail'**
  String get modifyEmail;

  /// No description provided for @codeExpiresInTenMinutes.
  ///
  /// In fr, this message translates to:
  /// **'Le code expire dans 10 minutes.'**
  String get codeExpiresInTenMinutes;

  /// No description provided for @changeYourPasswordTitle.
  ///
  /// In fr, this message translates to:
  /// **'Changez votre mot de passe.'**
  String get changeYourPasswordTitle;

  /// No description provided for @newPasswordHelper.
  ///
  /// In fr, this message translates to:
  /// **'8 caractères minimum'**
  String get newPasswordHelper;

  /// No description provided for @rememberYourPassword.
  ///
  /// In fr, this message translates to:
  /// **'Vous vous souvenez de votre mot de passe ? Se connecter'**
  String get rememberYourPassword;

  /// No description provided for @myStayTitle.
  ///
  /// In fr, this message translates to:
  /// **'Votre séjour à venir'**
  String get myStayTitle;

  /// No description provided for @myStaySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Les détails utiles, réunis au même endroit.'**
  String get myStaySubtitle;

  /// No description provided for @nextMomentHeader.
  ///
  /// In fr, this message translates to:
  /// **'VOTRE PROCHAIN MOMENT'**
  String get nextMomentHeader;

  /// No description provided for @inDaysCountdown.
  ///
  /// In fr, this message translates to:
  /// **'Dans {days} jours'**
  String inDaysCountdown(Object days);

  /// No description provided for @yourBookingCode.
  ///
  /// In fr, this message translates to:
  /// **'VOTRE CODE'**
  String get yourBookingCode;

  /// No description provided for @digitalKeyActivate.
  ///
  /// In fr, this message translates to:
  /// **'Activer ma clé digitale'**
  String get digitalKeyActivate;

  /// No description provided for @digitalKeyRequested.
  ///
  /// In fr, this message translates to:
  /// **'Clé digitale demandée'**
  String get digitalKeyRequested;

  /// No description provided for @digitalKeyAvailableNotice.
  ///
  /// In fr, this message translates to:
  /// **'Votre clé digitale sera disponible le jour de votre arrivée à partir de 14:00.'**
  String get digitalKeyAvailableNotice;

  /// No description provided for @modifyStay.
  ///
  /// In fr, this message translates to:
  /// **'Modifier mon séjour'**
  String get modifyStay;

  /// No description provided for @prepareYourArrival.
  ///
  /// In fr, this message translates to:
  /// **'Préparez votre arrivée'**
  String get prepareYourArrival;

  /// No description provided for @prepareArrivalSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Dites-nous ce qui rendra votre accueil plus fluide.'**
  String get prepareArrivalSubtitle;

  /// No description provided for @arrivalSlot.
  ///
  /// In fr, this message translates to:
  /// **'CRÉNEAU D’ARRIVÉE'**
  String get arrivalSlot;

  /// No description provided for @airportTransfer.
  ///
  /// In fr, this message translates to:
  /// **'Transfert aéroport'**
  String get airportTransfer;

  /// No description provided for @airportTransferSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Notre équipe vous recontactera pour les détails de votre vol.'**
  String get airportTransferSubtitle;

  /// No description provided for @specialRequests.
  ///
  /// In fr, this message translates to:
  /// **'Une attention particulière ?'**
  String get specialRequests;

  /// No description provided for @specialRequestsPlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'Ex. arrivée avec un enfant, oreiller ferme…'**
  String get specialRequestsPlaceholder;

  /// No description provided for @savePreferences.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer mes préférences'**
  String get savePreferences;

  /// No description provided for @preferencesSavedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Vos préférences d’arrivée ont été transmises à la réception.'**
  String get preferencesSavedSuccess;

  /// No description provided for @yourLandmarks.
  ///
  /// In fr, this message translates to:
  /// **'Vos repères'**
  String get yourLandmarks;

  /// No description provided for @yourLandmarksSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Tout ce qui vous attend à l’hôtel.'**
  String get yourLandmarksSubtitle;

  /// No description provided for @wifiLandmarkTitle.
  ///
  /// In fr, this message translates to:
  /// **'Wi-Fi haut débit'**
  String get wifiLandmarkTitle;

  /// No description provided for @wifiLandmarkDesc.
  ///
  /// In fr, this message translates to:
  /// **'Vos accès sont disponibles dès votre arrivée.'**
  String get wifiLandmarkDesc;

  /// No description provided for @transferLandmarkTitle.
  ///
  /// In fr, this message translates to:
  /// **'Transfert aéroport'**
  String get transferLandmarkTitle;

  /// No description provided for @transferLandmarkDesc.
  ///
  /// In fr, this message translates to:
  /// **'Activez-le dans vos préférences si vous le souhaitez.'**
  String get transferLandmarkDesc;

  /// No description provided for @roomServiceLandmarkTitle.
  ///
  /// In fr, this message translates to:
  /// **'Room service & Sweetie'**
  String get roomServiceLandmarkTitle;

  /// No description provided for @roomServiceLandmarkDesc.
  ///
  /// In fr, this message translates to:
  /// **'Une attention ou un dîner, à demander quand vous le voulez.'**
  String get roomServiceLandmarkDesc;

  /// No description provided for @editStayDialogTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier mon séjour'**
  String get editStayDialogTitle;

  /// No description provided for @editStayNotice.
  ///
  /// In fr, this message translates to:
  /// **'La réception confirmera toute modification selon les disponibilités et les conditions de votre tarif.'**
  String get editStayNotice;

  /// No description provided for @desiredCheckIn.
  ///
  /// In fr, this message translates to:
  /// **'Arrivée souhaitée'**
  String get desiredCheckIn;

  /// No description provided for @desiredCheckOut.
  ///
  /// In fr, this message translates to:
  /// **'Départ souhaité'**
  String get desiredCheckOut;

  /// No description provided for @messageToReception.
  ///
  /// In fr, this message translates to:
  /// **'Votre message à la réception'**
  String get messageToReception;

  /// No description provided for @messageToReceptionPlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'Indiquez votre demande…'**
  String get messageToReceptionPlaceholder;

  /// No description provided for @sendRequest.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer la demande'**
  String get sendRequest;

  /// No description provided for @modificationRequestSent.
  ///
  /// In fr, this message translates to:
  /// **'Votre demande de modification a bien été envoyée à la réception.'**
  String get modificationRequestSent;

  /// No description provided for @tabBook.
  ///
  /// In fr, this message translates to:
  /// **'Réserver'**
  String get tabBook;

  /// No description provided for @tabStays.
  ///
  /// In fr, this message translates to:
  /// **'Séjours'**
  String get tabStays;

  /// No description provided for @bookingTitleSub.
  ///
  /// In fr, this message translates to:
  /// **'VOTRE ESCAPADE, EN TOUTE LIBERTÉ'**
  String get bookingTitleSub;

  /// No description provided for @bookingTitleMain.
  ///
  /// In fr, this message translates to:
  /// **'Réservez votre parenthèse.'**
  String get bookingTitleMain;

  /// No description provided for @bookingTitleDesc.
  ///
  /// In fr, this message translates to:
  /// **'Le confort d’un hôtel, l’intimité de chez vous.'**
  String get bookingTitleDesc;

  /// No description provided for @bookingStepSelection.
  ///
  /// In fr, this message translates to:
  /// **'Sélection'**
  String get bookingStepSelection;

  /// No description provided for @bookingStepCart.
  ///
  /// In fr, this message translates to:
  /// **'Ajout au panier'**
  String get bookingStepCart;

  /// No description provided for @bookingDatesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vos dates de séjour'**
  String get bookingDatesTitle;

  /// No description provided for @bookingBreakfastIncluded.
  ///
  /// In fr, this message translates to:
  /// **'Le petit-déjeuner est inclus et offert pour toute réservation.'**
  String get bookingBreakfastIncluded;

  /// No description provided for @arrivalLabelUpper.
  ///
  /// In fr, this message translates to:
  /// **'ARRIVÉE *'**
  String get arrivalLabelUpper;

  /// No description provided for @departureLabelUpper.
  ///
  /// In fr, this message translates to:
  /// **'DÉPART *'**
  String get departureLabelUpper;

  /// No description provided for @guestsLabelUpper.
  ///
  /// In fr, this message translates to:
  /// **'VOYAGEURS'**
  String get guestsLabelUpper;

  /// No description provided for @chooseAccommodation.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez votre hébergement'**
  String get chooseAccommodation;

  /// No description provided for @insufficientCapacity.
  ///
  /// In fr, this message translates to:
  /// **'Capacité insuffisante'**
  String get insufficientCapacity;

  /// No description provided for @selectedBadge.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnée'**
  String get selectedBadge;

  /// No description provided for @selectedRoomButton.
  ///
  /// In fr, this message translates to:
  /// **'Chambre sélectionnée'**
  String get selectedRoomButton;

  /// No description provided for @chooseRoomButton.
  ///
  /// In fr, this message translates to:
  /// **'CHOISIR CETTE CHAMBRE'**
  String get chooseRoomButton;

  /// No description provided for @roomAddedToCartTitleUpper.
  ///
  /// In fr, this message translates to:
  /// **'CHAMBRE AJOUTÉE AU PANIER'**
  String get roomAddedToCartTitleUpper;

  /// No description provided for @selectionSavedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Sélection enregistrée'**
  String get selectionSavedTitle;

  /// No description provided for @stayDatesLabel.
  ///
  /// In fr, this message translates to:
  /// **'Dates de séjour'**
  String get stayDatesLabel;

  /// No description provided for @accommodationItemLabel.
  ///
  /// In fr, this message translates to:
  /// **'Hébergement'**
  String get accommodationItemLabel;

  /// No description provided for @breakfastLabel.
  ///
  /// In fr, this message translates to:
  /// **'Petit-déjeuner'**
  String get breakfastLabel;

  /// No description provided for @breakfastOfferedByHotel.
  ///
  /// In fr, this message translates to:
  /// **'Offert par l\'hôtel'**
  String get breakfastOfferedByHotel;

  /// No description provided for @accommodationAmountLabel.
  ///
  /// In fr, this message translates to:
  /// **'Montant hébergement'**
  String get accommodationAmountLabel;

  /// No description provided for @viewCartAndValidateButton.
  ///
  /// In fr, this message translates to:
  /// **'VOIR LE PANIER ET VALIDER'**
  String get viewCartAndValidateButton;

  /// No description provided for @addAnotherRoomButton.
  ///
  /// In fr, this message translates to:
  /// **'AJOUTER UNE AUTRE CHAMBRE'**
  String get addAnotherRoomButton;

  /// No description provided for @addToCartUpperButton.
  ///
  /// In fr, this message translates to:
  /// **'AJOUTER AU PANIER'**
  String get addToCartUpperButton;

  /// No description provided for @popularBadge.
  ///
  /// In fr, this message translates to:
  /// **'Plus populaire'**
  String get popularBadge;

  /// No description provided for @gardenView.
  ///
  /// In fr, this message translates to:
  /// **'Vue Jardin'**
  String get gardenView;

  /// No description provided for @poolView.
  ///
  /// In fr, this message translates to:
  /// **'Vue Piscine'**
  String get poolView;

  /// No description provided for @panoramicView.
  ///
  /// In fr, this message translates to:
  /// **'Vue Panoramique'**
  String get panoramicView;

  /// No description provided for @standardRoomName.
  ///
  /// In fr, this message translates to:
  /// **'Chambre Standard'**
  String get standardRoomName;

  /// No description provided for @premiumRoomName.
  ///
  /// In fr, this message translates to:
  /// **'Chambre Premium'**
  String get premiumRoomName;

  /// No description provided for @deluxeSuiteName.
  ///
  /// In fr, this message translates to:
  /// **'Suite Deluxe'**
  String get deluxeSuiteName;

  /// No description provided for @standardRoomDesc.
  ///
  /// In fr, this message translates to:
  /// **'Chambre élégante et fonctionnelle, équipée d’un lit Queen-Size, espace bureau et Wi-Fi haut débit.'**
  String get standardRoomDesc;

  /// No description provided for @premiumRoomDesc.
  ///
  /// In fr, this message translates to:
  /// **'Chambre spacieuse avec coin salon, machine espresso, lit King-Size et baignoire relaxante.'**
  String get premiumRoomDesc;

  /// No description provided for @deluxeSuiteDesc.
  ///
  /// In fr, this message translates to:
  /// **'Notre suite haut de gamme disposant d’un salon séparé, service de majordome sur demande et terrasse privée.'**
  String get deluxeSuiteDesc;

  /// No description provided for @standardRoomStandingDesc.
  ///
  /// In fr, this message translates to:
  /// **'Chambre de grand standing avec petit-déjeuner offert.'**
  String get standardRoomStandingDesc;

  /// No description provided for @guestsCountSingular.
  ///
  /// In fr, this message translates to:
  /// **'{count} voyageur'**
  String guestsCountSingular(int count);

  /// No description provided for @guestsCountPlural.
  ///
  /// In fr, this message translates to:
  /// **'{count} voyageurs'**
  String guestsCountPlural(int count);

  /// No description provided for @availabilitiesForDates.
  ///
  /// In fr, this message translates to:
  /// **'Disponibilités du {checkIn} au {checkOut} (Petit-déjeuner offert).'**
  String availabilitiesForDates(String checkIn, String checkOut);

  /// No description provided for @availableSingular.
  ///
  /// In fr, this message translates to:
  /// **'{count} disponible'**
  String availableSingular(int count);

  /// No description provided for @availablePlural.
  ///
  /// In fr, this message translates to:
  /// **'{count} disponibles'**
  String availablePlural(int count);

  /// No description provided for @startingFromPerNight.
  ///
  /// In fr, this message translates to:
  /// **'à partir de {price} / nuit'**
  String startingFromPerNight(String price);

  /// No description provided for @roomAddedToCartDesc.
  ///
  /// In fr, this message translates to:
  /// **'Votre hébergement \'{roomName}\' pour {nights} nuit(s) a été ajouté à votre panier. Le petit-déjeuner est offert !'**
  String roomAddedToCartDesc(String roomName, int nights);

  /// No description provided for @unassignedBookingsBanner.
  ///
  /// In fr, this message translates to:
  /// **'Réservations à attribuer'**
  String get unassignedBookingsBanner;

  /// No description provided for @totalRooms.
  ///
  /// In fr, this message translates to:
  /// **'Total Chambres'**
  String get totalRooms;

  /// No description provided for @occupancyRateLabel.
  ///
  /// In fr, this message translates to:
  /// **'Taux d\'occupation'**
  String get occupancyRateLabel;

  /// No description provided for @avgPricePerNight.
  ///
  /// In fr, this message translates to:
  /// **'Prix moyen / nuit'**
  String get avgPricePerNight;

  /// No description provided for @totalCapacity.
  ///
  /// In fr, this message translates to:
  /// **'Capacité d\'accueil'**
  String get totalCapacity;

  /// No description provided for @totalRevenue.
  ///
  /// In fr, this message translates to:
  /// **'Chiffre d\'affaires'**
  String get totalRevenue;

  /// No description provided for @viewModeGrid.
  ///
  /// In fr, this message translates to:
  /// **'Grille'**
  String get viewModeGrid;

  /// No description provided for @viewModeTable.
  ///
  /// In fr, this message translates to:
  /// **'Tableau'**
  String get viewModeTable;

  /// No description provided for @unassignedStatus.
  ///
  /// In fr, this message translates to:
  /// **'Non attribuée'**
  String get unassignedStatus;

  /// No description provided for @paidAmount.
  ///
  /// In fr, this message translates to:
  /// **'Payé'**
  String get paidAmount;

  /// No description provided for @balanceDue.
  ///
  /// In fr, this message translates to:
  /// **'Reste dû'**
  String get balanceDue;

  /// No description provided for @associatedRooms.
  ///
  /// In fr, this message translates to:
  /// **'chambre(s) rattachée(s)'**
  String get associatedRooms;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
