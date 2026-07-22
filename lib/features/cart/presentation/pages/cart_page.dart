import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/core/routes/app_routes.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/empty_state_view.dart';
import 'package:sra_hotel/core/widgets/sra_button.dart';
import 'package:sra_hotel/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:sra_hotel/features/cart/presentation/bloc/cart_event.dart';
import 'package:sra_hotel/features/cart/presentation/bloc/cart_state.dart';
import 'package:sra_hotel/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';
import 'package:sra_hotel/core/widgets/confirm_delete_dialog.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartInitial || (state is CartUpdated && state.items.isEmpty)) {
            return EmptyStateView(
              icon: Icons.shopping_cart_outlined,
              title: "Votre panier est vide",
              subtitle: "Découvrez nos hébergements et ajoutez vos chambres préférées pour commencer votre séjour.",
              actionLabel: "Voir les disponibilités",
              onAction: () {
                Navigator.of(context).pushNamed(AppRoutes.search);
              },
              isOutlined: false,
            );
          }

          if (state is CartUpdated) {
            final items = state.items;
            double baseSubtotal = items.fold(0.0, (sum, item) => sum + item.room.prixNuit * item.nightsCount);
            double extraSubtotal = state.cartSubtotal - baseSubtotal;

            return Column(
              children: [
                // List of selected rooms
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd, vertical: AppDimensions.spacingLg - 4),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
                        child: CartItemCard(
                          item: item,
                          onRemove: () async {
                            final cartBloc = context.read<CartBloc>();
                            final l10n = AppLocalizations.of(context)!;
                            final confirmed = await ConfirmDeleteDialog.show(
                              context,
                              title: l10n.removeCartItemTitle,
                              message: l10n.removeCartItemMessage,
                              confirmLabel: l10n.deleteLabel,
                              cancelLabel: l10n.cancelLabel,
                              isDestructive: true,
                            );
                            if (confirmed) {
                              cartBloc.add(CartItemRemoved(item.room.id));
                            }
                          },
                          onExtraBedChanged: (bool? val) {
                            context.read<CartBloc>().add(
                                  CartItemUpdated(item.room.id, extraBedIncluded: val),
                                );
                          },
                          onBreakfastChanged: (bool? val) {
                            context.read<CartBloc>().add(
                                  CartItemUpdated(item.room.id, breakfastIncluded: val),
                                );
                          },
                          onBreakfastCountChanged: (int count) {
                            context.read<CartBloc>().add(
                                  CartItemUpdated(item.room.id, breakfastCount: count),
                                );
                          },
                        ),
                      );
                    },
                  ),
                ),
                
                // Bottom summary panel matching Web
                Container(
                  padding: const EdgeInsets.all(AppDimensions.spacingLg),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.imperialNightBlue : AppColors.surfaceLight,
                    border: Border(
                      top: BorderSide(
                        color: isDark ? AppColors.overlayDark : AppColors.softGrey,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "RÉSUMÉ",
                        style: AppTextStyles.titleMedium.copyWith(
                          color: isDark ? AppColors.ecruWhite : AppColors.imperialNightBlue,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingSm + 6),
                      _buildSummaryRow(
                        "${items.length} hébergement${items.length > 1 ? 's' : ''}",
                        "${baseSubtotal.toStringAsFixed(0)} FCFA",
                        isDark,
                      ),
                      const SizedBox(height: AppDimensions.spacingSm),
                      _buildSummaryRow(
                        "Total nuits",
                        "${state.nights} nuit${state.nights > 1 ? 's' : ''}",
                        isDark,
                      ),
                      if (extraSubtotal > 0) ...[
                        const SizedBox(height: AppDimensions.spacingSm),
                        _buildSummaryRow(
                          "Suppléments & Options",
                          "${extraSubtotal.toStringAsFixed(0)} FCFA",
                          isDark,
                        ),
                      ],
                      const Divider(height: AppDimensions.spacingLg, thickness: 0.5, color: AppColors.softGrey),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total estimé",
                            style: TextStyle(fontSize: 12.5, color: AppColors.textMuted, fontWeight: FontWeight.w300),
                          ),
                          Text(
                            "${state.cartSubtotal.toStringAsFixed(0)} FCFA",
                            style: AppTextStyles.displayMedium.copyWith(color: AppColors.champagneGold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Taxes de séjour & TVA appliquées au paiement",
                          style: TextStyle(fontSize: 9, color: AppColors.textMuted, fontStyle: FontStyle.italic),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingLg - 4),
                      
                      SraButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(AppRoutes.preInvoice);
                        },
                        label: "Passer à la réservation",
                      ),
                      const SizedBox(height: AppDimensions.spacingSm + 2),
                      SraButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        label: "Ajouter une chambre",
                        isOutlined: true,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w300,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.ecruWhite.withValues(alpha: 0.7) : AppColors.imperialNightBlue,
          ),
        ),
      ],
    );
  }
}

