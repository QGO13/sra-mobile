import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/sra_button.dart';
import 'package:sra_hotel/core/widgets/sra_input.dart';
import 'package:sra_hotel/core/widgets/sra_dropdown.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

class PaymentFormSheet extends StatefulWidget {
  final double initialAmount;
  final Function(double amount, String method) onSettle;

  const PaymentFormSheet({
    super.key,
    required this.initialAmount,
    required this.onSettle,
  });

  @override
  State<PaymentFormSheet> createState() => _PaymentFormSheetState();
}

class _PaymentFormSheetState extends State<PaymentFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  String _selectedMethod = 'CASH';

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.initialAmount.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final methods = [
      {'id': 'CASH', 'label': l10n.cashMethod},
      {'id': 'CARD', 'label': l10n.cardMethod},
      {'id': 'MOBILE_MONEY', 'label': l10n.mobileMoneyMethod},
    ];

    return Padding(
      padding: EdgeInsets.only(
        left: AppDimensions.spacingMd,
        right: AppDimensions.spacingMd,
        top: AppDimensions.spacingMd,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppDimensions.spacingMd,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                l10n.payBooking,
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.imperialNightBlue,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingMd),
              SraDropdown(
                label: l10n.paymentMethod,
                value: _selectedMethod,
                placeholder: "",
                items: methods.map((m) => m['id']!).toList(),
                itemLabels: Map.fromEntries(methods.map((m) => MapEntry(m['id']!, m['label']!))),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedMethod = val;
                    });
                  }
                },
              ),
              const SizedBox(height: AppDimensions.spacingSm + 4),
              SraInput(
                controller: _amountController,
                label: l10n.amountToPay,
                placeholder: "0",
                keyboardType: TextInputType.number,
                suffixIcon: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  child: Text('FCFA', style: TextStyle(color: Colors.grey)),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return l10n.requiredField;
                  }
                  final amount = double.tryParse(val);
                  if (amount == null || amount <= 0) {
                    return 'Montant invalide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.spacingLg),
              SraButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final amount = double.parse(_amountController.text);
                    widget.onSettle(amount, _selectedMethod);
                    Navigator.pop(context);
                  }
                },
                label: l10n.confirmPayment,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
