import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/sra_logo.dart';

class AboutUsPage extends StatelessWidget {
  final bool isNested;
  const AboutUsPage({super.key, this.isNested = false});

  Future<void> _launchUrl(String urlString) async {
    final Uri uri = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isWide = MediaQuery.of(context).size.width >= AppDimensions.breakpointMd;

    final historySection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Notre Histoire & Vision"),
        _buildInfoCard(
          isDark,
          child: const Padding(
            padding: EdgeInsets.all(AppDimensions.spacingMd),
            child: Text(
              "Sweet Rest Aparthotel est un complexe hôtelier de prestige situé à Abidjan (Cocody Riviera M'badon), en Côte d'Ivoire. Notre mission est d'offrir une expérience d'hébergement d'exception, combinant la liberté et l'autonomie d'un appartement privé de luxe avec le service et les commodités raffinés d'un hôtel haut de gamme.\n\nQue vous voyagiez pour affaires ou pour le plaisir, nos espaces modernes et meublés avec goût sont conçus pour que vous vous sentiez pleinement chez vous.",
              style: TextStyle(height: 1.5),
            ),
          ),
        ),
      ],
    );

    final servicesSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Nos Équipements & Services"),
        _buildInfoCard(
          isDark,
          child: const Column(
            children: [
              ListTile(
                leading: Icon(Icons.wifi, color: AppColors.champagneGold),
                title: Text("Connexion Wi-Fi Haute Vitesse"),
                subtitle: Text("Disponible gratuitement dans tout l'établissement."),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.local_cafe_outlined, color: AppColors.champagneGold),
                title: Text("Restauration Gourmande"),
                subtitle: Text("Petit-déjeuner buffet et service d'étage personnalisé."),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.spa_outlined, color: AppColors.champagneGold),
                title: Text("Espace Bien-être"),
                subtitle: Text("Spa, massage et soins relaxants sur demande."),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.directions_car_outlined, color: AppColors.champagneGold),
                title: Text("Service Navette"),
                subtitle: Text("Transfert aéroport et déplacements sécurisés à Abidjan."),
              ),
            ],
          ),
        ),
      ],
    );

    final contactSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Contact & Réservation"),
        _buildInfoCard(
          isDark,
          child: Column(
            children: [
              const ListTile(
                leading: Icon(Icons.location_on_outlined, color: AppColors.champagneGold),
                title: Text("Adresse Physique"),
                subtitle: Text("Riviera M'badon, Ambassade de Chine, Avenue Jean Malan, Abidjan, Côte d'Ivoire"),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.phone_outlined, color: AppColors.champagneGold),
                title: const Text("Service Commercial"),
                subtitle: const Text("+225 07 98 98 08 08 / 07 11 99 77 81"),
                trailing: const Icon(Icons.phone, size: 16, color: AppColors.textMuted),
                onTap: () => _launchUrl("tel:+2250798980808"),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.phone_in_talk_outlined, color: AppColors.champagneGold),
                title: const Text("Réception"),
                subtitle: const Text("07 11 99 77 82 / 01 50 67 86 95"),
                trailing: const Icon(Icons.phone, size: 16, color: AppColors.textMuted),
                onTap: () => _launchUrl("tel:+2250711997782"),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.restaurant_menu, color: AppColors.champagneGold),
                title: const Text("Restaurant"),
                subtitle: const Text("05 64 65 50 16"),
                trailing: const Icon(Icons.phone, size: 16, color: AppColors.textMuted),
                onTap: () => _launchUrl("tel:+2250564655016"),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.email_outlined, color: AppColors.champagneGold),
                title: const Text("E-mail"),
                subtitle: const Text("sweetrest.info@sra-hotel.com"),
                trailing: const Icon(Icons.mail_outline, size: 16, color: AppColors.textMuted),
                onTap: () => _launchUrl("mailto:sweetrest.info@sra-hotel.com"),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.language_outlined, color: AppColors.champagneGold),
                title: const Text("Site Web"),
                subtitle: const Text("https://sra-hotel.com"),
                trailing: const Icon(Icons.open_in_new, size: 16, color: AppColors.textMuted),
                onTap: () => _launchUrl("https://sra-hotel.com"),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.share_outlined, color: AppColors.champagneGold),
                title: const Text("WhatsApp (Réservation)"),
                subtitle: const Text("Discuter avec le service commercial"),
                trailing: const Icon(Icons.open_in_new, size: 16, color: AppColors.textMuted),
                onTap: () => _launchUrl("https://wa.me/2250150678695?text=Bonjour%20Sweet%20Rest%20Apart%20Hotel,%20je%20souhaite%20obtenir%20des%20informations%20sur%20vos%20chambres"),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.search, color: AppColors.champagneGold),
                title: const Text("Recherche Google / Avis"),
                subtitle: const Text("Sweet Rest Apart Hotel sur Google"),
                trailing: const Icon(Icons.open_in_new, size: 16, color: AppColors.textMuted),
                onTap: () => _launchUrl("https://www.google.com/search?q=sweet+rest+apart+hotel"),
              ),
            ],
          ),
        ),
      ],
    );

    Widget pageContent;
    if (isWide) {
      pageContent = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                historySection,
                const SizedBox(height: AppDimensions.spacingLg),
                servicesSection,
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.spacingLg),
          Expanded(
            child: Column(
              children: [
                contactSection,
              ],
            ),
          ),
        ],
      );
    } else {
      pageContent = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          historySection,
          const SizedBox(height: AppDimensions.spacingLg),
          servicesSection,
          const SizedBox(height: AppDimensions.spacingLg),
          contactSection,
          const SizedBox(height: AppDimensions.spacingLg),
        ],
      );
    }

    final bodyContent = Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: isWide ? 1000 : 600),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER AVEC LOGO & TITRE ---
              Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 60,
                      child: SraLogo(size: 80),
                    ),
                    const SizedBox(height: AppDimensions.spacingMd),
                    Text(
                      "Sweet Rest Aparthotel",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingXs),
                    Text(
                      "L'élégance et le confort à Abidjan",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textMuted,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spacingLg + 8),
              pageContent,
            ],
          ),
        ),
      ),
    );

    if (isNested) {
      return bodyContent;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("À propos de nous"),
      ),
      body: bodyContent,
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: AppDimensions.spacingXs, bottom: AppDimensions.spacingSm),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.labelUppercase,
      ),
    );
  }

  Widget _buildInfoCard(bool isDark, {required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: isDark ? Colors.white10 : AppColors.softGrey),
        boxShadow: const [AppShadows.shadowCard],
      ),
      child: Material(
        color: isDark ? AppColors.deepBlue : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );
  }
}
