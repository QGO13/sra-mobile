import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/core/routes/app_routes.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_state.dart';
import 'package:sra_hotel/features/client_booking/presentation/pages/client_booking_page.dart';
import 'package:sra_hotel/features/client_booking/presentation/bloc/client_booking_bloc.dart';
import 'package:sra_hotel/features/reservation_management/presentation/bloc/admin_booking_bloc.dart';
import 'package:sra_hotel/features/reservation_management/presentation/bloc/admin_booking_event.dart';
import 'package:sra_hotel/features/reservation_management/presentation/pages/client_reservations_page.dart';
import 'package:sra_hotel/features/home/presentation/pages/client_profile_page.dart';
import 'package:sra_hotel/features/cart/presentation/pages/cart_page.dart';
import 'package:sra_hotel/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:sra_hotel/features/cart/presentation/bloc/cart_state.dart';
import 'package:sra_hotel/features/settings/presentation/pages/settings_page.dart';
import 'package:sra_hotel/injection_container.dart' as di;
import 'package:sra_hotel/l10n/app_localizations.dart';

/// Shell de navigation pour l'espace Client/Corporate.
/// Gère un affichage adaptatif : BottomNavigationBar pour mobile, NavigationRail pour grand écran.
class ClientShellPage extends StatefulWidget {
  const ClientShellPage({super.key});

  @override
  State<ClientShellPage> createState() => _ClientShellPageState();
}

class _ClientShellPageState extends State<ClientShellPage> {
  // L'onglet Séjours (index 1) est l'onglet par défaut selon la demande utilisateur
  int _currentIndex = 1;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isWide = MediaQuery.of(context).size.width >= 1024;
    final l10n = AppLocalizations.of(context)!;

    // Définition des pages d'onglets avec leurs Blocs respectifs
    final List<Widget> pages = [
      BlocProvider<ClientBookingBloc>(
        create: (_) => di.sl<ClientBookingBloc>(),
        child: ClientBookingPage(
          onNavigateToCart: () => _onTabTapped(2),
        ),
      ),
      BlocProvider<AdminBookingBloc>(
        create: (_) => di.sl<AdminBookingBloc>()..add(LoadAdminBookingsEvent()),
        child: ClientReservationsPage(
          onNavigateToSearch: () => _onTabTapped(0),
        ),
      ),
      CartPage(
        onNavigateToSearch: () => _onTabTapped(0),
      ),
      const SettingsPage(),
      BlocProvider<AdminBookingBloc>(
        create: (_) => di.sl<AdminBookingBloc>()..add(LoadAdminBookingsEvent()),
        child: const ClientProfilePage(),
      ),
    ];

    final titles = [
      l10n.tabBook,
      l10n.tabStays,
      l10n.myCartTab,
      "Paramètres",
      l10n.myProfileTab,
    ];

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            titles[_currentIndex],
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          actions: [
            // ── Bouton Profil dans l'AppBar (Remplace le bouton de déconnexion) ──
            IconButton(
              tooltip: l10n.myProfileTab,
              icon: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _currentIndex == 4 ? AppColors.champagneGold : (isDark ? Colors.white30 : AppColors.softGrey),
                    width: 1.5,
                  ),
                  color: _currentIndex == 4
                      ? AppColors.champagneGold.withValues(alpha: 0.2)
                      : (isDark ? AppColors.deepBlue : AppColors.fog),
                ),
                child: Icon(
                  Icons.person_rounded,
                  size: 20,
                  color: _currentIndex == 4 ? AppColors.champagneGold : (isDark ? Colors.white : AppColors.imperialNightBlue),
                ),
              ),
              onPressed: () => _onTabTapped(4),
            ),
            const SizedBox(width: AppDimensions.spacingSm),
          ],
        ),
        body: isWide
            ? Row(
                children: [
                  // ── NavigationRail (Sidebar Grand Écran) ──
                  NavigationRail(
                    selectedIndex: _currentIndex > 2 ? 0 : _currentIndex,
                    onDestinationSelected: (idx) {
                      if (idx < 3) {
                        _onTabTapped(idx);
                      }
                    },
                    indicatorColor: AppColors.champagneGold.withValues(alpha: 0.15),
                    selectedIconTheme: const IconThemeData(color: AppColors.champagneGold),
                    unselectedIconTheme: const IconThemeData(color: AppColors.textMuted),
                    selectedLabelTextStyle: const TextStyle(color: AppColors.champagneGold, fontWeight: FontWeight.bold),
                    unselectedLabelTextStyle: const TextStyle(color: AppColors.textMuted),
                    labelType: NavigationRailLabelType.all,
                    backgroundColor: isDark ? AppColors.imperialNightBlue : AppColors.surfaceLight,
                    destinations: [
                      NavigationRailDestination(
                        icon: const Icon(Icons.bed_outlined),
                        selectedIcon: const Icon(Icons.bed_rounded, color: AppColors.champagneGold),
                        label: Text(l10n.tabBook),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(Icons.calendar_today_outlined),
                        selectedIcon: const Icon(Icons.calendar_today_rounded, color: AppColors.champagneGold),
                        label: Text(l10n.tabStays),
                      ),
                      NavigationRailDestination(
                        icon: BlocBuilder<CartBloc, CartState>(
                          builder: (context, state) {
                            int count = 0;
                            if (state is CartUpdated) {
                              count = state.items.length;
                            }
                            return Badge(
                              isLabelVisible: count > 0,
                              label: Text(count.toString()),
                              backgroundColor: AppColors.champagneGold,
                              textColor: Colors.white,
                              child: const Icon(Icons.shopping_cart_outlined),
                            );
                          },
                        ),
                        selectedIcon: BlocBuilder<CartBloc, CartState>(
                          builder: (context, state) {
                            int count = 0;
                            if (state is CartUpdated) {
                              count = state.items.length;
                            }
                            return Badge(
                              isLabelVisible: count > 0,
                              label: Text(count.toString()),
                              backgroundColor: AppColors.champagneGold,
                              textColor: Colors.white,
                              child: const Icon(Icons.shopping_cart),
                            );
                          },
                        ),
                        label: Text(l10n.myCartTab),
                      ),
                    ],
                    // ── Bouton Paramètres tout en bas du Sidebar ──
                    trailing: Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: AppDimensions.spacingLg),
                          child: InkWell(
                            onTap: () => _onTabTapped(3),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: _currentIndex == 3
                                    ? AppColors.champagneGold.withValues(alpha: 0.15)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                                border: Border.all(
                                  color: _currentIndex == 3 ? AppColors.champagneGold : (isDark ? Colors.white10 : AppColors.softGrey),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _currentIndex == 3 ? Icons.settings_rounded : Icons.settings_outlined,
                                    color: _currentIndex == 3 ? AppColors.champagneGold : AppColors.textMuted,
                                    size: 22,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Paramètres",
                                    style: TextStyle(
                                      color: _currentIndex == 3 ? AppColors.champagneGold : AppColors.textMuted,
                                      fontWeight: _currentIndex == 3 ? FontWeight.bold : FontWeight.w500,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const VerticalDivider(thickness: 1, width: 1),
                  Expanded(child: pages[_currentIndex]),
                ],
              )
            : pages[_currentIndex],

        // ── BottomNavigationBar Mobile ──
        bottomNavigationBar: isWide
            ? null
            : BottomNavigationBar(
                currentIndex: _currentIndex > 3 ? 0 : _currentIndex,
                onTap: _onTabTapped,
                selectedItemColor: AppColors.champagneGold,
                unselectedItemColor: AppColors.textMuted,
                type: BottomNavigationBarType.fixed,
                backgroundColor: isDark ? AppColors.imperialNightBlue : AppColors.surfaceLight,
                items: [
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.bed_outlined),
                    activeIcon: const Icon(Icons.bed_rounded),
                    label: l10n.tabBook,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.calendar_today_outlined),
                    activeIcon: const Icon(Icons.calendar_today_rounded),
                    label: l10n.tabStays,
                  ),
                  BottomNavigationBarItem(
                    icon: BlocBuilder<CartBloc, CartState>(
                      builder: (context, state) {
                        int count = 0;
                        if (state is CartUpdated) {
                          count = state.items.length;
                        }
                        return Badge(
                          isLabelVisible: count > 0,
                          label: Text(count.toString()),
                          backgroundColor: AppColors.champagneGold,
                          textColor: Colors.white,
                          child: const Icon(Icons.shopping_cart_outlined),
                        );
                      },
                    ),
                    activeIcon: BlocBuilder<CartBloc, CartState>(
                      builder: (context, state) {
                        int count = 0;
                        if (state is CartUpdated) {
                          count = state.items.length;
                        }
                        return Badge(
                          isLabelVisible: count > 0,
                          label: Text(count.toString()),
                          backgroundColor: AppColors.champagneGold,
                          textColor: Colors.white,
                          child: const Icon(Icons.shopping_cart),
                        );
                      },
                    ),
                    label: l10n.myCartTab,
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.settings_outlined),
                    activeIcon: Icon(Icons.settings_rounded),
                    label: "Paramètres",
                  ),
                ],
              ),
      ),
    );
  }
}
