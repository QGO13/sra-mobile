import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
import 'package:sra_hotel/features/user_management/domain/entities/staff_user.dart';
import 'package:sra_hotel/features/user_management/presentation/bloc/user_bloc.dart';
import 'package:sra_hotel/features/user_management/presentation/bloc/user_event.dart';
import 'package:sra_hotel/features/user_management/presentation/bloc/user_state.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

class AdminUsersView extends StatefulWidget {
  const AdminUsersView({super.key});

  @override
  State<AdminUsersView> createState() => _AdminUsersViewState();
}

class _AdminUsersViewState extends State<AdminUsersView> {
  String _searchQuery = "";
  String _selectedFilter = "all";
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading || state is UserInitial) {
          return const LoadingWidget();
        } else if (state is UserFailure) {
          return ErrorStateView(
            message: state.error,
            onRetry: () => context.read<UserBloc>().add(LoadUsersEvent()),
          );
        } else if (state is UserLoaded) {
          final filteredUsers = state.users.where((user) {
            final matchesSearch = user.nom.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                user.prenoms.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                user.login.toLowerCase().contains(_searchQuery.toLowerCase());
            bool matchesFilter = true;
            final r = user.role.toLowerCase();
            if (_selectedFilter == "admin") {
              matchesFilter = r.contains("admin");
            } else if (_selectedFilter == "receptionist") {
              matchesFilter = r.contains("reception");
            } else if (_selectedFilter == "housekeeper") {
              matchesFilter = r.contains("housekeeper");
            } else if (_selectedFilter == "client") {
              matchesFilter = r.contains("client");
            }
            return matchesSearch && matchesFilter;
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppDimensions.spacingMd),
                child: Row(
                  children: [
                    Expanded(
                      child: SraInput(
                        controller: _searchController,
                        placeholder: l10n.searchStaffPlaceholder,
                        prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.champagneGold),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 18),
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _searchQuery = "";
                                  });
                                },
                              )
                            : null,
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacingSm + 4),
                    Flexible(
                      fit: FlexFit.loose,
                      child: SraButton(
                        onPressed: () => _showUserFormDialog(context, null),
                        icon: Icons.add,
                        label: l10n.personnelTab.split(' ')[0],
                      ),
                    ),
                  ],
                ),
              ),
              SraFilterBar(
                items: [
                  const SraFilterItem(id: 'all', label: 'Tout'),
                  SraFilterItem(id: 'admin', label: l10n.adminRole),
                  SraFilterItem(id: 'receptionist', label: l10n.receptionistRole),
                  const SraFilterItem(id: 'housekeeper', label: 'Gouvernante'),
                  const SraFilterItem(id: 'client', label: 'Client'),
                ],
                selectedId: _selectedFilter,
                onSelected: (id) {
                  setState(() {
                    _selectedFilter = id;
                  });
                },
              ),
              Expanded(
                child: filteredUsers.isEmpty
                    ? const EmptyStateView(
                        icon: Icons.people_outline,
                      )
                    : ResponsiveListGridView(
                        itemCount: filteredUsers.length,
                        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd),
                        maxCrossAxisExtent: 450,
                        mainAxisExtent: 110,
                        itemBuilder: (context, index) {
                    final user = filteredUsers[index];
                    return Opacity(
                      opacity: user.isActive == 1 ? 1.0 : 0.5,
                      child: Container(
                        margin: MediaQuery.of(context).size.width < AppDimensions.breakpointMd
                            ? const EdgeInsets.only(bottom: AppDimensions.spacingSm + 2)
                            : EdgeInsets.zero,
                        padding: const EdgeInsets.all(AppDimensions.spacingSm + 4),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.deepBlue : Colors.white,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                          border: Border.all(color: isDark ? Colors.white10 : AppColors.softGrey),
                          boxShadow: const [AppShadows.shadowCard],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.champagneGold.withValues(alpha: 0.1),
                              foregroundColor: AppColors.champagneGold,
                              child: Text(user.nom.isNotEmpty ? user.nom.substring(0, 1).toUpperCase() : ""),
                            ),
                            const SizedBox(width: AppDimensions.spacingSm + 4),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${user.prenoms} ${user.nom}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  Text(
                                    user.login,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                                  ),
                                  const SizedBox(height: AppDimensions.spacingXs / 2),
                                  Builder(
                                    builder: (context) {
                                      final r = user.role.toLowerCase();
                                      String label = r.toUpperCase();
                                      Color col = AppColors.statusInfo;
                                      if (r.contains('admin')) {
                                        label = l10n.adminRole.toUpperCase();
                                        col = AppColors.champagneGold;
                                      } else if (r.contains('reception')) {
                                        label = l10n.receptionistRole.toUpperCase();
                                        col = AppColors.statusSuccess;
                                      } else if (r.contains('housekeeper')) {
                                        label = "GOUVERNANTE";
                                        col = AppColors.statusWarning;
                                      } else if (r.contains('client')) {
                                        label = "CLIENT";
                                        col = AppColors.textMuted;
                                      }
                                      return Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        color: col.withValues(alpha: 0.15),
                                        child: Text(
                                          label,
                                          style: TextStyle(fontSize: 9, color: col, fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: AppDimensions.spacingSm),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, color: AppColors.statusInfo),
                              onPressed: () => _showUserFormDialog(context, user),
                            ),
                            Switch(
                              value: user.isActive == 1,
                              activeTrackColor: AppColors.champagneGold,
                              onChanged: (val) {
                                final updated = StaffUser(
                                  id: user.id,
                                  login: user.login,
                                  role: user.role,
                                  nom: user.nom,
                                  prenoms: user.prenoms,
                                  telephone: user.telephone,
                                  sexe: user.sexe,
                                  pays: user.pays,
                                  adresse: user.adresse,
                                  isActive: val ? 1 : 0,
                                );
                                context.read<UserBloc>().add(UpdateUserEvent(updated));
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  void _showUserFormDialog(BuildContext context, StaffUser? user) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController(text: user?.login ?? '');
    final nameController = TextEditingController(text: user?.nom ?? '');
    final preController = TextEditingController(text: user?.prenoms ?? '');
    final phoneController = TextEditingController(text: user?.telephone ?? '');
    String selectedRole = user?.role ?? "receptionist";
    // Normalize old role format
    if (selectedRole == "reception") selectedRole = "receptionist";
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.deepBlue : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusLg)),
          title: Text(
            user == null ? l10n.addStaff : l10n.editStaff,
            style: AppTextStyles.titleLarge.copyWith(color: AppColors.champagneGold),
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SraInput(
                      controller: emailController,
                      label: l10n.emailLabel,
                      placeholder: "e.g. staff@srahotel.com",
                      validator: (val) => val == null || val.isEmpty ? l10n.requiredField : null,
                    ),
                    const SizedBox(height: AppDimensions.spacingMd),
                    SraInput(
                      controller: nameController,
                      label: l10n.lastNameLabel,
                      placeholder: "e.g. Dupont",
                      validator: (val) => val == null || val.isEmpty ? l10n.requiredField : null,
                    ),
                    const SizedBox(height: AppDimensions.spacingMd),
                    SraInput(
                      controller: preController,
                      label: l10n.firstNameLabel,
                      placeholder: "e.g. Jean",
                      validator: (val) => val == null || val.isEmpty ? l10n.requiredField : null,
                    ),
                    const SizedBox(height: AppDimensions.spacingMd),
                    SraInput(
                      controller: phoneController,
                      label: l10n.phoneLabel,
                      placeholder: "e.g. +229 99 99 99 99",
                    ),
                    const SizedBox(height: AppDimensions.spacingMd),
                    SraDropdown(
                      value: selectedRole,
                      label: l10n.roleLabel,
                      placeholder: l10n.selectOption,
                      items: const ["admin", "receptionist", "housekeeper", "client"],
                      itemLabels: {
                        "admin": l10n.adminRole,
                        "receptionist": l10n.receptionistRole,
                        "housekeeper": l10n.housekeeperRole,
                        "client": l10n.clientRole,
                      },
                      onChanged: (val) {
                        if (val != null) selectedRole = val;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            SraButton(
              label: l10n.cancelLabel,
              isOutlined: true,
              onPressed: () => Navigator.of(ctx).pop(),
            ),
            const SizedBox(width: AppDimensions.spacingSm),
            SraButton(
              label: l10n.validateLabel,
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final u = StaffUser(
                    id: user?.id ?? '',
                    login: emailController.text,
                    role: selectedRole,
                    nom: nameController.text,
                    prenoms: preController.text,
                    telephone: phoneController.text,
                    sexe: user?.sexe ?? "M",
                    pays: user?.pays ?? "Benin",
                    adresse: user?.adresse ?? "",
                    isActive: user?.isActive ?? 1,
                  );
                  if (user == null) {
                    context.read<UserBloc>().add(CreateUserEvent(u));
                  } else {
                    context.read<UserBloc>().add(UpdateUserEvent(u));
                  }
                  Navigator.of(ctx).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
