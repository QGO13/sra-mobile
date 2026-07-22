import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
import 'package:sra_hotel/features/checkout/presentation/bloc/payment_bloc.dart';
import 'package:sra_hotel/features/checkout/presentation/bloc/payment_event.dart';
import 'package:sra_hotel/features/checkout/presentation/bloc/payment_state.dart';

class PaymentBottomSheet extends StatefulWidget {
  final PaymentBloc paymentBloc;
  final double amount;
  final String clientName;
  final String email;
  final String defaultPhone;
  final VoidCallback onSuccess;

  const PaymentBottomSheet({
    super.key,
    required this.paymentBloc,
    required this.amount,
    required this.clientName,
    required this.email,
    this.defaultPhone = '',
    required this.onSuccess,
  });

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  int _currentStep = 1; // 1: Select Method, 2: Momo Phone Input
  String _selectedOperator = ''; // 'mtn', 'moov', 'orange', 'wave', 'card'
  late TextEditingController _phoneController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    widget.paymentBloc.add(ResetPaymentState());
    
    // Ensure default phone starts with +225 or has it prepended
    String initialPhone = widget.defaultPhone.trim();
    if (initialPhone.isEmpty) {
      initialPhone = '+225 ';
    } else if (!initialPhone.startsWith('+')) {
      initialPhone = '+225 $initialPhone';
    }
    _phoneController = TextEditingController(text: initialPhone);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _selectOperator(String op) {
    setState(() {
      _selectedOperator = op;
    });

    if (op == 'card') {
      // Trigger card payment initiation directly
      widget.paymentBloc.add(StartCardPayment(
        amount: widget.amount,
        email: widget.email,
        clientName: widget.clientName,
      ));
    } else {
      // Go to phone input for Mobile Money
      setState(() {
        _currentStep = 2;
      });
    }
  }

  void _submitMomo() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.paymentBloc.add(StartMomoPayment(
        amount: widget.amount,
        phone: _phoneController.text.replaceAll(' ', ''),
        operator: _selectedOperator,
        email: widget.email,
        clientName: widget.clientName,
      ));
    }
  }

  Future<void> _launchCardCheckout(String checkoutUrl) async {
    final uri = Uri.parse(checkoutUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Impossible d'ouvrir le lien de paiement par carte.")),
      );
    }
  }

  Color _getOperatorColor(String op) {
    switch (op) {
      case 'mtn':
        return const Color(0xFFFFCC00); // Yellow
      case 'moov':
        return const Color(0xFF00A2E8); // Moov Blue
      case 'orange':
        return const Color(0xFFFF6600); // Orange
      case 'wave':
        return const Color(0xFF1D9BF0); // Wave Sky Blue
      case 'card':
        return AppColors.champagneGold; // Card Gold Accent
      default:
        return Colors.grey;
    }
  }

  String _getOperatorLabel(String op) {
    switch (op) {
      case 'mtn':
        return "MTN MoMo";
      case 'moov':
        return "Moov Money";
      case 'orange':
        return "Orange Money";
      case 'wave':
        return "Wave";
      case 'card':
        return "Carte Bancaire";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocProvider.value(
      value: widget.paymentBloc,
      child: BlocConsumer<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is PaymentSuccess) {
            widget.onSuccess();
          } else if (state is PaymentRedirectRequired) {
            _launchCardCheckout(state.checkoutUrl);
          }
        },
        builder: (context, state) {
          return PopScope(
            canPop: state is! PaymentLoading,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? AppColors.imperialNightBlue : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SafeArea(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildContentByState(state, isDark),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContentByState(PaymentState state, bool isDark) {
    if (state is PaymentLoading) {
      return _buildProcessingScreen(state.message);
    }
    if (state is PaymentSuccess) {
      return _buildSuccessScreen(state.transactionId);
    }
    if (state is PaymentFailure) {
      return _buildFailureScreen(state.errorMessage);
    }
    if (state is PaymentRedirectRequired) {
      return _buildCardRedirectScreen(state.transactionId);
    }

    // Default step management
    if (_currentStep == 1) {
      return _buildOperatorSelection(isDark);
    } else {
      return _buildMomoPhoneInput(isDark);
    }
  }

  // --- Step 1: Select Operator ---
  Widget _buildOperatorSelection(bool isDark) {
    return Column(
      key: const ValueKey('step_select'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Mode de paiement",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          "Montant à régler : ${widget.amount.toStringAsFixed(0)} FCFA",
          style: const TextStyle(fontSize: 14, color: AppColors.champagneGold, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 24),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.3,
          children: [
            _buildOperatorCard('mtn', Icons.phone_android),
            _buildOperatorCard('moov', Icons.phone_android),
            _buildOperatorCard('orange', Icons.phone_android),
            _buildOperatorCard('wave', Icons.waves),
            _buildOperatorCard('card', Icons.credit_card),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildOperatorCard(String op, IconData icon) {
    final color = _getOperatorColor(op);
    final label = _getOperatorLabel(op);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () => _selectOperator(op),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.deepBlue.withValues(alpha: 0.15) : Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.champagneGold.withValues(alpha: 0.2), width: 1.2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  // --- Step 2: Momo Phone Input ---
  Widget _buildMomoPhoneInput(bool isDark) {
    final label = _getOperatorLabel(_selectedOperator);
    final color = _getOperatorColor(_selectedOperator);

    return Form(
      key: _formKey,
      child: Column(
        key: const ValueKey('step_momo'),
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _currentStep = 1;
                  });
                },
              ),
              Text(
                "Paiement par $label",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SraInput(
            controller: _phoneController,
            label: "Numéro de téléphone",
            placeholder: "+225 0700000000",
            keyboardType: TextInputType.phone,
            prefixIcon: Icon(Icons.phone, color: color),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Veuillez entrer votre numéro de téléphone";
              }
              if (value.trim().length < 8) {
                return "Veuillez entrer un numéro valide";
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          SraButton(
            onPressed: _submitMomo,
            label: "Déclencher le push (${widget.amount.toStringAsFixed(0)} FCFA)",
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // --- Step 3: Loading Screen ---
  Widget _buildProcessingScreen(String message) {
    return Column(
      key: const ValueKey('step_loading'),
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 30),
        const SizedBox(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(
            color: AppColors.champagneGold,
            strokeWidth: 4,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        const Text(
          "Ne fermez pas cette fenêtre.",
          style: TextStyle(color: Colors.white54, fontSize: 12),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  // --- Step 3b: Card Redirect Wait Screen ---
  Widget _buildCardRedirectScreen(String transactionId) {
    return Column(
      key: const ValueKey('step_card_redirect'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.credit_card, size: 50, color: AppColors.champagneGold),
        const SizedBox(height: 16),
        const Text(
          "Paiement par carte en cours",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        const Text(
          "Une fenêtre de paiement sécurisé a été ouverte dans votre navigateur. Veuillez y finaliser la saisie de votre carte bancaire.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
        const SizedBox(height: 24),
        SraButton(
          onPressed: () {
            widget.paymentBloc.add(CheckPaymentStatus(transactionId: transactionId));
          },
          label: "Vérifier le statut du paiement",
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {
            widget.paymentBloc.add(ResetPaymentState());
            setState(() {
              _currentStep = 1;
            });
          },
          child: const Text("Annuler et changer de mode", style: TextStyle(color: Colors.redAccent)),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // --- Step 4: Success Screen ---
  Widget _buildSuccessScreen(String transactionId) {
    return Column(
      key: const ValueKey('step_success'),
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),
        const Icon(Icons.check_circle_outline, size: 70, color: Colors.green),
        const SizedBox(height: 16),
        const Text(
          "Réservation validée !",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
        ),
        const SizedBox(height: 8),
        Text(
          "Réf transaction : $transactionId",
          style: const TextStyle(fontSize: 12, color: Colors.white54),
        ),
        const SizedBox(height: 16),
        const Text(
          "Votre paiement a été approuvé. Votre reçu de caisse DGI certifié est maintenant disponible.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 24),
        SraButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          label: "Fermer",
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // --- Step 4b: Failure Screen ---
  Widget _buildFailureScreen(String error) {
    return Column(
      key: const ValueKey('step_failure'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        const Icon(Icons.error_outline, size: 70, color: Colors.redAccent),
        const SizedBox(height: 16),
        const Text(
          "Échec du paiement",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.redAccent),
        ),
        const SizedBox(height: 12),
        Text(
          error,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: Colors.white70),
        ),
        const SizedBox(height: 24),
        SraButton(
          onPressed: () {
            widget.paymentBloc.add(ResetPaymentState());
            setState(() {
              _currentStep = 1;
            });
          },
          label: "Réessayer",
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

