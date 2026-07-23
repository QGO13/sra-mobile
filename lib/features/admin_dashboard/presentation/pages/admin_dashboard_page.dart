import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/core/routes/app_routes.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_state.dart';
import 'package:sra_hotel/features/home/presentation/pages/client_profile_page.dart';
import 'package:sra_hotel/features/backoffice_kpis/presentation/bloc/kpi_bloc.dart';
import 'package:sra_hotel/features/backoffice_kpis/presentation/bloc/kpi_event.dart';
import 'package:sra_hotel/features/backoffice_kpis/presentation/pages/admin_kpis_view.dart';
import 'package:sra_hotel/features/invoice_management/presentation/bloc/invoice_bloc.dart';
import 'package:sra_hotel/features/invoice_management/presentation/bloc/invoice_event.dart';
import 'package:sra_hotel/features/invoice_management/presentation/pages/admin_invoices_view.dart';
import 'package:sra_hotel/features/reservation_management/presentation/bloc/admin_booking_bloc.dart';
import 'package:sra_hotel/features/reservation_management/presentation/bloc/admin_booking_event.dart';
import 'package:sra_hotel/features/reservation_management/presentation/pages/admin_bookings_view.dart';
import 'package:sra_hotel/features/room_management/presentation/bloc/room_bloc.dart';
import 'package:sra_hotel/features/room_management/presentation/bloc/room_event.dart';
import 'package:sra_hotel/features/room_management/presentation/pages/admin_rooms_view.dart';
import 'package:sra_hotel/features/room_management/presentation/pages/admin_room_types_view.dart';
import 'package:sra_hotel/features/service_management/presentation/bloc/service_bloc.dart';
import 'package:sra_hotel/features/service_management/presentation/bloc/service_event.dart';
import 'package:sra_hotel/features/service_management/presentation/pages/admin_services_view.dart';
import 'package:sra_hotel/features/user_management/presentation/bloc/user_bloc.dart';
import 'package:sra_hotel/features/user_management/presentation/bloc/user_event.dart';
import 'package:sra_hotel/features/user_management/presentation/pages/admin_users_view.dart';
import 'package:sra_hotel/features/settings/presentation/pages/settings_page.dart';
import 'package:sra_hotel/features/settings/presentation/pages/about_us_page.dart';
import 'package:sra_hotel/features/room_assignment/presentation/bloc/room_assignment_bloc.dart';
import 'package:sra_hotel/features/room_assignment/presentation/bloc/room_assignment_event.dart';
import 'package:sra_hotel/features/room_assignment/presentation/pages/room_assignment_dashboard_page.dart';
import 'package:sra_hotel/features/equipment_management/presentation/bloc/equipment_bloc.dart';
import 'package:sra_hotel/features/equipment_management/presentation/bloc/equipment_event.dart';
import 'package:sra_hotel/features/equipment_management/presentation/pages/admin_equipments_view.dart';
import 'package:sra_hotel/injection_container.dart' as di;
import 'package:sra_hotel/l10n/app_localizations.dart';

import 'admin_more_view.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  late final KpiBloc _kpiBloc;
  late final RoomBloc _roomBloc;
  late final ServiceBloc _serviceBloc;
  late final UserBloc _userBloc;
  late final AdminBookingBloc _adminBookingBloc;
  late final InvoiceBloc _invoiceBloc;
  late final RoomAssignmentBloc _roomAssignmentBloc;
  late final EquipmentBloc _equipmentBloc;

  int _currentMobileIndex = 0;
  int _currentWideIndex = 0;
  bool? _isSidebarExtended;

  @override
  void initState() {
    super.initState();
    _kpiBloc = di.sl<KpiBloc>()..add(LoadKpiDashboardEvent());
    _roomBloc = di.sl<RoomBloc>()..add(LoadRoomsAndTypesEvent());
    _serviceBloc = di.sl<ServiceBloc>()..add(LoadServicesEvent());
    _userBloc = di.sl<UserBloc>()..add(LoadUsersEvent());
    _adminBookingBloc = di.sl<AdminBookingBloc>()
      ..add(LoadAdminBookingsEvent());
    _invoiceBloc = di.sl<InvoiceBloc>()..add(LoadInvoicesEvent());
    _roomAssignmentBloc = di.sl<RoomAssignmentBloc>()..add(LoadRoomAssignmentDataEvent());
    _equipmentBloc = di.sl<EquipmentBloc>()..add(LoadEquipmentsEvent());
  }

  @override
  void dispose() {
    _kpiBloc.close();
    _roomBloc.close();
    _serviceBloc.close();
    _userBloc.close();
    _adminBookingBloc.close();
    _invoiceBloc.close();
    _roomAssignmentBloc.close();
    _equipmentBloc.close();
    super.dispose();
  }

  void _selectMobileIndex(int index) {
    setState(() {
      _currentMobileIndex = index;
    });
  }

  void _selectWideIndex(int index) {
    setState(() {
      _currentWideIndex = index;
    });
  }

  void _refreshAll() {
    _kpiBloc.add(LoadKpiDashboardEvent());
    _roomBloc.add(LoadRoomsAndTypesEvent());
    _serviceBloc.add(LoadServicesEvent());
    _userBloc.add(LoadUsersEvent());
    _adminBookingBloc.add(LoadAdminBookingsEvent());
    _invoiceBloc.add(LoadInvoicesEvent());
    _roomAssignmentBloc.add(LoadRoomAssignmentDataEvent());
    _equipmentBloc.add(LoadEquipmentsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isWide = MediaQuery.of(context).size.width >= 1024;
    final isLargeDesktop = MediaQuery.of(context).size.width >= 1280;

    // --- GRAND ÉCRAN (Sidebar) : 10 onglets directs ---
    final wideTitles = [
      l10n.reportsTab,
      l10n.roomsTab,
      l10n.roomTypesTab,
      l10n.reservationsTab,
      l10n.roomAssignmentTitle,
      l10n.invoicesTab,
      l10n.servicesTab,
      l10n.personnelTab,
      l10n.equipmentsTab,
      l10n.settingsTab,
      l10n.aboutUsTitle,
    ];

    final widePages = [
      BlocProvider.value(value: _kpiBloc, child: const AdminKpisView()),
      BlocProvider.value(value: _roomBloc, child: const AdminRoomsView()),
      BlocProvider.value(value: _roomBloc, child: const AdminRoomTypesView()),
      BlocProvider.value(
        value: _adminBookingBloc,
        child: const AdminBookingsView(),
      ),
      BlocProvider.value(
        value: _roomAssignmentBloc,
        child: const RoomAssignmentDashboardPage(),
      ),
      BlocProvider.value(value: _invoiceBloc, child: const AdminInvoicesView()),
      BlocProvider.value(value: _serviceBloc, child: const AdminServicesView()),
      BlocProvider.value(value: _userBloc, child: const AdminUsersView()),
      BlocProvider.value(value: _equipmentBloc, child: const AdminEquipmentsView()),
      const SettingsPage(),
      const AboutUsPage(),
    ];

    // --- PETIT ÉCRAN (Mobile) : 4 onglets principaux + Menu ---
    final mobileTitles = [
      l10n.reportsTab,
      l10n.roomsTab,
      l10n.reservationsTab,
      l10n.invoicesTab,
      l10n.moreTab,
    ];

    final mobilePages = [
      BlocProvider.value(value: _kpiBloc, child: const AdminKpisView()),
      BlocProvider.value(value: _roomBloc, child: const AdminRoomsView()),
      BlocProvider.value(
        value: _adminBookingBloc,
        child: const AdminBookingsView(),
      ),
      BlocProvider.value(value: _invoiceBloc, child: const AdminInvoicesView()),
      AdminMoreView(
        onRefreshAll: _refreshAll,
        roomBloc: _roomBloc,
        serviceBloc: _serviceBloc,
        userBloc: _userBloc,
        roomAssignmentBloc: _roomAssignmentBloc,
        equipmentBloc: _equipmentBloc,
      ),
    ];

    final String currentTitle = isWide ? wideTitles[_currentWideIndex] : mobileTitles[_currentMobileIndex];
    final Widget currentBody = isWide
        ? IndexedStack(index: _currentWideIndex, children: widePages)
        : IndexedStack(index: _currentMobileIndex, children: mobilePages);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            currentTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: AppColors.champagneGold),
              onPressed: _refreshAll,
            ),
            IconButton(
              tooltip: l10n.myProfileTab,
              icon: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.champagneGold,
                    width: 1.5,
                  ),
                  color: AppColors.champagneGold.withValues(alpha: 0.15),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 20,
                  color: AppColors.champagneGold,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Scaffold(
                      appBar: AppBar(
                        title: Text(l10n.myProfileTab),
                      ),
                      body: const ClientProfilePage(),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: AppDimensions.spacingSm),
          ],
        ),
        body: isWide
            ? Row(
                children: [
                  SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height - AppBar().preferredSize.height),
                      child: IntrinsicHeight(
                        child: NavigationRail(
                          extended: _isSidebarExtended ?? isLargeDesktop,
                          leading: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon((_isSidebarExtended ?? isLargeDesktop)
                                    ? Icons.menu_open_outlined
                                    : Icons.menu_outlined),
                                color: AppColors.champagneGold,
                                onPressed: () {
                                  setState(() {
                                    _isSidebarExtended = !(_isSidebarExtended ?? isLargeDesktop);
                                  });
                                },
                              ),
                              const SizedBox(height: AppDimensions.spacingSm),
                            ],
                          ),
                          selectedIndex: _currentWideIndex,
                          onDestinationSelected: _selectWideIndex,
                          indicatorColor: AppColors.champagneGold.withValues(
                            alpha: 0.15,
                          ),
                          selectedIconTheme: const IconThemeData(
                            color: AppColors.champagneGold,
                          ),
                          unselectedIconTheme: const IconThemeData(
                            color: AppColors.textMuted,
                          ),
                          selectedLabelTextStyle: const TextStyle(
                            color: AppColors.champagneGold,
                            fontWeight: FontWeight.bold,
                          ),
                          unselectedLabelTextStyle: const TextStyle(
                            color: AppColors.textMuted,
                          ),
                          labelType: (_isSidebarExtended ?? isLargeDesktop)
                              ? NavigationRailLabelType.none
                              : NavigationRailLabelType.all,
                          backgroundColor: theme.brightness == Brightness.dark
                              ? AppColors.imperialNightBlue
                              : AppColors.surfaceLight,
                          destinations: [
                            NavigationRailDestination(
                              icon: const Icon(Icons.analytics_outlined),
                              selectedIcon: const Icon(Icons.analytics),
                              label: Text(l10n.reportsTab),
                            ),
                            NavigationRailDestination(
                              icon: const Icon(Icons.king_bed_outlined),
                              selectedIcon: const Icon(Icons.king_bed),
                              label: Text(l10n.roomsTab),
                            ),
                            NavigationRailDestination(
                              icon: const Icon(Icons.meeting_room_outlined),
                              selectedIcon: const Icon(Icons.meeting_room),
                              label: Text(l10n.roomTypesTab),
                            ),
                            NavigationRailDestination(
                              icon: const Icon(Icons.event_note_outlined),
                              selectedIcon: const Icon(Icons.event_note),
                              label: Text(l10n.reservationsTab),
                            ),
                            NavigationRailDestination(
                              icon: const Icon(Icons.assignment_turned_in_outlined),
                              selectedIcon: const Icon(Icons.assignment_turned_in),
                              label: Text(l10n.roomAssignmentTitle),
                            ),
                            NavigationRailDestination(
                              icon: const Icon(Icons.receipt_long_outlined),
                              selectedIcon: const Icon(Icons.receipt_long),
                              label: Text(l10n.invoicesTab),
                            ),
                            NavigationRailDestination(
                              icon: const Icon(Icons.room_service_outlined),
                              selectedIcon: const Icon(Icons.room_service),
                              label: Text(l10n.servicesTab),
                            ),
                            NavigationRailDestination(
                              icon: const Icon(Icons.people_outline),
                              selectedIcon: const Icon(Icons.people),
                              label: Text(l10n.personnelTab),
                            ),
                            const NavigationRailDestination(
                              icon: Icon(Icons.electrical_services_outlined),
                              selectedIcon: Icon(Icons.electrical_services),
                              label: Text("Équipements"),
                            ),
                            const NavigationRailDestination(
                              icon: Icon(Icons.settings_outlined),
                              selectedIcon: Icon(Icons.settings),
                              label: Text("Paramètres"),
                            ),
                            const NavigationRailDestination(
                              icon: Icon(Icons.info_outline),
                              selectedIcon: Icon(Icons.info),
                              label: Text("À propos de nous"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const VerticalDivider(width: 1, thickness: 1),
                  Expanded(
                    child: currentBody,
                  ),
                ],
              )
            : currentBody,
        bottomNavigationBar: isWide
            ? null
            : BottomNavigationBar(
                currentIndex: _currentMobileIndex,
                onTap: _selectMobileIndex,
                selectedItemColor: AppColors.champagneGold,
                unselectedItemColor: AppColors.textMuted,
                type: BottomNavigationBarType.fixed,
                backgroundColor: theme.brightness == Brightness.dark
                    ? AppColors.imperialNightBlue
                    : AppColors.surfaceLight,
                items: [
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.analytics_outlined),
                    activeIcon: const Icon(Icons.analytics),
                    label: l10n.reportsTab,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.king_bed_outlined),
                    activeIcon: const Icon(Icons.king_bed),
                    label: l10n.roomsTab,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.event_note_outlined),
                    activeIcon: const Icon(Icons.event_note),
                    label: l10n.reservationsTab,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.receipt_long_outlined),
                    activeIcon: const Icon(Icons.receipt_long),
                    label: l10n.invoicesTab,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.more_horiz),
                    activeIcon: const Icon(Icons.menu_open),
                    label: l10n.moreTab,
                  ),
                ],
              ),
      ),
    );
  }
}
