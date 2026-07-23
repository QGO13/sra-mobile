import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/core/routes/app_routes.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
import 'package:sra_hotel/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:sra_hotel/features/cart/presentation/bloc/cart_event.dart';
import 'package:sra_hotel/features/cart/presentation/bloc/cart_state.dart';
import 'package:sra_hotel/features/cart/presentation/widgets/cart_header_bar.dart';
import 'package:sra_hotel/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:sra_hotel/features/cart/presentation/widgets/cart_summary_footer.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

class CartPage extends StatelessWidget {
  final VoidCallback? onNavigateToSearch;

  const CartPage({
    super.key,
    this.onNavigateToSearch,
  });

  void _handleNavigateToSearch(BuildContext context) {
    if (onNavigateToSearch != null) {
      onNavigateToSearch!();
    } else if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushNamed(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartInitial || (state is CartUpdated && state.items.isEmpty)) {
            return EmptyStateView(
              icon: Icons.shopping_cart_outlined,
              title: l10n.emptyCartTitle,
              subtitle: l10n.emptyCartSubtitle,
              actionLabel: l10n.viewAvailability,
              onAction: () => _handleNavigateToSearch(context),
            );
          }

          if (state is CartUpdated) {
            final items = state.items;
            final selectedCount = state.selectedCount;
            final selectedSubtotal = state.selectedSubtotal;

            return Column(
              children: [
                CartHeaderBar(
                  areAllSelected: state.areAllSelected,
                  selectedCount: selectedCount,
                  totalCount: items.length,
                  onToggleAll: (val) {
                    context.read<CartBloc>().add(
                          CartAllItemsSelectionToggled(val ?? false),
                        );
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacingMd,
                      vertical: AppDimensions.spacingLg - 4,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
                        child: CartItemCard(
                          item: item,
                          onSelectionChanged: (bool? val) {
                            context.read<CartBloc>().add(
                                  CartItemSelectionToggled(item.room.id, val ?? false),
                                );
                          },
                          onRemove: () async {
                            final cartBloc = context.read<CartBloc>();
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
                        ),
                      );
                    },
                  ),
                ),
                CartSummaryFooter(
                  selectedCount: selectedCount,
                  totalCount: items.length,
                  selectedSubtotal: selectedSubtotal,
                  onProceedToBooking: selectedCount > 0
                      ? () {
                          Navigator.of(context).pushNamed(AppRoutes.preInvoice);
                        }
                      : null,
                  onAddMoreRooms: () => _handleNavigateToSearch(context),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
