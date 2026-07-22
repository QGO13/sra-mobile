import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/features/room_management/presentation/bloc/room_bloc.dart';
import 'package:sra_hotel/features/room_management/presentation/pages/admin_room_types_view.dart';
import 'package:sra_hotel/features/service_management/presentation/bloc/service_bloc.dart';
import 'package:sra_hotel/features/service_management/presentation/pages/admin_services_view.dart';
import 'package:sra_hotel/features/user_management/presentation/bloc/user_bloc.dart';
import 'package:sra_hotel/features/user_management/presentation/pages/admin_users_view.dart';
import 'package:sra_hotel/features/settings/presentation/pages/settings_page.dart';
import 'package:sra_hotel/features/settings/presentation/pages/about_us_page.dart';
import 'package:sra_hotel/features/room_assignment/presentation/bloc/room_assignment_bloc.dart';
import 'package:sra_hotel/features/room_assignment/presentation/pages/room_assignment_dashboard_page.dart';
import 'package:sra_hotel/features/equipment_management/presentation/bloc/equipment_bloc.dart';
import 'package:sra_hotel/features/equipment_management/presentation/pages/admin_equipments_view.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

class AdminMoreView extends StatefulWidget {
  final VoidCallback onRefreshAll;
  final RoomBloc roomBloc;
  final ServiceBloc serviceBloc;
  final UserBloc userBloc;
  final RoomAssignmentBloc roomAssignmentBloc;
  final EquipmentBloc equipmentBloc;

  const AdminMoreView({
    super.key,
    required this.onRefreshAll,
    required this.roomBloc,
    required this.serviceBloc,
    required this.userBloc,
    required this.roomAssignmentBloc,
    required this.equipmentBloc,
  });

  @override
  State<AdminMoreView> createState() => _AdminMoreViewState();
}

enum _MoreViewSection { menu, roomTypes, services, personnel, roomAssignment, equipments, settings, aboutUs }

class _AdminMoreViewState extends State<AdminMoreView> {
  _MoreViewSection _currentSection = _MoreViewSection.menu;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    if (_currentSection == _MoreViewSection.menu) {
      final menuItems = [
        _MenuItem(
          title: l10n.roomTypesTab,
          icon: Icons.king_bed_outlined,
          onTap: () {
            setState(() {
              _currentSection = _MoreViewSection.roomTypes;
            });
          },
        ),
        _MenuItem(
          title: l10n.servicesTab,
          icon: Icons.room_service_outlined,
          onTap: () {
            setState(() {
              _currentSection = _MoreViewSection.services;
            });
          },
        ),
        _MenuItem(
          title: l10n.personnelTab,
          icon: Icons.people_outline,
          onTap: () {
            setState(() {
              _currentSection = _MoreViewSection.personnel;
            });
          },
        ),
        _MenuItem(
          title: l10n.roomAssignmentTitle,
          icon: Icons.assignment_turned_in_outlined,
          onTap: () {
            setState(() {
              _currentSection = _MoreViewSection.roomAssignment;
            });
          },
        ),
        _MenuItem(
          title: l10n.equipmentsTab,
          icon: Icons.electrical_services_outlined,
          onTap: () {
            setState(() {
              _currentSection = _MoreViewSection.equipments;
            });
          },
        ),
        _MenuItem(
          title: l10n.settingsTab,
          icon: Icons.settings_outlined,
          onTap: () {
            setState(() {
              _currentSection = _MoreViewSection.settings;
            });
          },
        ),
        _MenuItem(
          title: l10n.aboutUsTitle,
          icon: Icons.info_outline,
          onTap: () {
            setState(() {
              _currentSection = _MoreViewSection.aboutUs;
            });
          },
        ),
      ];

      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView.builder(
              padding: const EdgeInsets.all(AppDimensions.spacingMd),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.deepBlue : Colors.white,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    border: Border.all(
                      color: isDark ? Colors.white10 : AppColors.softGrey,
                    ),
                    boxShadow: const [AppShadows.shadowCard],
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    onTap: item.onTap,
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimensions.spacingMd),
                      child: Row(
                        children: [
                          Icon(
                            item.icon,
                            color: AppColors.champagneGold,
                            size: AppDimensions.iconSizeLg,
                          ),
                          const SizedBox(width: AppDimensions.spacingMd),
                          Expanded(
                            child: Text(
                              item.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: AppColors.textMuted,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    } else {
      final String title;
      final Widget body;

      switch (_currentSection) {
        case _MoreViewSection.roomTypes:
          title = l10n.roomTypesTab;
          body = BlocProvider.value(
            value: widget.roomBloc,
            child: const AdminRoomTypesView(),
          );
          break;
        case _MoreViewSection.services:
          title = l10n.servicesTab;
          body = BlocProvider.value(
            value: widget.serviceBloc,
            child: const AdminServicesView(),
          );
          break;
        case _MoreViewSection.personnel:
          title = l10n.personnelTab;
          body = BlocProvider.value(
            value: widget.userBloc,
            child: const AdminUsersView(),
          );
          break;
        case _MoreViewSection.roomAssignment:
          title = l10n.roomAssignmentTitle;
          body = BlocProvider.value(
            value: widget.roomAssignmentBloc,
            child: const RoomAssignmentDashboardPage(),
          );
          break;
        case _MoreViewSection.equipments:
          title = l10n.equipmentsTab;
          body = BlocProvider.value(
            value: widget.equipmentBloc,
            child: const AdminEquipmentsView(),
          );
          break;
        case _MoreViewSection.settings:
          title = l10n.settingsTab;
          body = const SettingsPage();
          break;
        case _MoreViewSection.aboutUs:
          title = l10n.aboutUsTitle;
          body = const AboutUsPage();
          break;
        default:
          title = "";
          body = const SizedBox();
      }

      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                _currentSection = _MoreViewSection.menu;
              });
            },
          ),
          title: Text(title),
        ),
        body: body,
      );
    }
  }
}

class _MenuItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  _MenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}
