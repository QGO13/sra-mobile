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
