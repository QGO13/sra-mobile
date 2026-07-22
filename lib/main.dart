import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/core/constants/app_constants.dart';
import 'package:sra_hotel/core/routes/app_routes.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/loading_indicator.dart';
import 'package:sra_hotel/core/widgets/sra_logo.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_event.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_state.dart';
import 'package:sra_hotel/features/auth/presentation/pages/login_page.dart';
import 'package:sra_hotel/features/auth/presentation/pages/register_page.dart';
import 'package:sra_hotel/features/home/presentation/pages/client_shell_page.dart';
import 'package:sra_hotel/features/client_booking/presentation/pages/client_booking_page.dart';
import 'package:sra_hotel/features/cart/presentation/pages/cart_page.dart';
import 'package:sra_hotel/features/checkout/presentation/pages/pre_invoice_page.dart';
import 'package:sra_hotel/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:sra_hotel/features/client_booking/presentation/bloc/client_booking_bloc.dart';
import 'package:sra_hotel/features/checkout/presentation/bloc/payment_bloc.dart';
import 'package:sra_hotel/features/admin_dashboard/presentation/pages/admin_dashboard_page.dart';
import 'package:sra_hotel/features/reception/presentation/pages/reception_dashboard_page.dart';
import 'package:sra_hotel/features/reception/presentation/bloc/reception_bloc.dart';
import 'package:sra_hotel/features/reception/presentation/bloc/reception_event.dart';
import 'package:sra_hotel/injection_container.dart' as di;
import 'package:sra_hotel/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependency injection container (GetIt)
  await di.init();
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  // Helper method to change locale dynamically
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.changeLocale(newLocale);
  }

  // Helper method to change theme mode dynamically
  static void setThemeMode(BuildContext context, ThemeMode newThemeMode) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.changeThemeMode(newThemeMode);
  }

  // Helper method to get theme mode dynamically
  static ThemeMode getThemeMode(BuildContext context) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    return state?._themeMode ?? ThemeMode.system;
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale = const Locale('fr'); // Default to French
  ThemeMode _themeMode = ThemeMode.system;

  void changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void changeThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>()..add(AuthCheckRequested()),
        ),
        BlocProvider<CartBloc>(
          create: (_) => di.sl<CartBloc>(),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: _themeMode, // Adapts to system dark mode settings
        locale: _locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        initialRoute: AppRoutes.welcome,
        routes: {
          AppRoutes.welcome: (context) => const SraWelcomePage(),
          AppRoutes.login: (context) => const LoginPage(),
          AppRoutes.register: (context) => const RegisterPage(),
          AppRoutes.home: (context) => const ClientShellPage(),
          AppRoutes.search: (context) => BlocProvider<ClientBookingBloc>(
                create: (_) => di.sl<ClientBookingBloc>(),
                child: const ClientBookingPage(),
              ),
          AppRoutes.cart: (context) => const CartPage(),
          AppRoutes.preInvoice: (context) => BlocProvider<PaymentBloc>(
                create: (_) => di.sl<PaymentBloc>(),
                child: const PreInvoicePage(),
              ),
          AppRoutes.backofficeAdmin: (context) => const AdminDashboardPage(),
          AppRoutes.backofficeReception: (context) => BlocProvider<ReceptionBloc>(
                create: (_) => di.sl<ReceptionBloc>()..add(LoadReceptionDashboardEvent()),
                child: const ReceptionDashboardPage(),
              ),
        },
      ),
    );
  }
}

class SraWelcomePage extends StatelessWidget {
  const SraWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.imperialNightBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const SraLogo(size: 130, iconSize: 65),
              const SizedBox(height: 40),
              Text(
                "SRA HÔTEL",
                textAlign: TextAlign.center,
                style: theme.textTheme.displayMedium?.copyWith(
                  color: AppColors.champagneGold,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '"Make yourself at home"',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is Authenticated) {
                    final role = state.user.role.toLowerCase();
                    if (role.contains('admin')) {
                      Navigator.of(context).pushReplacementNamed(AppRoutes.backofficeAdmin);
                    } else if (role.contains('reception')) {
                      Navigator.of(context).pushReplacementNamed(AppRoutes.backofficeReception);
                    } else {
                      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
                    }
                  } else if (state is Unauthenticated) {
                    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
                  } else if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
                  }
                },
                builder: (context, state) {
                  return const Column(
                    children: [
                      LoadingIndicator(color: AppColors.champagneGold),
                      SizedBox(height: 20),
                      Text(
                        "Initialisation de la session...",
                        style: TextStyle(color: Colors.white60, fontSize: 15),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}

