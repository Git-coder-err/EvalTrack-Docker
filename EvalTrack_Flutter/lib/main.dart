import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/app_colors.dart';
import 'providers/auth_provider.dart';
import 'views/pages/login_page.dart';
import 'views/pages/register_page.dart';
import 'views/pages/must_change_password_page.dart';
import 'views/pages/dashboard_page.dart';
import 'views/pages/reports_page.dart';
import 'views/pages/evaluate_page.dart';
import 'views/pages/messages_page.dart';
import 'views/pages/admin_page.dart';
import 'views/pages/enrollment_page.dart';
import 'views/pages/monitoring_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: const EvalTrackApp(),
    ),
  );
}

class EvalTrackApp extends StatelessWidget {
  const EvalTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EvalTrack | Premium Academic Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.p600,
          primary: AppColors.p600,
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/must-change-password': (context) => const MustChangePasswordPage(),
        '/': (context) => const ProtectedRoute(child: DashboardPage()),
        '/reports': (context) => const ProtectedRoute(child: ReportsPage()),
        '/evaluations': (context) =>
            const ProtectedRoute(child: EvaluatePage()),
        '/messages': (context) => const ProtectedRoute(child: MessagesPage()),
        '/admin': (context) => const ProtectedRoute(child: AdminPage()),
        '/enrollment': (context) => const ProtectedRoute(child: EnrollmentPage()),
        '/monitoring': (context) => const ProtectedRoute(child: MonitoringPage()),
      },
    );
  }
}

class ProtectedRoute extends StatelessWidget {
  final Widget child;
  const ProtectedRoute({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (!authProvider.isAuthenticated) {
      return const LoginPage();
    }

    if (authProvider.user?.mustChangePassword == true) {
      return const MustChangePasswordPage();
    }

    return child;
  }
}
