import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/core/routes/app_routes.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/display/sra_logo.dart';
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
import 'package:sra_hotel/features/admin_dashboard/presentation/widgets/admin_sidebar_widget.dart';
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
  int _currentWideIndex = 1; // 1 = Chambres par défaut
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
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final isWide = MediaQuery.of(context).size.width >= 1024;
    final isLargeDesktop = MediaQuery.of(context).size.width >= 1280;
    final sidebarExtended = _isSidebarExtended ?? isLargeDesktop;

    // --- GRAND ÉCRAN (Sidebar) : 11 destinations ---
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

    final sidebarItems = [
      AdminSidebarItem(
        icon: Icons.analytics_outlined,
        selectedIcon: Icons.analytics,
        label: l10n.reportsTab,
      ),
      AdminSidebarItem(
        icon: Icons.king_bed_outlined,
        selectedIcon: Icons.king_bed,
        label: l10n.roomsTab,
      ),
      AdminSidebarItem(
        icon: Icons.meeting_room_outlined,
        selectedIcon: Icons.meeting_room,
        label: l10n.roomTypesTab,
      ),
      AdminSidebarItem(
        icon: Icons.event_note_outlined,
        selectedIcon: Icons.event_note,
        label: l10n.reservationsTab,
      ),
      AdminSidebarItem(
        icon: Icons.assignment_turned_in_outlined,
        selectedIcon: Icons.assignment_turned_in,
        label: l10n.roomAssignmentTitle,
      ),
      AdminSidebarItem(
        icon: Icons.receipt_long_outlined,
        selectedIcon: Icons.receipt_long,
        label: l10n.invoicesTab,
      ),
      AdminSidebarItem(
        icon: Icons.room_service_outlined,
        selectedIcon: Icons.room_service,
        label: l10n.servicesTab,
      ),
      AdminSidebarItem(
        icon: Icons.people_outline,
        selectedIcon: Icons.people,
        label: l10n.personnelTab,
      ),
      const AdminSidebarItem(
        icon: Icons.electrical_services_outlined,
        selectedIcon: Icons.electrical_services,
        label: "Équipements",
      ),
      const AdminSidebarItem(
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings,
        label: "Paramètres",
      ),
      const AdminSidebarItem(
        icon: Icons.info_outline,
        selectedIcon: Icons.info,
        label: "À propos de nous",
      ),
    ];

    // --- PETIT ÉCRAN (Mobile) : 5 onglets principaux ---
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
          leading: Builder(
            builder: (ctx) => IconButton(
              tooltip: isWide
                  ? (sidebarExtended ? "Réduire le menu" : "Agrandir le menu")
                  : "Menu administration",
              icon: Icon(
                isWide
                    ? (sidebarExtended ? Icons.menu_open_rounded : Icons.menu_rounded)
                    : Icons.menu_rounded,
                color: isDark ? AppColors.goldLight2 : AppColors.gold,
              ),
              onPressed: () {
                if (isWide) {
                  setState(() {
                    _isSidebarExtended = !sidebarExtended;
                  });
                } else {
                  Scaffold.of(ctx).openDrawer();
                }
              },
            ),
          ),
          title: Text(
            currentTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: AppColors.gold),
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
                    color: AppColors.gold,
                    width: 1.5,
                  ),
                  color: AppColors.gold.withValues(alpha: 0.15),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 20,
                  color: AppColors.gold,
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
        drawer: isWide
            ? null
            : Drawer(
                backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
                child: Column(
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : AppColors.fog,
                        border: Border(
                          bottom: BorderSide(
                            color: isDark ? AppColors.darkBorder : AppColors.mist,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SraLogo(size: 42),
                          AppDimensions.vGapSm,
                          Text(
                            "SRA HÔTEL ADMIN",
                            style: AppTextStyles.labelUppercase.copyWith(
                              color: isDark ? AppColors.goldLight2 : AppColors.gold,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: sidebarItems.length,
                        itemBuilder: (context, index) {
                          final item = sidebarItems[index];
                          final isSelected = _currentWideIndex == index;
                          return ListTile(
                            leading: Icon(
                              isSelected ? item.selectedIcon : item.icon,
                              color: isSelected
                                  ? (isDark ? AppColors.goldLight2 : AppColors.gold)
                                  : (isDark ? AppColors.overlayDarkMedium : AppColors.inkMuted),
                            ),
                            title: Text(
                              item.label,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: isSelected
                                    ? (isDark ? AppColors.goldLight2 : AppColors.gold)
                                    : (isDark ? AppColors.white : AppColors.ink),
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context); // fermer drawer
                              _selectWideIndex(index);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
        body: isWide
            ? Row(
                children: [
                  AdminSidebarWidget(
                    isExtended: sidebarExtended,
                    selectedIndex: _currentWideIndex,
                    onItemSelected: _selectWideIndex,
                    onToggleExtend: () {
                      setState(() {
                        _isSidebarExtended = !sidebarExtended;
                      });
                    },
                    items: sidebarItems,
                  ),
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
                selectedItemColor: AppColors.gold,
                unselectedItemColor: AppColors.inkMuted,
                type: BottomNavigationBarType.fixed,
                backgroundColor: isDark
                    ? AppColors.darkSurface
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
