import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/core/routes/app_routes.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/error_state_view.dart';
import 'package:sra_hotel/core/widgets/loading_indicator.dart';
import 'package:sra_hotel/core/widgets/responsive_list_grid_view.dart';
import 'package:sra_hotel/core/widgets/sra_button.dart';
import 'package:sra_hotel/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:sra_hotel/features/cart/presentation/bloc/cart_event.dart';
import 'package:sra_hotel/features/room_search/domain/entities/room_entity.dart';
import 'package:sra_hotel/features/client_booking/presentation/bloc/client_booking_bloc.dart';
import 'package:sra_hotel/features/client_booking/presentation/bloc/client_booking_event.dart';
import 'package:sra_hotel/features/client_booking/presentation/bloc/client_booking_state.dart';
import 'package:sra_hotel/features/client_booking/presentation/widgets/room_type_card.dart';
import 'package:sra_hotel/features/client_booking/presentation/widgets/date_selector_widget.dart';
import 'package:sra_hotel/features/client_booking/presentation/widgets/quantity_selector_widget.dart';
import 'package:sra_hotel/features/client_booking/presentation/widgets/alternative_propositions_widget.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

class ClientBookingPage extends StatefulWidget {
  const ClientBookingPage({super.key});

  @override
  State<ClientBookingPage> createState() => _ClientBookingPageState();
}

class _ClientBookingPageState extends State<ClientBookingPage> {
  @override
  void initState() {
    super.initState();
    // Charge les typologies de chambre au démarrage
    context.read<ClientBookingBloc>().add(LoadRoomTypesEvent());
  }

  Future<bool?> _showChoiceDialog(BuildContext context, AppLocalizations l10n) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.deepBlue : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusLg)),
          title: Text(
            l10n.addedToCart,
            style: AppTextStyles.titleLarge.copyWith(color: AppColors.champagneGold),
          ),
          content: Text(
            l10n.addedToCartSubtitle,
            style: AppTextStyles.bodyMedium.copyWith(color: isDark ? Colors.white70 : Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Poursuivre
              child: Text(
                l10n.poursuivre.toUpperCase(),
                style: const TextStyle(color: AppColors.champagneGold, fontWeight: FontWeight.bold),
              ),
            ),
            SraButton(
              onPressed: () => Navigator.of(context).pop(false), // Valider directement
              label: l10n.validerDirectement,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocConsumer<ClientBookingBloc, ClientBookingState>(
        listener: (context, state) {
          if (state is BookingCompletedState) {
            // 1. Met à jour les dates du panier
            context.read<CartBloc>().add(
                  CartDatesUpdated(checkIn: state.checkIn, checkOut: state.checkOut),
                );

            // 2. Ajoute les chambres réservées au panier
            for (final room in state.roomsToAdd) {
              final roomEntity = RoomEntity(
                id: room.id,
                numero: room.numero,
                idTypeDeChambre: room.idTypeDeChambre,
                statut: room.statut,
                prixNuit: room.prixNuit,
              );
              context.read<CartBloc>().add(
                    CartItemAdded(
                      roomEntity,
                      checkIn: state.checkIn,
                      checkOut: state.checkOut,
                      extraBedIncluded: false,
                    ),
                  );
            }

            if (state.continueBooking) {
              // Réinitialise le flux pour retourner à l'étape 1
              context.read<ClientBookingBloc>().add(ResetBookingFlowEvent());
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.statusSuccess,
                  content: Text(
                    l10n.addedToCart,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            } else {
              // Réinitialise le flux en arrière-plan et va au panier
              context.read<ClientBookingBloc>().add(ResetBookingFlowEvent());
              Navigator.of(context).pushNamed(AppRoutes.cart);
            }
          }
        },
        builder: (context, state) {
          if (state is ClientBookingInitial || state is CheckingAvailabilityState) {
            return const Center(child: LoadingIndicator(color: AppColors.champagneGold));
          }

          if (state is BookingErrorState) {
            return ErrorStateView(
              message: state.message,
              onRetry: () {
                context.read<ClientBookingBloc>().add(LoadRoomTypesEvent());
              },
            );
          }

          if (state is RoomTypesLoadedState) {
            return ResponsiveListGridView(
              padding: const EdgeInsets.all(AppDimensions.spacingMd),
              itemCount: state.roomTypes.length,
              maxCrossAxisExtent: 500,
              mainAxisExtent: 490,
              itemBuilder: (context, index) {
                final type = state.roomTypes[index];
                return RoomTypeCard(
                  roomType: type,
                  onSelect: () {
                    context.read<ClientBookingBloc>().add(SelectRoomTypeEvent(type));
                  },
                );
              },
            );
          }

          if (state is SelectingDatesState) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.spacingMd),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: DateSelectorWidget(
                    roomType: state.selectedType,
                    onDatesSelected: (checkIn, checkOut) {
                      context.read<ClientBookingBloc>().add(
                            SelectDatesEvent(checkIn: checkIn, checkOut: checkOut),
                          );
                    },
                    onCancel: () {
                      context.read<ClientBookingBloc>().add(ResetBookingFlowEvent());
                    },
                  ),
                ),
              ),
            );
          }

          if (state is AvailabilityResultState) {
            if (state.isAvailable) {
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimensions.spacingMd),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: QuantitySelectorWidget(
                      roomType: state.selectedType,
                      checkIn: state.checkIn,
                      checkOut: state.checkOut,
                      maxQuantity: state.maxQuantity,
                      onConfirm: (qty) async {
                        final bookingBloc = context.read<ClientBookingBloc>();
                        final continueBooking = await _showChoiceDialog(context, l10n);
                        if (continueBooking != null) {
                          bookingBloc.add(
                            ConfirmQuantityEvent(
                              quantity: qty,
                              continueBooking: continueBooking,
                            ),
                          );
                        }
                      },
                      onCancel: () {
                        context.read<ClientBookingBloc>().add(
                              SelectRoomTypeEvent(state.selectedType),
                            );
                      },
                    ),
                  ),
                ),
              );
            } else {
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimensions.spacingMd),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: AlternativePropositionsWidget(
                      selectedType: state.selectedType,
                      alternatives: state.alternatives,
                      onSelectAlternative: (altType) {
                        // Sélectionne l'alternative et relance la recherche pour les mêmes dates
                        context.read<ClientBookingBloc>().add(SelectRoomTypeEvent(altType));
                        context.read<ClientBookingBloc>().add(
                              SelectDatesEvent(checkIn: state.checkIn, checkOut: state.checkOut),
                            );
                      },
                      onCancel: () {
                        context.read<ClientBookingBloc>().add(ResetBookingFlowEvent());
                      },
                    ),
                  ),
                ),
              );
            }
          }

          return const SizedBox();
        },
      ),
    );
  }
}
