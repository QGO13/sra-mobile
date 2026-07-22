# Conventions d'Internationalisation (l10n) — SRA Hôtel Mobile

Ce document décrit le fonctionnement et les conventions de développement pour l'internationalisation (l10n) de l'application SRA Hôtel Mobile.

---

## 1. Structure et Dictionnaires (ARB)
Toutes les chaînes de l'interface utilisateur destinées à être lues par l'utilisateur final doivent être externalisées dans les fichiers de traduction sous `lib/l10n/`.
Nous supportons **6 langues** principales :
* `app_fr.arb` (Français - Langue par défaut de référence)
* `app_en.arb` (Anglais)
* `app_es.arb` (Espagnol)
* `app_de.arb` (Allemand)
* `app_ar.arb` (Arabe - Support RTL)
* `app_zh.arb` (Chinois - Caractères idéographiques)

### Exemple de clé de traduction
```json
"welcomeMessage": "Bienvenue chez SRA Hôtel",
"@welcomeMessage": {
  "description": "Message de bienvenue affiché sur la page d'accueil"
}
```

---

## 2. Processus de Génération du Code
Pour compiler les dictionnaires au format `.arb` en classes d'accès Dart typées, exécutez la commande suivante à la racine du projet :
```bash
flutter gen-l10n
```
Les fichiers générés sont placés dans le dossier local `lib/l10n/` en accord avec le fichier `l10n.yaml` (`synthetic-l10n: false`).

---

## 3. Résolution du Bug d'Encodage Windows (UTF-8 BOM)
Sur les postes de développement sous Windows, la console système par défaut (ANSI/Windows-1252) peut provoquer des erreurs d'encodage lors de la compilation ou de l'exécution sur le web. Les caractères accentués risquent de se transformer en symboles corrompus (ex : `Ã©` au lieu de `é`).

### Solution obligatoire
Après chaque appel à `flutter gen-l10n` ou après l'édition manuelle d'un dictionnaire `.arb`, vous devez exécuter le script de forçage UTF-8 BOM. Ce script insère le marqueur d'en-tête UTF-8 BOM (`0xEF`, `0xBB`, `0xBF`) au début des fichiers générés.

```bash
dart C:\Users\darag\.gemini\antigravity\brain\b7242d41-6b80-45ce-bba1-d4f3fd4dd35c\scratch\add_bom.dart
```

---

## 4. Utilisation dans le Code Flutter
1. **Importation** :
   ```dart
   import 'package:sra_hotel/l10n/app_localizations.dart';
   ```
2. **Accès aux textes dans les Widgets** :
   ```dart
   final l10n = AppLocalizations.of(context)!;
   
   Text(l10n.welcomeMessage);
   ```

---

## 5. Bonnes Pratiques
* **Pas de chaînes brutes en dur** : Ne jamais écrire de texte direct en dur (ex : `Text("Valider")`). Utiliser `l10n.validateLabel`.
* **Remplissage simultané** : Toute nouvelle clé ajoutée dans `app_fr.arb` doit être ajoutée immédiatement dans les 5 autres fichiers avec sa traduction correcte.
* **Dates & Devises** : Utiliser la bibliothèque `intl` pour formater les dates et montants monétaires en accord avec la Locale courante.
