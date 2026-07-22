import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

class DemoAccount {
  final String role;
  final String email;
  final String password;

  const DemoAccount({
    required this.role,
    required this.email,
    required this.password,
  });
}

class DemoAccountsBanner extends StatefulWidget {
  final Function(String email, String password) onSelect;

  const DemoAccountsBanner({
    super.key,
    required this.onSelect,
  });

  @override
  State<DemoAccountsBanner> createState() => _DemoAccountsBannerState();
}

class _DemoAccountsBannerState extends State<DemoAccountsBanner> {
  bool _isExpanded = false;

  final List<DemoAccount> _accounts = const [
    DemoAccount(role: 'Client', email: 'client@sra-hotel.com', password: 'Client2024!'),
    DemoAccount(role: 'Administrateur', email: 'admin@sra-hotel.com', password: 'Admin2024!'),
    DemoAccount(role: 'Réception', email: 'reception@sra-hotel.com', password: 'Reception2024!'),
    DemoAccount(role: 'Ménage', email: 'menage@sra-hotel.com', password: 'Menage2024!'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.08),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.3),
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          // Header Toggle button
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: AppColors.gold,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "COMPTES DE DÉMONSTRATION",
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                          color: AppColors.gold,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: AppColors.gold,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
          
          // Expanded contents
          if (_isExpanded) ...[
            Container(
              padding: const EdgeInsets.all(12.0),
              color: isDark ? Colors.black12 : AppColors.white24,
              child: Column(
                children: _accounts.map((acc) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: InkWell(
                      onTap: () => widget.onSelect(acc.email, acc.password),
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCard : AppColors.white,
                          border: Border.all(
                            color: isDark ? AppColors.white12 : AppColors.mist,
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  acc.role,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? AppColors.white : AppColors.ink,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  acc.email,
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    color: AppColors.inkMuted,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              acc.password,
                              style: const TextStyle(
                                fontSize: 11,
                                fontFamily: 'monospace',
                                color: AppColors.gold,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

