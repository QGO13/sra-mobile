import 'package:flutter/material.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

/// Enum representing the category of the error for user display.
enum ErrorType {
  connection,
  server,
  unexpected,
}

/// Mapper utility to convert raw error/exception messages into friendly localized strings and icons.
class ErrorMapper {
  /// Analyzes the raw error string to categorize it.
  static ErrorType getErrorType(String message) {
    final msg = message.toLowerCase();
    
    // Connection/Timeout indicators
    if (msg.contains('socket') ||
        msg.contains('connection') ||
        msg.contains('connexion') ||
        msg.contains('network') ||
        msg.contains('offline') ||
        msg.contains('timeout') ||
        msg.contains('host') ||
        msg.contains('unreachable')) {
      return ErrorType.connection;
    }
    
    // Server-side / Database indicators
    if (msg.contains('500') ||
        msg.contains('502') ||
        msg.contains('503') ||
        msg.contains('504') ||
        msg.contains('server') ||
        msg.contains('serveur') ||
        msg.contains('database') ||
        msg.contains('db ') ||
        msg.contains('sql') ||
        msg.contains('internal error')) {
      return ErrorType.server;
    }
    
    return ErrorType.unexpected;
  }

  /// Gets the localized title for the error.
  static String getTitle(String message, AppLocalizations l10n) {
    final type = getErrorType(message);
    switch (type) {
      case ErrorType.connection:
        return l10n.errorNoConnectionTitle;
      case ErrorType.server:
        return l10n.errorServerTitle;
      case ErrorType.unexpected:
        return l10n.errorUnexpectedTitle;
    }
  }

  /// Gets the localized and soothing subtitle/details for the error.
  static String getSubtitle(String message, AppLocalizations l10n) {
    final type = getErrorType(message);
    
    // For validation or direct clear business rules from backend, we preserve the user-facing message.
    final msg = message.toLowerCase();
    if (type == ErrorType.unexpected) {
      if (msg.contains('validation') ||
          msg.contains('incorrect') ||
          msg.contains('invalide') ||
          msg.contains('déjà') ||
          msg.contains('deja') ||
          msg.contains('not found') ||
          msg.contains('404') ||
          msg.contains('authentification') ||
          msg.contains('mot de passe')) {
        return message;
      }
      return l10n.errorUnexpectedSubtitle;
    }
    
    switch (type) {
      case ErrorType.connection:
        return l10n.errorNoConnectionSubtitle;
      case ErrorType.server:
        return l10n.errorServerSubtitle;
      case ErrorType.unexpected:
        return l10n.errorUnexpectedSubtitle;
    }
  }

  /// Gets the corresponding icon for the error type.
  static IconData getIcon(String message) {
    final type = getErrorType(message);
    switch (type) {
      case ErrorType.connection:
        return Icons.wifi_off_outlined;
      case ErrorType.server:
        return Icons.cloud_off_outlined;
      case ErrorType.unexpected:
        return Icons.error_outline;
    }
  }
}
