import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:get_it/get_it.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_state.dart';
import 'package:sra_hotel/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:sra_hotel/features/cart/presentation/bloc/cart_event.dart';
import 'package:sra_hotel/features/cart/presentation/bloc/cart_state.dart';
import 'package:sra_hotel/features/cart/domain/entities/cart_item_entity.dart';
import 'package:sra_hotel/features/checkout/data/datasources/payment_remote_data_source.dart';
import 'package:sra_hotel/features/user_management/domain/usecases/get_users_usecase.dart';
import 'package:sra_hotel/features/user_management/domain/entities/staff_user.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

class PreInvoicePage extends StatefulWidget {
  const PreInvoicePage({super.key});

  @override
  State<PreInvoicePage> createState() => _PreInvoicePageState();
}

class _PreInvoicePageState extends State<PreInvoicePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ifuController = TextEditingController();
  final TextEditingController _raisonSocialeController = TextEditingController();

  // Payment final state preservation
  bool _isPaid = false;
  bool _isLoading = false;
  String _transactionId = '';
  List<CartItemEntity> _savedItems = [];
  int _savedNights = 1;
  double _savedBaseHT = 0;
  double _savedExtrasHT = 0;
  String _savedClientType = '';
  String _savedClientName = '';
  String _savedIfu = '';

  // Clients list for Admin / Receptionist reservation selection
  String? _selectedClientUserId;
  StaffUser? _selectedClientUser;
  List<StaffUser> _clientsList = [];

  Future<void> _fetchClients() async {
    try {
      final getUsers = GetIt.I<GetUsersUseCase>();
      final users = await getUsers();
      final clients = users.where((u) => u.role.toLowerCase() == 'client').toList();
      setState(() {
        _clientsList = clients;
      });
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      final user = authState.user;
      final role = user.role.toLowerCase();
      final isAdmin = role.contains('admin') || role.contains('reception');
      if (isAdmin) {
        _fetchClients();
      }
      final isCompany = user.prenoms == 'Corporate' || user.prenoms == 'Agence';
      if (isCompany) {
        _raisonSocialeController.text = user.nom ?? '';
        _ifuController.text = '3202612345678'; // Default Ivory Coast / Benin professional IFU prefix
      }
    }
  }

  @override
  void dispose() {
    _ifuController.dispose();
    _raisonSocialeController.dispose();
    super.dispose();
  }

  Future<void> _confirmReservation(double totalTTC, String clientName, String email, String defaultPhone) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final paymentDS = GetIt.I<PaymentRemoteDataSource>();
      final result = await paymentDS.initiatePayment(
        amount: totalTTC,
        phone: defaultPhone.isNotEmpty ? defaultPhone : '0102030405',
        operator: 'DIRECT',
        email: email,
        clientName: clientName,
        targetUserId: _selectedClientUserId,
      );
      
      if (!mounted) return;

      if (result['status'] == 'success') {
        setState(() {
          _isPaid = true;
          _isLoading = false;
          _transactionId = result['transaction_id'] ?? 'tx_${DateTime.now().millisecondsSinceEpoch}';
          _savedIfu = _ifuController.text.trim();
        });
        context.read<CartBloc>().add(CartCleared());
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Réservation validée et confirmée avec succès !"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception(result['message'] ?? 'Erreur lors de la validation');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Échec de la validation : ${e.toString().replaceAll('Exception:', '')}"),
          backgroundColor: AppColors.statusError,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: !_isPaid,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            _isPaid ? l10n.normalizedTaxReceipt : l10n.billingVerification,
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: isDark ? AppColors.champagneGold : AppColors.imperialNightBlue,
            ),
          ),
          backgroundColor: isDark ? AppColors.imperialNightBlue : Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.champagneGold),
            onPressed: () {
              if (_isPaid) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, cartState) {
          // If not paid, read dynamically. If paid, use snapshots.
          if (!_isPaid && cartState is! CartUpdated) {
            return const Center(
              child: Text("Aucun élément dans le panier."),
            );
          }

          final List<CartItemEntity> items = _isPaid ? _savedItems : (cartState as CartUpdated).items;
          final int nights = _isPaid ? _savedNights : (cartState as CartUpdated).nights;

          final double baseChambresHT = _isPaid 
              ? _savedBaseHT 
              : items.fold(0.0, (sum, item) => sum + item.room.prixNuit * item.nightsCount);
          final double totalExtrasHT = _isPaid 
              ? _savedExtrasHT 
              : items.fold(0.0, (sum, item) => sum + (item.itemTotal - (item.room.prixNuit * item.nightsCount)));
          final double totalHT = baseChambresHT + totalExtrasHT;
          
          final double tva = totalHT * 0.18; // TVA 18%
          final double tst = totalHT * 0.025; // TST 2.5%
          final double taxeSejour = _isPaid 
              ? 500.0 * items.length * _savedNights 
              : items.fold(0.0, (sum, item) => sum + 500.0 * item.nightsCount); // 500 FCFA / chambre / nuitée
          final double totalTTC = totalHT + tva + tst + taxeSejour;

          return BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              String clientName = _isPaid ? _savedClientName : l10n.individualClient;
              String clientType = _isPaid ? _savedClientType : l10n.individual;
              String userEmail = "client@sra-hotel.com";
              String userPhone = "";
              bool isCompany = false;

               if (authState is Authenticated) {
                 final user = authState.user;
                 isCompany = user.prenoms == 'Corporate' || user.prenoms == 'Agence';
                 userEmail = user.login;
                 userPhone = user.telephone ?? "";
                 if (!_isPaid) {
                   clientName = user.nom ?? "Utilisateur";
                   clientType = isCompany
                       ? (user.prenoms == 'Agence' ? l10n.partnerAgency : l10n.corporate)
                       : l10n.individual;
                 }
               }

              // Snapshot values if not paid yet to preserve them on success
              if (!_isPaid) {
                _savedItems = items;
                _savedNights = nights;
                _savedBaseHT = baseChambresHT;
                _savedExtrasHT = totalExtrasHT;
                _savedClientName = clientName;
                _savedClientType = clientType;
              }

              return Form(
                key: _formKey,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isDesktop = constraints.maxWidth >= 1024;

                    if (isDesktop) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Proforma invoice receipt card on the left
                          Expanded(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(24.0),
                              child: _buildProformaCard(
                                context,
                                items,
                                nights,
                                baseChambresHT,
                                totalExtrasHT,
                                totalHT,
                                tva,
                                tst,
                                taxeSejour,
                                totalTTC,
                                isDark,
                              ),
                            ),
                          ),
                          // Divider
                          VerticalDivider(
                            color: isDark ? Colors.white10 : AppColors.softGrey,
                            width: 1,
                          ),
                          // Billing details form and checkout action on the right
                          SizedBox(
                            width: 420,
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _buildBillingDetailsCard(
                                    context,
                                    isDark,
                                    theme,
                                    clientType,
                                    isCompany,
                                    clientName,
                                  ),
                                  const SizedBox(height: 32),
                                   if (!_isPaid)
                                     _buildSubmitButton(
                                       context,
                                       totalTTC,
                                       _selectedClientUser != null
                                           ? "${_selectedClientUser!.prenoms} ${_selectedClientUser!.nom}"
                                           : clientName,
                                       _selectedClientUser != null
                                           ? _selectedClientUser!.login
                                           : userEmail,
                                       _selectedClientUser != null
                                           ? _selectedClientUser!.telephone
                                           : userPhone,
                                     )
                                  else
                                    _buildPostPaymentActions(context, isDark),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      // Original vertical layout for mobile/tablet
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildProformaCard(
                              context,
                              items,
                              nights,
                              baseChambresHT,
                              totalExtrasHT,
                              totalHT,
                              tva,
                              tst,
                              taxeSejour,
                              totalTTC,
                              isDark,
                            ),
                            const SizedBox(height: 20),
                            _buildBillingDetailsCard(
                              context,
                              isDark,
                              theme,
                              clientType,
                              isCompany,
                              clientName,
                            ),
                            const SizedBox(height: 32),
                             if (!_isPaid)
                               _buildSubmitButton(
                                 context,
                                 totalTTC,
                                 _selectedClientUser != null
                                     ? "${_selectedClientUser!.prenoms} ${_selectedClientUser!.nom}"
                                     : clientName,
                                 _selectedClientUser != null
                                     ? _selectedClientUser!.login
                                     : userEmail,
                                 _selectedClientUser != null
                                     ? _selectedClientUser!.telephone
                                     : userPhone,
                               )
                            else
                              _buildPostPaymentActions(context, isDark),
                            const SizedBox(height: 16),
                          ],
                        ),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    ));
  }

  Widget _buildProformaCard(
    BuildContext context,
    List<CartItemEntity> items,
    int nights,
    double baseChambresHT,
    double totalExtrasHT,
    double totalHT,
    double tva,
    double tst,
    double taxeSejour,
    double totalTTC,
    bool isDark,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.deepBlue : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: _isPaid ? Colors.green : AppColors.champagneGold,
          width: 1.0,
        ),
        boxShadow: const [AppShadows.shadowCard],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Invoice Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "SRA HÔTEL",
                      style: AppTextStyles.titleLarge.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.champagneGold,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Cocody, Abidjan · Côte d'Ivoire",
                      style: TextStyle(fontSize: 10, color: isDark ? Colors.white60 : Colors.black54),
                    ),
                  ],
                ),
                // Stamp
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _isPaid ? Colors.green.withValues(alpha: 0.1) : AppColors.champagneGold.withValues(alpha: 0.1),
                    border: Border.all(
                      color: _isPaid ? Colors.green : AppColors.champagneGold,
                      width: 1.0,
                    ),
                  ),
                  child: Text(
                    _isPaid ? l10n.paidStatus.toUpperCase() : l10n.proforma.toUpperCase(),
                    style: TextStyle(
                      color: _isPaid ? Colors.green : AppColors.champagneGold,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildDottedLine(isDark),
            const SizedBox(height: 16),
            
            // Period details
            Text(
              l10n.bookingDetailsTitle,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
                color: AppColors.champagneGold,
              ),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = items[index];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.room.categoryName,
                            style: TextStyle(
                              fontWeight: FontWeight.w500, 
                              fontSize: 13,
                              color: isDark ? Colors.white : AppColors.imperialNightBlue,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "${l10n.nightsCount(item.nightsCount)} × ${item.room.prixNuit.toStringAsFixed(0)} FCFA",
                            style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w300),
                          ),
                          if (item.extraBedIncluded)
                            Text(
                              l10n.extraBedBilled,
                              style: const TextStyle(color: AppColors.champagneGold, fontSize: 10),
                            ),
                          if (item.breakfastIncluded)
                            Text(
                              l10n.breakfastBilled(item.breakfastCount),
                              style: const TextStyle(color: AppColors.lightGold, fontSize: 10),
                            ),
                        ],
                      ),
                    ),
                    Text(
                      "${item.itemTotal.toStringAsFixed(0)} FCFA",
                      style: TextStyle(
                        fontWeight: FontWeight.w500, 
                        fontSize: 13,
                        color: isDark ? Colors.white : AppColors.imperialNightBlue,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            _buildDottedLine(isDark),
            const SizedBox(height: 16),

            // Financial Summary
            _buildInvoiceRow(l10n.roomBaseHt, "${baseChambresHT.toStringAsFixed(0)} FCFA", isDark),
            const SizedBox(height: 8),
            _buildInvoiceRow(l10n.extrasBaseHt, "${totalExtrasHT.toStringAsFixed(0)} FCFA", isDark),
            const SizedBox(height: 8),
            _buildInvoiceRow(l10n.totalNetHt, "${totalHT.toStringAsFixed(0)} FCFA", isDark, isBold: true),
            const SizedBox(height: 8),
            _buildInvoiceRow(l10n.tvaLabel, "${tva.toStringAsFixed(0)} FCFA", isDark),
            const SizedBox(height: 8),
            _buildInvoiceRow(l10n.tstLabel, "${tst.toStringAsFixed(0)} FCFA", isDark),
            const SizedBox(height: 8),
            _buildInvoiceRow(l10n.stayTaxLabel, "${taxeSejour.toStringAsFixed(0)} FCFA", isDark),
            const SizedBox(height: 12),
            _buildDottedLine(isDark),
            const SizedBox(height: 12),
            _buildInvoiceRow(
              l10n.totalTtcLabel, 
              "${totalTTC.toStringAsFixed(0)} FCFA", 
              isDark,
              isBold: true,
            ),
            
            // DGI Normalization Info
            if (_isPaid) ...[
              const SizedBox(height: 24),
              _buildDottedLine(isDark),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.08),
                  border: Border.all(color: Colors.green, width: 1.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.verified, color: Colors.green, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          l10n.dgiInvoiceCertified,
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1.0),
                        ),
                      ],
                    ),
                     const SizedBox(height: 12),
                     _buildDgiRow("NIM machine", "MC-01-99887766"),
                     const SizedBox(height: 4),
                     _buildDgiRow("Compteur DGI", "DGI-2026-000482"),
                     const SizedBox(height: 4),
                     _buildDgiRow(l10n.dgiSignature, _transactionId.toUpperCase()),
                     const SizedBox(height: 4),
                     _buildDgiRow(l10n.paymentDate, DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())),
                     if (_savedIfu.isNotEmpty) ...[
                       const SizedBox(height: 4),
                       _buildDgiRow(l10n.ifuAcquirer, _savedIfu),
                     ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBillingDetailsCard(
    BuildContext context,
    bool isDark,
    ThemeData theme,
    String clientType,
    bool isCompany,
    String clientName,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final authState = context.read<AuthBloc>().state;
    bool isAdmin = false;
    if (authState is Authenticated) {
      final role = authState.user.role.toLowerCase();
      isAdmin = role.contains('admin') || role.contains('reception');
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.imperialNightBlue : Colors.white,
        border: Border.all(
          color: isDark ? Colors.white10 : AppColors.softGrey,
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.billingInformation,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: isDark ? Colors.white : AppColors.imperialNightBlue,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "${l10n.clientType} $clientType",
              style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.black54, fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 8),
            if (isAdmin && !_isPaid) ...[
              const SizedBox(height: 12),
              SraDropdown(
                label: l10n.selectClient,
                value: _selectedClientUserId,
                placeholder: l10n.bookOnBehalfOf,
                items: _clientsList.map((client) => client.id).toList(),
                itemLabels: Map.fromEntries(
                  _clientsList.map(
                    (client) => MapEntry(
                      client.id,
                      "${client.prenoms} ${client.nom} (${client.login})",
                    ),
                  ),
                ),
                prefixIcon: const Icon(Icons.person_search_outlined, color: AppColors.champagneGold, size: 18),
                onChanged: (String? valId) {
                  if (valId != null) {
                    setState(() {
                      _selectedClientUserId = valId;
                      _selectedClientUser = _clientsList.firstWhere((client) => client.id == valId);
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
            ],
             if (isCompany && !_isPaid) ...[
               SraInput(
                 controller: _raisonSocialeController,
                 label: l10n.socialReason,
                 placeholder: l10n.companyNamePlaceholder,
                 prefixIcon: const Icon(Icons.business_outlined, size: 18, color: AppColors.champagneGold),
                 validator: (val) =>
                     (val == null || val.trim().isEmpty) ? l10n.socialReasonRequired : null,
               ),
               const SizedBox(height: 12),
             ] else ...[
               Text(
                 _selectedClientUser != null
                     ? "${l10n.clientLabel} ${_selectedClientUser!.prenoms} ${_selectedClientUser!.nom}"
                     : "${l10n.clientLabel} $clientName",
                 style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.black54, fontWeight: FontWeight.w300),
               ),
               const SizedBox(height: 12),
             ],
 
             if (!_isPaid) ...[
               SraInput(
                 controller: _ifuController,
                 keyboardType: TextInputType.number,
                 label: l10n.ifuLabel,
                 placeholder: "Ex: 3202612345678",
                 prefixIcon: const Icon(Icons.description_outlined, size: 18, color: AppColors.champagneGold),
                 validator: (val) {
                   if (isCompany) {
                     if (val == null || val.trim().isEmpty) {
                       return l10n.ifuRequiredError;
                     }
                     if (val.trim().length < 10) {
                       return l10n.ifuLengthError;
                     }
                   }
                   return null;
                 },
               ),
             ] else if (_savedIfu.isNotEmpty) ...[
               Text(
                 "${l10n.ifuBilled} $_savedIfu",
                 style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.black54, fontWeight: FontWeight.w300),
               ),
             ],
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(
    BuildContext context, 
    double totalTTC, 
    String clientName, 
    String email, 
    String defaultPhone,
  ) {
    final l10n = AppLocalizations.of(context)!;
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(color: AppColors.champagneGold),
        ),
      );
    }
    return SraButton(
      onPressed: () {
        if (_formKey.currentState?.validate() ?? false) {
          _confirmReservation(totalTTC, clientName, email, defaultPhone);
        }
      },
      label: "${l10n.confirmBookingLabel} (${totalTTC.toStringAsFixed(0)} FCFA)",
    );
  }

  Widget _buildPostPaymentActions(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SraButton(
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.printingTaxReceipt),
              ),
            );
          },
          label: l10n.printDgiInvoice,
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        const SizedBox(height: 12),
        SraButton(
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          label: l10n.backToHome,
          isOutlined: true,
        ),
      ],
    );
  }

  Widget _buildInvoiceRow(String label, String value, bool isDark, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 13 : 12,
            fontWeight: isBold ? FontWeight.w500 : FontWeight.w300,
            color: isBold
                ? (isDark ? Colors.white : AppColors.imperialNightBlue)
                : Colors.grey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 14 : 12,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: isBold ? AppColors.champagneGold : (isDark ? Colors.white70 : AppColors.imperialNightBlue),
          ),
        ),
      ],
    );
  }

  Widget _buildDgiRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10.5, color: Colors.grey, fontWeight: FontWeight.w300),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 10.5, color: Colors.green, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildDottedLine(bool isDark) {
    return Row(
      children: List.generate(
        40,
        (index) => Expanded(
          child: Container(
            color: index % 2 == 0 ? Colors.transparent : (isDark ? Colors.white12 : Colors.black12),
            height: 1,
          ),
        ),
      ),
    );
  }
}



