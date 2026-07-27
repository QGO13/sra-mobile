import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/buttons/sra_button.dart';
import 'package:sra_hotel/core/widgets/display/sra_avatar.dart';
import 'package:sra_hotel/core/widgets/display/sra_filter_bar.dart';
import 'package:sra_hotel/core/widgets/display/sra_status_badge.dart';
import 'package:sra_hotel/core/widgets/feedback/confirm_delete_dialog.dart';
import 'package:sra_hotel/core/widgets/feedback/error_state_view.dart';
import 'package:sra_hotel/core/widgets/feedback/loading_indicator.dart';
import 'package:sra_hotel/core/widgets/inputs/sra_input.dart';
import 'package:sra_hotel/core/widgets/layout/sra_data_table.dart';
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
          return const LoadingIndicator();
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Barre de recherche & Action ──
              Padding(
                padding: const EdgeInsets.all(AppDimensions.spacingMd),
                child: Row(
                  children: [
                    Expanded(
                      child: SraInput(
                        controller: _searchController,
                        placeholder: l10n.searchStaffPlaceholder,
                        prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.gold),
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
              const SizedBox(height: AppDimensions.spacingMd),

              // ── Vue Tableau CRUD Unifiée ──
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd),
                  child: SraDataTable<StaffUser>(
                    items: filteredUsers,
                    minWidth: 700,
                    emptyTitle: 'Aucun collaborateur trouvé',
                    emptyIcon: Icons.people_outline,
                    columns: [
                      SraTableColumn<StaffUser>(
                        label: "Collaborateur",
                        flex: 1.4,
                        cellBuilder: (context, user) => Row(
                          children: [
                            SraAvatar(
                              name: "${user.prenoms} ${user.nom}",
                              size: 32,
                            ),
                            const SizedBox(width: AppDimensions.spacingSm),
                            Expanded(
                              child: Text(
                                "${user.prenoms} ${user.nom}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.white : AppColors.ink,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SraTableColumn<StaffUser>(
                        label: "Identifiant / Email",
                        flex: 1.4,
                        cellBuilder: (context, user) => Text(
                          user.login,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isDark ? AppColors.overlayDarkMedium : AppColors.inkMuted,
                          ),
                        ),
                      ),
                      SraTableColumn<StaffUser>(
                        label: "Téléphone",
                        flex: 1.0,
                        cellBuilder: (context, user) => Text(
                          user.telephone.isNotEmpty ? user.telephone : "N/A",
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isDark ? AppColors.white : AppColors.ink,
                          ),
                        ),
                      ),
                      SraTableColumn<StaffUser>(
                        label: "Rôle",
                        flex: 1.0,
                        cellBuilder: (context, user) {
                          final r = user.role.toLowerCase();
                          if (r.contains('admin')) {
                            return SraStatusBadge.custom(label: l10n.adminRole.toUpperCase(), color: AppColors.gold, small: true);
                          } else if (r.contains('reception')) {
                            return SraStatusBadge.success(label: l10n.receptionistRole.toUpperCase(), small: true);
                          } else if (r.contains('housekeeper')) {
                            return const SraStatusBadge.warning(label: 'GOUVERNANTE', small: true);
                          } else {
                            return const SraStatusBadge.custom(label: 'CLIENT', color: AppColors.inkMuted, small: true);
                          }
                        },
                      ),
                      SraTableColumn<StaffUser>(
                        label: "Statut",
                        flex: 0.8,
                        cellBuilder: (context, user) => user.isActive == 1
                            ? const SraStatusBadge.success(label: 'ACTIF', small: true)
                            : const SraStatusBadge.custom(label: 'INACTIF', color: AppColors.inkMuted, small: true),
                      ),
                      SraTableColumn<StaffUser>(
                        label: "Actions",
                        flex: 0.8,
                        alignment: Alignment.centerRight,
                        cellBuilder: (context, user) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: "Modifier",
                              icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.statusInfo),
                              onPressed: () => _showUserFormDialog(context, user),
                            ),
                            IconButton(
                              tooltip: "Supprimer",
                              icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.statusError),
                              onPressed: () async {
                                final confirmed = await ConfirmDeleteDialog.show(
                                  context,
                                  title: 'Supprimer cet utilisateur ?',
                                  message: 'Êtes-vous sûr de vouloir supprimer ${user.prenoms} ${user.nom} ?',
                                );
                                if (confirmed && context.mounted) {
                                  final intId = int.tryParse(user.id) ?? 0;
                                  context.read<UserBloc>().add(DeleteUserEvent(intId));
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
    final nomController = TextEditingController(text: user?.nom ?? '');
    final prenomsController = TextEditingController(text: user?.prenoms ?? '');
    final loginController = TextEditingController(text: user?.login ?? '');
    final telController = TextEditingController(text: user?.telephone ?? '');
    String selectedRole = user?.role ?? 'receptionist';

    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final l10n = AppLocalizations.of(ctx)!;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
          title: Text(
            user == null ? "Ajouter un collaborateur" : "Modifier l'utilisateur",
            style: AppTextStyles.titleMedium.copyWith(
              color: isDark ? AppColors.white : AppColors.ink,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SraInput(
                    controller: nomController,
                    placeholder: "Nom",
                    validator: (v) => v == null || v.isEmpty ? 'Champ obligatoire' : null,
                  ),
                  AppDimensions.vGapMd,
                  SraInput(
                    controller: prenomsController,
                    placeholder: "Prénoms",
                    validator: (v) => v == null || v.isEmpty ? 'Champ obligatoire' : null,
                  ),
                  AppDimensions.vGapMd,
                  SraInput(
                    controller: loginController,
                    placeholder: "Identifiant / Email",
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => v == null || v.isEmpty ? 'Champ obligatoire' : null,
                  ),
                  AppDimensions.vGapMd,
                  SraInput(
                    controller: telController,
                    placeholder: "Téléphone",
                    keyboardType: TextInputType.phone,
                  ),
                  AppDimensions.vGapMd,
                  DropdownButtonFormField<String>(
                    initialValue: selectedRole,
                    decoration: const InputDecoration(
                      labelText: "Rôle de l'utilisateur",
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(value: 'admin', child: Text(l10n.adminRole)),
                      DropdownMenuItem(value: 'receptionist', child: Text(l10n.receptionistRole)),
                      const DropdownMenuItem(value: 'housekeeper', child: Text('Gouvernante')),
                      const DropdownMenuItem(value: 'client', child: Text('Client')),
                    ],
                    onChanged: (v) {
                      if (v != null) selectedRole = v;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            SraButton.secondary(
              label: l10n.cancelLabel,
              onPressed: () => Navigator.pop(ctx),
            ),
            SraButton(
              label: 'Enregistrer',
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final newUser = StaffUser(
                    id: user?.id ?? '',
                    login: loginController.text,
                    role: selectedRole,
                    nom: nomController.text,
                    prenoms: prenomsController.text,
                    telephone: telController.text,
                    sexe: user?.sexe ?? 'M',
                    pays: user?.pays ?? 'Côte d\'Ivoire',
                    adresse: user?.adresse ?? '',
                    isActive: user?.isActive ?? 1,
                  );

                  if (user == null) {
                    context.read<UserBloc>().add(CreateUserEvent(newUser));
                  } else {
                    context.read<UserBloc>().add(UpdateUserEvent(newUser));
                  }
                  Navigator.pop(ctx);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
