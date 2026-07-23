import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/core/routes/app_routes.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
import 'package:sra_hotel/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:sra_hotel/features/cart/presentation/bloc/cart_event.dart';
import 'package:sra_hotel/features/client_booking/presentation/bloc/client_booking_bloc.dart';
import 'package:sra_hotel/features/client_booking/presentation/bloc/client_booking_event.dart';
import 'package:sra_hotel/features/client_booking/presentation/bloc/client_booking_state.dart';
import 'package:sra_hotel/features/client_booking/presentation/widgets/booking_progress_widget.dart';
import 'package:sra_hotel/features/client_booking/presentation/widgets/booking_summary_sticky_bar.dart';
import 'package:sra_hotel/features/client_booking/presentation/widgets/room_offer_card.dart';
import 'package:sra_hotel/features/room_search/domain/entities/room_entity.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

/// Page de réservation Client SRA Hotel — Reproduction Pixel-Perfect de `BookingPage.tsx`.
class ClientBookingPage extends StatefulWidget {
  final VoidCallback? onNavigateToCart;
  const ClientBookingPage({super.key, this.onNavigateToCart});

  @override
  State<ClientBookingPage> createState() => _ClientBookingPageState();
}

class _ClientBookingPageState extends State<ClientBookingPage> {
  int _step = 0;

  // Données de réservation par défaut : 1 jour (aujourd'hui à demain), 1 voyageur
  DateTime _checkIn = DateTime.now();
  DateTime _checkOut = DateTime.now().add(const Duration(days: 1));
  int _guests = 1;

  StayRoomOfferData? _selectedRoom;

  late final TextEditingController _checkInController;
  late final TextEditingController _checkOutController;

  List<StayRoomOfferData> _getFallbackOffers(AppLocalizations l10n) {
    return [
      StayRoomOfferData(
        id: '1',
        name: l10n.standardRoomName,
        price: 60000,
        capacity: 2,
        surface: 28,
        view: l10n.gardenView,
        description: l10n.standardRoomDesc,
        image: 'https://images.unsplash.com/photo-1631049552057-403cdb8f0658?auto=format&fit=crop&w=800&q=80',
        available: 5,
      ),
      StayRoomOfferData(
        id: '2',
        name: l10n.premiumRoomName,
        price: 85000,
        capacity: 2,
        surface: 42,
        view: l10n.poolView,
        description: l10n.premiumRoomDesc,
        image: 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=800&q=80',
        available: 3,
        highlight: l10n.popularBadge,
      ),
      StayRoomOfferData(
        id: '3',
        name: l10n.deluxeSuiteName,
        price: 150000,
        capacity: 4,
        surface: 75,
        view: l10n.panoramicView,
        description: l10n.deluxeSuiteDesc,
        image: 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?auto=format&fit=crop&w=800&q=80',
        available: 2,
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _checkInController = TextEditingController(text: _formatDate(_checkIn));
    _checkOutController = TextEditingController(text: _formatDate(_checkOut));
    context.read<ClientBookingBloc>().add(LoadRoomTypesEvent(
          checkIn: _checkIn,
          checkOut: _checkOut,
        ));
  }

  @override
  void dispose() {
    _checkInController.dispose();
    _checkOutController.dispose();
    super.dispose();
  }

  int get _nights {
    final diff = _checkOut.difference(_checkIn).inDays;
    return diff < 1 ? 1 : diff;
  }

  bool get _dateError => _checkOut.isBefore(_checkIn) || _checkOut.isAtSameMomentAs(_checkIn);
  int get _roomSubtotal => (_selectedRoom?.price ?? 0) * _nights;
  int get _totalAmount => _roomSubtotal;

  String _formatDate(DateTime dt) {
    return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";
  }

  String _formatFcfa(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write(' ');
      }
      buffer.write(str[i]);
    }
    return '${buffer.toString()} FCFA';
  }

  void _onSelectRoom(StayRoomOfferData offer) {
    setState(() {
      _selectedRoom = offer;
      if (_guests > offer.capacity) _guests = offer.capacity;
    });
  }

  void _navigateToCart() {
    if (widget.onNavigateToCart != null) {
      widget.onNavigateToCart!();
    } else {
      Navigator.of(context).pushNamed(AppRoutes.cart);
    }
  }

  void _next() {
    if (_step == 0 && _selectedRoom != null) {
      if (_dateError || _selectedRoom!.capacity < _guests) return;

      // Enregistrement au Panier via CartBloc
      context.read<CartBloc>().add(
            CartDatesUpdated(
              checkIn: _checkIn,
              checkOut: _checkOut,
            ),
          );

      context.read<CartBloc>().add(
            CartItemAdded(
              RoomEntity(
                id: _selectedRoom!.id,
                numero: '101',
                idTypeDeChambre: _selectedRoom!.id,
                statut: 'Libre',
                prixNuit: _selectedRoom!.price.toDouble(),
              ),
              checkIn: _checkIn,
              checkOut: _checkOut,
            ),
          );

      setState(() => _step = 1);
    } else if (_step == 1) {
      _navigateToCart();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.inkMuted;
    final cardBg = isDark ? AppColors.darkCard : AppColors.white;
    final cardBorder = isDark ? AppColors.darkBorder : AppColors.mist;

    final fallbackOffers = _getFallbackOffers(l10n);
    if (_selectedRoom == null && fallbackOffers.isNotEmpty) {
      _selectedRoom = fallbackOffers[1];
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingLg,
            vertical: AppDimensions.spacingXl,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1080),
              child: Column(
                children: [
                  // ── En-tête de page ──
                  Text(
                    l10n.bookingTitleSub,
                    style: AppTextStyles.labelUppercase.copyWith(
                      color: AppColors.gold,
                      letterSpacing: 2.0,
                    ),
                  ),
                  AppDimensions.vGapXs,
                  Text(
                    l10n.bookingTitleMain,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.displayMedium.copyWith(
                      fontSize: 38,
                      color: isDark ? AppColors.white : AppColors.ink,
                    ),
                  ),
                  AppDimensions.vGapXs,
                  Text(
                    l10n.bookingTitleDesc,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: textMuted,
                    ),
                  ),
                  AppDimensions.vGapLg,

                  // ── Progress Wizard Bar (2 étapes) ──
                  BookingProgressWidget(activeStep: _step),

                  // ── STEP 0 : Choix des dates & Sélection chambre ──
                  if (_step == 0) ...[
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 760),
                      child: Container(
                        padding: const EdgeInsets.all(AppDimensions.spacingXl),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                          border: Border.all(color: cardBorder, width: AppDimensions.borderThin),
                          boxShadow: const [AppShadows.card],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.bookingDatesTitle,
                              style: AppTextStyles.titleLarge.copyWith(
                                color: isDark ? AppColors.white : AppColors.ink,
                              ),
                            ),
                            AppDimensions.vGapXs,
                            Text(
                              l10n.bookingBreakfastIncluded,
                              style: AppTextStyles.bodyMedium.copyWith(color: textMuted),
                            ),
                            AppDimensions.vGapLg,

                            Wrap(
                              spacing: AppDimensions.spacingMd,
                              runSpacing: AppDimensions.spacingMd,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                // Date Arrivée
                                SizedBox(
                                  width: 200,
                                  child: SraInput(
                                    label: l10n.arrivalLabelUpper,
                                    placeholder: _formatDate(_checkIn),
                                    controller: _checkInController,
                                    prefixIcon: const Icon(Icons.calendar_today_rounded, color: AppColors.gold, size: 18),
                                    readOnly: true,
                                    onTap: () async {
                                      final bookingBloc = context.read<ClientBookingBloc>();
                                      final picked = await showDatePicker(
                                        context: context,
                                        initialDate: _checkIn,
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now().add(const Duration(days: 365)),
                                      );
                                      if (picked != null) {
                                        await WidgetsBinding.instance.endOfFrame;
                                        if (!context.mounted) return;
                                        setState(() {
                                          _checkIn = picked;
                                          _checkInController.text = _formatDate(picked);
                                          if (_checkOut.isBefore(_checkIn) || _checkOut.isAtSameMomentAs(_checkIn)) {
                                            _checkOut = _checkIn.add(const Duration(days: 1));
                                            _checkOutController.text = _formatDate(_checkOut);
                                          }
                                        });
                                        bookingBloc.add(LoadRoomTypesEvent(
                                              checkIn: _checkIn,
                                              checkOut: _checkOut,
                                            ));
                                      }
                                    },
                                  ),
                                ),

                                // Date Départ
                                SizedBox(
                                  width: 200,
                                  child: SraInput(
                                    label: l10n.departureLabelUpper,
                                    placeholder: _formatDate(_checkOut),
                                    controller: _checkOutController,
                                    prefixIcon: const Icon(Icons.calendar_today_rounded, color: AppColors.gold, size: 18),
                                    readOnly: true,
                                    onTap: () async {
                                      final bookingBloc = context.read<ClientBookingBloc>();
                                      final picked = await showDatePicker(
                                        context: context,
                                        initialDate: _checkOut,
                                        firstDate: _checkIn.add(const Duration(days: 1)),
                                        lastDate: DateTime.now().add(const Duration(days: 365)),
                                      );
                                      if (picked != null) {
                                        await WidgetsBinding.instance.endOfFrame;
                                        if (!context.mounted) return;
                                        setState(() {
                                          _checkOut = picked;
                                          _checkOutController.text = _formatDate(picked);
                                        });
                                        bookingBloc.add(LoadRoomTypesEvent(
                                              checkIn: _checkIn,
                                              checkOut: _checkOut,
                                            ));
                                      }
                                    },
                                  ),
                                ),

                                // Nombre de voyageurs
                                SizedBox(
                                  width: 160,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.guestsLabelUpper,
                                        style: AppTextStyles.labelUppercase.copyWith(
                                          color: AppColors.gold,
                                        ),
                                      ),
                                      AppDimensions.vGapXs,
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingSm),
                                        decoration: BoxDecoration(
                                          color: isDark ? AppColors.darkSurface : AppColors.white,
                                          borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                                          border: Border.all(color: cardBorder),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<int>(
                                            value: _guests,
                                            isExpanded: true,
                                            items: [1, 2, 3, 4].map((count) {
                                              final guestLabel = count > 1
                                                  ? l10n.guestsCountPlural(count)
                                                  : l10n.guestsCountSingular(count);
                                              return DropdownMenuItem<int>(
                                                value: count,
                                                child: Text(guestLabel),
                                              );
                                            }).toList(),
                                            onChanged: (val) {
                                              if (val != null) setState(() => _guests = val);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppDimensions.vGapXl,

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.chooseAccommodation,
                            style: AppTextStyles.titleLarge.copyWith(
                              color: isDark ? AppColors.white : AppColors.ink,
                            ),
                          ),
                          AppDimensions.vGapXs,
                          Text(
                            l10n.availabilitiesForDates(_formatDate(_checkIn), _formatDate(_checkOut)),
                            style: AppTextStyles.bodySmall.copyWith(color: textMuted),
                          ),
                        ],
                      ),
                    ),
                    AppDimensions.vGapMd,

                    // Grille des offres de chambres
                    BlocBuilder<ClientBookingBloc, ClientBookingState>(
                      builder: (context, bookingState) {
                        List<StayRoomOfferData> currentOffers = fallbackOffers;

                        if (bookingState is RoomTypesLoadedState && bookingState.roomTypes.isNotEmpty) {
                          const fallbackImages = [
                            'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=800&q=80',
                            'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=800&q=80',
                            'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?auto=format&fit=crop&w=800&q=80',
                          ];

                          currentOffers = bookingState.roomTypes.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final rt = entry.value;
                            
                            String imgUrl = fallbackImages[idx % fallbackImages.length];
                            if (rt.images.isNotEmpty) {
                              final rawUrl = rt.images.first;
                              if (rawUrl.startsWith('http') && !rawUrl.contains('example.com')) {
                                imgUrl = rawUrl;
                              }
                            }

                            final desc = rt.description.isNotEmpty
                                ? rt.description
                                : l10n.standardRoomStandingDesc;

                            return StayRoomOfferData(
                              id: rt.id,
                              name: rt.nom,
                              price: rt.prixNuit.round(),
                              capacity: rt.capacite,
                              surface: 25 + (rt.capacite * 8),
                              view: idx % 2 == 0 ? l10n.gardenView : l10n.poolView,
                              description: desc,
                              image: imgUrl,
                              available: rt.availableCount,
                              highlight: idx == 1 ? l10n.popularBadge : null,
                            );
                          }).toList();
                        }

                        final currentSelectedRoom = _selectedRoom;
                        final hasSelected = currentSelectedRoom != null && currentOffers.any((o) => o.id == currentSelectedRoom.id);
                        final selectedOffer = hasSelected
                            ? currentOffers.firstWhere((o) => o.id == currentSelectedRoom.id)
                            : currentOffers.first;

                        return ResponsiveListGridView(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: currentOffers.length,
                          maxCrossAxisExtent: 440,
                          mainAxisExtent: 440,
                          itemBuilder: (context, index) {
                            final offer = currentOffers[index];
                            return Padding(
                              padding: const EdgeInsets.all(AppDimensions.spacingSm),
                              child: RoomOfferCardWidget(
                                offer: offer,
                                selected: selectedOffer.id == offer.id,
                                disabled: offer.capacity < _guests,
                                onSelect: _onSelectRoom,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],

                  // ── STEP 1 : Enregistrement et Choix Panier ──
                  if (_step == 1 && _selectedRoom != null) ...[
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 640),
                      child: Container(
                        padding: const EdgeInsets.all(AppDimensions.spacingXl),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                          border: Border.all(color: cardBorder, width: AppDimensions.borderThin),
                          boxShadow: const [AppShadows.card],
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.statusSuccess.withValues(alpha: 0.15),
                              ),
                              child: const Icon(
                                Icons.shopping_bag_outlined,
                                color: AppColors.statusSuccess,
                                size: 40,
                              ),
                            ),
                            AppDimensions.vGapLg,

                            Text(
                              l10n.roomAddedToCartTitleUpper,
                              style: AppTextStyles.labelUppercase.copyWith(
                                color: AppColors.gold,
                                letterSpacing: 2.0,
                              ),
                            ),
                            AppDimensions.vGapXs,

                            Text(
                              l10n.selectionSavedTitle,
                              style: AppTextStyles.displayMedium.copyWith(
                                fontSize: 28,
                                color: isDark ? AppColors.white : AppColors.ink,
                              ),
                            ),
                            AppDimensions.vGapXs,

                            Text(
                              l10n.roomAddedToCartDesc(_selectedRoom!.name, _nights),
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: textMuted,
                              ),
                            ),
                            AppDimensions.vGapLg,

                            Container(
                              padding: const EdgeInsets.all(AppDimensions.spacingLg),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkSurface : const Color(0xFFF6F1E8),
                                borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                              ),
                              child: Column(
                                children: [
                                  _SummaryLine(
                                    label: l10n.stayDatesLabel,
                                    value: "${_formatDate(_checkIn)} — ${_formatDate(_checkOut)}",
                                  ),
                                  AppDimensions.vGapSm,
                                  _SummaryLine(
                                    label: l10n.accommodationItemLabel,
                                    value: "${_selectedRoom!.name} · ${l10n.nightsCount(_nights)}",
                                  ),
                                  AppDimensions.vGapSm,
                                  _SummaryLine(
                                    label: l10n.breakfastLabel,
                                    value: l10n.breakfastOfferedByHotel,
                                  ),
                                  AppDimensions.vGapSm,
                                  _SummaryLine(
                                    label: l10n.accommodationAmountLabel,
                                    value: _formatFcfa(_totalAmount),
                                    isStrong: true,
                                  ),
                                ],
                              ),
                            ),
                            AppDimensions.vGapXl,

                            LayoutBuilder(
                              builder: (context, constraints) {
                                final isCompact = constraints.maxWidth < 460;
                                final primaryBtn = SraButton(
                                  label: l10n.viewCartAndValidateButton,
                                  onPressed: _navigateToCart,
                                );
                                final secondaryBtn = SraButton.secondary(
                                  label: l10n.addAnotherRoomButton,
                                  onPressed: () {
                                    setState(() => _step = 0);
                                  },
                                );

                                if (isCompact) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      primaryBtn,
                                      AppDimensions.vGapMd,
                                      secondaryBtn,
                                    ],
                                  );
                                }

                                return Row(
                                  children: [
                                    Expanded(child: secondaryBtn),
                                    AppDimensions.hGapMd,
                                    Expanded(child: primaryBtn),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  AppDimensions.vGapXl,

                  // ── Sticky Summary Bar ──
                  if (_step == 0 && _selectedRoom != null)
                    BookingSummaryStickyBarWidget(
                      roomName: _selectedRoom!.name,
                      nights: _nights,
                      guests: _guests,
                      totalAmount: _totalAmount,
                      activeStep: _step,
                      onNext: _next,
                      onBack: null,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  final String label;
  final String value;
  final bool isStrong;

  const _SummaryLine({
    required this.label,
    required this.value,
    this.isStrong = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: isDark ? AppColors.darkTextSecondary : AppColors.inkMuted,
          ),
        ),
        AppDimensions.hGapSm,
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: isStrong ? FontWeight.w700 : FontWeight.w600,
              color: isStrong ? AppColors.gold : (isDark ? AppColors.white : AppColors.ink),
            ),
          ),
        ),
      ],
    );
  }
}
