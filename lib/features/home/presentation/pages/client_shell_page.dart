import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/core/routes/app_routes.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_event.dart';
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
import 'package:sra_hotel/core/widgets/widgets.dart';
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
  // L'onglet Réservations (index 1) est l'onglet par défaut selon la demande utilisateur
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
        child: const ClientBookingPage(),
      ),
      BlocProvider<AdminBookingBloc>(
        create: (_) => di.sl<AdminBookingBloc>()..add(LoadAdminBookingsEvent()),
        child: ClientReservationsPage(
          onNavigateToSearch: () => _onTabTapped(0),
        ),
      ),
      const CartPage(),
      BlocProvider<AdminBookingBloc>(
        create: (_) => di.sl<AdminBookingBloc>()..add(LoadAdminBookingsEvent()),
        child: const ClientProfilePage(),
      ),
      const SettingsPage(),
    ];

    final titles = [
      l10n.searchRoomsTab,
      l10n.bookingsTitle,
      l10n.myCartTab,
      l10n.myProfileTab,
      "Paramètres",
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
            IconButton(
              icon: const Icon(
                Icons.logout_outlined,
                color: AppColors.statusError,
              ),
              onPressed: () async {
                final confirmed = await ConfirmDeleteDialog.show(
                  context,
                  title: l10n.confirmLogoutTitle,
                  message: l10n.confirmLogoutMessage,
                  confirmLabel: l10n.logout,
                  cancelLabel: l10n.cancelLabel,
                  isDestructive: false,
                );
                if (confirmed && context.mounted) {
                  context.read<AuthBloc>().add(LogoutRequested());
                }
              },
            ),
            const SizedBox(width: AppDimensions.spacingSm),
          ],
        ),
        body: isWide
            ? Row(
                children: [
                  NavigationRail(
                    selectedIndex: _currentIndex,
                    onDestinationSelected: _onTabTapped,
                    indicatorColor: AppColors.champagneGold.withValues(alpha: 0.15),
                    selectedIconTheme: const IconThemeData(color: AppColors.champagneGold),
                    unselectedIconTheme: const IconThemeData(color: AppColors.textMuted),
                    selectedLabelTextStyle: const TextStyle(color: AppColors.champagneGold, fontWeight: FontWeight.bold),
                    unselectedLabelTextStyle: const TextStyle(color: AppColors.textMuted),
                    labelType: NavigationRailLabelType.all,
                    backgroundColor: isDark ? AppColors.imperialNightBlue : AppColors.surfaceLight,
                    destinations: [
                      const NavigationRailDestination(
                        icon: Icon(Icons.search_outlined),
                        selectedIcon: Icon(Icons.search),
                        label: Text("Recherche"),
                      ),
                      const NavigationRailDestination(
                        icon: Icon(Icons.calendar_today_outlined),
                        selectedIcon: Icon(Icons.calendar_today),
                        label: Text("Réservations"),
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
                        label: const Text("Panier"),
                      ),
                      const NavigationRailDestination(
                        icon: Icon(Icons.person_outline),
                        selectedIcon: Icon(Icons.person),
                        label: Text("Profil"),
                      ),
                      const NavigationRailDestination(
                        icon: Icon(Icons.settings_outlined),
                        selectedIcon: Icon(Icons.settings),
                        label: Text("Paramètres"),
                      ),
                    ],
                  ),
                  const VerticalDivider(thickness: 1, width: 1),
                  Expanded(child: pages[_currentIndex]),
                ],
              )
            : pages[_currentIndex],
        bottomNavigationBar: isWide
            ? null
            : BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: _onTabTapped,
                selectedItemColor: AppColors.champagneGold,
                unselectedItemColor: AppColors.textMuted,
                type: BottomNavigationBarType.fixed,
                backgroundColor: isDark ? AppColors.imperialNightBlue : AppColors.surfaceLight,
                items: [
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.search_outlined),
                    activeIcon: Icon(Icons.search),
                    label: "Recherche",
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_today_outlined),
                    activeIcon: Icon(Icons.calendar_today),
                    label: "Réservations",
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
                    label: "Panier",
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline),
                    activeIcon: Icon(Icons.person),
                    label: "Profil",
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.settings_outlined),
                    activeIcon: Icon(Icons.settings),
                    label: "Paramètres",
                  ),
                ],
              ),
      ),
    );
  }
}
