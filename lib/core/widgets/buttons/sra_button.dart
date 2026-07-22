import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

/// Bouton SRA Hotel — 4 variantes, zéro valeur codée en dur.
///
/// Variantes disponibles :
/// ```dart
/// SraButton(label: 'Réserver', onPressed: () {})            // primary (défaut)
/// SraButton.secondary(label: 'Annuler', onPressed: () {})   // contour or
/// SraButton.ghost(label: 'Voir plus', onPressed: () {})     // texte gold
/// SraButton.danger(label: 'Supprimer', onPressed: () {})    // fond rouge
/// ```
enum SraButtonVariant { primary, secondary, ghost, danger }

class SraButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;
  final bool small;
  final SraButtonVariant variant;

  const SraButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
    this.small = false,
    SraButtonVariant? variant,
    bool isOutlined = false,
    Color? backgroundColor,
    Color? foregroundColor,
  }) : variant = variant ?? (isOutlined ? SraButtonVariant.secondary : SraButtonVariant.primary);

  const SraButton.secondary({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    bool fullWidth = true,
    bool small = false,
  }) : this(
          key: key,
          label: label,
          onPressed: onPressed,
          icon: icon,
          isLoading: isLoading,
          fullWidth: fullWidth,
          small: small,
          variant: SraButtonVariant.secondary,
        );

  const SraButton.ghost({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    bool fullWidth = false,
    bool small = false,
  }) : this(
          key: key,
          label: label,
          onPressed: onPressed,
          icon: icon,
          isLoading: isLoading,
          fullWidth: fullWidth,
          small: small,
          variant: SraButtonVariant.ghost,
        );

  const SraButton.danger({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    bool fullWidth = true,
    bool small = false,
  }) : this(
          key: key,
          label: label,
          onPressed: onPressed,
          icon: icon,
          isLoading: isLoading,
          fullWidth: fullWidth,
          small: small,
          variant: SraButtonVariant.danger,
        );

  /// Alias rétro-compatibilité — utiliser SraButton.secondary à la place.
  const SraButton.outlined({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    bool fullWidth = true,
    bool small = false,
    Color? backgroundColor,
    Color? foregroundColor,
  }) : this(
          key: key,
          label: label,
          onPressed: onPressed,
          icon: icon,
          isLoading: isLoading,
          fullWidth: fullWidth,
          small: small,
          variant: SraButtonVariant.secondary,
        );

  @override
  State<SraButton> createState() => _SraButtonState();
}

class _SraButtonState extends State<SraButton> {
  bool _hovered = false;

  bool get _isDisabled => widget.onPressed == null || widget.isLoading;

  double get _height =>
      widget.small ? AppDimensions.buttonHeightSm : AppDimensions.buttonHeight;

  EdgeInsets get _padding => widget.small
      ? const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingLg,
          vertical: AppDimensions.spacingSm,
        )
      : const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingLg,
          vertical: AppDimensions.spacingMd,
        );

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered && !_isDisabled ? 1.015 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: _buildButton(),
      ),
    );
  }

  Widget _buildButton() {
    switch (widget.variant) {
      case SraButtonVariant.primary:   return _buildPrimary();
      case SraButtonVariant.secondary: return _buildSecondary();
      case SraButtonVariant.ghost:     return _buildGhost();
      case SraButtonVariant.danger:    return _buildDanger();
    }
  }

  // ── Primary — Dégradé or + ombre dorée ───────────────────────────────────
  Widget _buildPrimary() {
    final shadow = _isDisabled ? AppShadows.goldDisabled : AppShadows.gold;
    return Opacity(
      opacity: _isDisabled ? 0.65 : 1.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: widget.fullWidth ? _height : null,
        width: widget.fullWidth ? double.infinity : null,
        decoration: BoxDecoration(
          gradient: AppColors.goldGradient,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          boxShadow: [shadow],
        ),
        child: Material(
          color: const Color(0x00000000),
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            onTap: _isDisabled ? null : widget.onPressed,
            child: Padding(
              padding: _padding,
              child: Center(child: _buildContent(AppColors.white)),
            ),
          ),
        ),
      ),
    );
  }

  // ── Secondary — Contour or ────────────────────────────────────────────────
  Widget _buildSecondary() {
    return Opacity(
      opacity: _isDisabled ? 0.55 : 1.0,
      child: SizedBox(
        height: widget.fullWidth ? _height : null,
        width: widget.fullWidth ? double.infinity : null,
        child: OutlinedButton(
          onPressed: _isDisabled ? null : widget.onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.gold,
            side: BorderSide(
              color: AppColors.gold.withValues(
                alpha: _isDisabled ? 0.4 : (_hovered ? 1.0 : 0.8),
              ),
              width: AppDimensions.borderMedium,
            ),
            padding: _padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            ),
            textStyle: widget.small
                ? AppTextStyles.buttonLabelSm
                : AppTextStyles.buttonLabel,
          ),
          child: _buildContent(AppColors.gold),
        ),
      ),
    );
  }

  // ── Ghost — Texte gold sans fond ──────────────────────────────────────────
  Widget _buildGhost() {
    return TextButton(
      onPressed: _isDisabled ? null : widget.onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.gold,
        padding: _padding,
        textStyle: widget.small
            ? AppTextStyles.buttonLabelSm
            : AppTextStyles.buttonLabel,
      ),
      child: _buildContent(AppColors.gold),
    );
  }

  // ── Danger — Fond rouge, texte blanc ─────────────────────────────────────
  Widget _buildDanger() {
    return Opacity(
      opacity: _isDisabled ? 0.55 : 1.0,
      child: SizedBox(
        height: widget.fullWidth ? _height : null,
        width: widget.fullWidth ? double.infinity : null,
        child: ElevatedButton(
          onPressed: _isDisabled ? null : widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.statusError,
            foregroundColor: AppColors.white,
            elevation: AppDimensions.cardElevation,
            padding: _padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            ),
            textStyle: widget.small
                ? AppTextStyles.buttonLabelSm
                : AppTextStyles.buttonLabel,
          ),
          child: _buildContent(AppColors.white),
        ),
      ),
    );
  }

  // ── Contenu commun ────────────────────────────────────────────────────────
  Widget _buildContent(Color fgColor) {
    if (widget.isLoading) {
      return SizedBox(
        width: AppDimensions.iconSizeMd,
        height: AppDimensions.iconSizeMd,
        child: CircularProgressIndicator(
          strokeWidth: AppDimensions.borderMedium,
          valueColor: AlwaysStoppedAnimation<Color>(fgColor),
        ),
      );
    }

    final label = Text(
      widget.label.toUpperCase(),
      style: (widget.small ? AppTextStyles.buttonLabelSm : AppTextStyles.buttonLabel)
          .copyWith(color: fgColor),
    );

    if (widget.icon == null) return label;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(widget.icon, size: AppDimensions.iconSizeSm, color: fgColor),
        const SizedBox(width: AppDimensions.spacingSm),
        label,
      ],
    );
  }
}
