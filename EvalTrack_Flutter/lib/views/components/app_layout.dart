import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:particles_fly/particles_fly.dart';
import '../../core/app_colors.dart';
import '../../providers/auth_provider.dart';

class AppLayout extends StatefulWidget {
  final Widget child;
  final String title;

  const AppLayout({super.key, required this.child, required this.title});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  bool _isSidebarOpen = true;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background Particles
          ParticlesFly(
            height: size.height,
            width: size.width,
            connectDots: false,
            numberOfParticles: 30,
            lineColor: AppColors.p500.withOpacity(0.05),
            onTapAnimation: false,
            isRandomColor: false,
            maxParticleSize: 2,
          ),

          Row(
            children: [
              // Sidebar
              if (_isSidebarOpen) _buildSidebar(user),

              // Main Content Area
              Expanded(
                child: Column(
                  children: [
                    // Topbar
                    _buildTopbar(user),

                    // Main View
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(32),
                        child: widget.child,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(user) {
    String portalSub = 'Faculty Portal';
    if (user?.role == 'student') portalSub = 'Student Portal';
    if (user?.role == 'admin' || user?.role == 'dean')
      portalSub = 'Dean / Admin Portal';

    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: AppColors.p900,
        border: Border(
          right: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
      ),
      child: Column(
        children: [
          // Sidebar Logo
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset('assets/images/logo.png', height: 32),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EvalTrack',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      portalSub,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white54,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Nav Groups
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildNavGroupLabel('MAIN'),
                _buildNavItem('Home', FontAwesomeIcons.house, '/'),
                if (user?.role == 'admin' || user?.role == 'dean')
                  _buildNavItem(
                    'User Administration',
                    FontAwesomeIcons.users,
                    '/admin',
                  ),
                _buildNavItem(
                  'AI Reports',
                  FontAwesomeIcons.chartBar,
                  '/reports',
                ),
                _buildNavItem(
                  'Evaluate / Grade',
                  FontAwesomeIcons.clipboardCheck,
                  '/evaluations',
                ),
                if (user?.role == 'instructor' || user?.role == 'admin' || user?.role == 'dean') ...[
                  _buildNavItem(
                    'Enrollment',
                    FontAwesomeIcons.userPlus,
                    '/enrollment',
                  ),
                  _buildNavItem(
                    'Student Monitoring',
                    FontAwesomeIcons.users,
                    '/monitoring',
                  ),
                ],

                const SizedBox(height: 24),
                _buildNavGroupLabel('TOOLS'),
                _buildNavItem(
                  'AI Exam Generator',
                  FontAwesomeIcons.robot,
                  '/exams',
                ),
                _buildNavItem(
                  'Admin Messages',
                  FontAwesomeIcons.comments,
                  '/messages',
                ),
              ],
            ),
          ),

          // Sidebar Footer
          _buildSidebarFooter(user),
        ],
      ),
    );
  }

  Widget _buildNavGroupLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 12, top: 8),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          color: Colors.white24,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildNavItem(String title, IconData icon, String path) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '/';
    final isActive = currentRoute == path;

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.white.withOpacity(0.05) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        gradient: isActive
            ? LinearGradient(
                colors: [Colors.white.withOpacity(0.1), Colors.transparent],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? AppColors.p400 : Colors.white38,
          size: 16,
        ),
        title: Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            color: isActive ? Colors.white : Colors.white38,
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
        onTap: () {
          if (!isActive) {
            Navigator.pushReplacementNamed(context, path);
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        dense: true,
      ),
    );
  }

  Widget _buildSidebarFooter(user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.p500,
                  child: Text(
                    user?.name[0].toUpperCase() ?? 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? 'Loading...',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        user?.role == 'instructor'
                            ? 'Instructor / Prg. Head'
                            : 'User',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => context.read<AuthProvider>().logout(),
            icon: const Icon(
              FontAwesomeIcons.rightFromBracket,
              size: 12,
              color: AppColors.red,
            ),
            label: const Text(
              'Sign Out',
              style: TextStyle(
                color: AppColors.red,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: TextButton.styleFrom(
              minimumSize: const Size(double.infinity, 44),
              backgroundColor: AppColors.red.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopbar(user) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.g200)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.bars, size: 16),
            onPressed: () => setState(() => _isSidebarOpen = !_isSidebarOpen),
          ),
          const SizedBox(width: 12),
          const Icon(FontAwesomeIcons.school, size: 14, color: AppColors.g400),
          const SizedBox(width: 8),
          Text(
            'JMC',
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.g400,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            FontAwesomeIcons.chevronRight,
            size: 8,
            color: AppColors.g300,
          ),
          const SizedBox(width: 8),
          Text(
            widget.title,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.g900,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),

          const Spacer(),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.g50,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: AppColors.g200),
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  user?.name ?? '',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.g700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            DateFormat('hh:mm a').format(DateTime.now()),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.g400,
            ),
          ),
        ],
      ),
    );
  }
}
