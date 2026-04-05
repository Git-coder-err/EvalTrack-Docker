import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../components/app_layout.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return AppLayout(
      title: 'Home',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI HUB HERO
          _buildAIHubHero(user),

          const SizedBox(height: 40),

          // Section Header
          _buildSectionHeader(user),

          const SizedBox(height: 24),

          // Tool Grid
          _buildToolGrid(user),

          const SizedBox(height: 40),

          // Role-specific stats for Admin/Instructor
          if (user?.role != 'student') _buildStatGrid(user),

          const SizedBox(height: 40),

          // Insights & Health
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _buildRecentInsights()),
              const SizedBox(width: 32),
              Expanded(child: _buildSystemHealth()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatGrid(user) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 1200
            ? 4
            : (constraints.maxWidth > 800 ? 2 : 1);

        final stats = user?.role == 'admin' || user?.role == 'dean'
            ? _adminStats
            : _instructorStats;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 2.5,
          ),
          itemCount: stats.length,
          itemBuilder: (context, index) {
            final stat = stats[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.g100),
              ),
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: stat['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(stat['icon'], color: stat['color'], size: 20),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        stat['value'],
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: AppColors.g900,
                        ),
                      ),
                      Text(
                        stat['label'],
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.g400,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static const List<Map<String, dynamic>> _adminStats = [
    {
      'label': 'Total Users',
      'value': '15',
      'icon': FontAwesomeIcons.users,
      'color': AppColors.p600,
    },
    {
      'label': 'Total Students',
      'value': '10',
      'icon': FontAwesomeIcons.graduationCap,
      'color': AppColors.teal,
    },
    {
      'label': 'Irregular Students',
      'value': '5',
      'icon': FontAwesomeIcons.triangleExclamation,
      'color': AppColors.mag,
    },
    {
      'label': 'Evaluations',
      'value': '42',
      'icon': FontAwesomeIcons.chartLine,
      'color': AppColors.amber,
    },
  ];

  static const List<Map<String, dynamic>> _instructorStats = [
    {
      'label': 'Active Students',
      'value': '8',
      'icon': FontAwesomeIcons.users,
      'color': AppColors.p600,
    },
    {
      'label': 'Recent Evaluations',
      'value': '5',
      'icon': FontAwesomeIcons.message,
      'color': AppColors.mag,
    },
    {
      'label': 'Class GPA (Avg)',
      'value': '88.5',
      'icon': FontAwesomeIcons.arrowTrendUp,
      'color': AppColors.teal,
    },
  ];

  Widget _buildAIHubHero(user) {
    return Container(
      decoration: BoxDecoration(
        gradient: user?.role == 'student'
            ? const LinearGradient(
                colors: [AppColors.p800, AppColors.p900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [AppColors.p800, AppColors.p900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      padding: const EdgeInsets.all(40),
      child: Stack(
        children: [
          // Decorative glow (Matching PHP .card glow)
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [AppColors.mag.withOpacity(0.2), Colors.transparent],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      FontAwesomeIcons.wandMagicSparkles,
                      size: 12,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'AI Intelligence Hub',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.2,
                    letterSpacing: -0.5,
                  ),
                  children: [
                    TextSpan(
                      text: user?.role == 'student'
                          ? 'AI Learning '
                          : (user?.role == 'admin' || user?.role == 'dean'
                                ? 'Dean AI '
                                : 'Instructor AI '),
                    ),
                    TextSpan(
                      text: user?.role == 'student'
                          ? 'Assistants'
                          : (user?.role == 'admin' || user?.role == 'dean'
                                ? 'Command Center'
                                : 'Tooling'),
                      style: const TextStyle(color: Color(0xFFab47bc)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                user?.role == 'student'
                    ? 'Personalized AI advisors to guide your academic and professional journey'
                    : (user?.role == 'admin' || user?.role == 'dean'
                          ? 'Executive-level AI assistants for institutional strategy & management'
                          : 'Quick-access AI assistants for Program Heads at Jose Maria College'),
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 32),
              // User Info Card (Glassmorphism matching PHP)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.p500, AppColors.mag],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          user?.name[0].toUpperCase() ?? 'U',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back, ${user?.name.split(' ')[0]}!',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.role == 'student'
                                ? '${user?.program ?? 'BSIT'} · Year ${user?.yearLevel ?? 1} · ${user?.studentType ?? 'Regular'} Student · ID: ${user?.id}'
                                : (user?.role == 'admin' || user?.role == 'dean'
                                      ? 'Dean / Administrator'
                                      : 'Instructor / Program Head'),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.45),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms);
  }

  Widget _buildSectionHeader(user) {
    String title = 'Faculty AI Tools';
    if (user?.role == 'student') title = 'Academic AI Tools';
    if (user?.role == 'admin' || user?.role == 'dean')
      title = 'Executive AI Hub';

    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.g900,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _buildToolGrid(user) {
    List<Map<String, dynamic>> tools = _instructorTools;
    if (user?.role == 'student') tools = _studentTools;
    if (user?.role == 'admin' || user?.role == 'dean') tools = _adminTools;

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 1200
            ? 4
            : (constraints.maxWidth > 800 ? 2 : 1);
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 0.9,
          ),
          itemCount: tools.length,
          itemBuilder: (context, index) {
            final tool = tools[index];
            return _buildToolCard(tool, index);
          },
        );
      },
    );
  }

  static const List<Map<String, dynamic>> _adminTools = [
    {
      'icon': FontAwesomeIcons.shieldHalved,
      'color': AppColors.p600,
      'title': 'Academic Strategy',
      'desc':
          'Simulate program expansion plans, improve enrollment retention, and project future KPIs.',
      'btnIcon': FontAwesomeIcons.lightbulb,
      'btnText': 'Strategy AI',
    },
    {
      'icon': FontAwesomeIcons.calendarDay,
      'color': AppColors.amber,
      'title': 'Meeting Scheduler',
      'desc':
          'Coordinate meetings with Program Heads and faculty efficiently using AI scheduling.',
      'btnIcon': FontAwesomeIcons.calendarCheck,
      'btnText': 'Schedule Meeting',
    },
    {
      'icon': FontAwesomeIcons.chartPie,
      'color': AppColors.teal,
      'title': 'KPI Tracker',
      'desc':
          'Track institutional KPIs — passing rates, enrollment trends, and retention statistics.',
      'btnIcon': FontAwesomeIcons.bullseye,
      'btnText': 'Track KPIs',
    },
  ];

  Widget _buildToolCard(Map<String, dynamic> tool, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: AppColors.g100),
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: tool['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(tool['icon'], color: tool['color'], size: 22),
          ),
          const SizedBox(height: 24),
          Text(
            tool['title'],
            style: GoogleFonts.plusJakartaSans(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.g900,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            tool['desc'],
            style: GoogleFonts.dmSans(
              fontSize: 13.5,
              color: AppColors.g500,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(tool['btnIcon'], size: 14),
            label: Text(
              tool['btnText'],
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: AppColors.p600,
              elevation: 0,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms * index).slideY(begin: 0.1, end: 0);
  }

  Widget _buildRecentInsights() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.g100),
      ),
      child: Column(
        children: [
          _buildCardHeader('Recent Insights', FontAwesomeIcons.chartLine),
          const Padding(
            padding: EdgeInsets.all(60),
            child: Column(
              children: [
                const Icon(
                  FontAwesomeIcons.wandMagicSparkles,
                  size: 48,
                  color: Color(0x1A000000),
                ),
                SizedBox(height: 16),
                Text(
                  'NO NEW AI INSIGHTS AVAILABLE FOR TODAY',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Color(0x4D000000),
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemHealth() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.g100),
      ),
      child: Column(
        children: [
          _buildCardHeader('System Health', FontAwesomeIcons.shieldHalved),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildHealthItem('Database', 'Online', Colors.green),
                const SizedBox(height: 16),
                _buildHealthItem('AI Services', 'Ready', Colors.green),
                const SizedBox(height: 16),
                const Divider(color: AppColors.g100),
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Text(
                      'Last Sync: 2 mins ago',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.g400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardHeader(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.g100)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.g400),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.g900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthItem(String label, String status, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: AppColors.g400,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            status,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  static const List<Map<String, dynamic>> _studentTools = [
    {
      'icon': FontAwesomeIcons.briefcase,
      'color': AppColors.p600,
      'title': 'Career Path Advisor',
      'desc':
          'Tell the AI your dream IT role — get a complete, personalized roadmap with required skills and certifications.',
      'btnIcon': FontAwesomeIcons.mapLocationDot,
      'btnText': 'Start Planning',
    },
    {
      'icon': FontAwesomeIcons.calendarDay,
      'color': AppColors.amber,
      'title': 'Smart Schedule Builder',
      'desc':
          'Generate an optimized, printable study schedule. Tell the AI your subjects and it will build your week.',
      'btnIcon': FontAwesomeIcons.calendarCheck,
      'btnText': 'Build Schedule',
    },
    {
      'icon': FontAwesomeIcons.bullseye,
      'color': AppColors.teal,
      'title': 'Study Goal Coach',
      'desc':
          'Set study goals, identify problem subjects, and get an accountability plan from the AI coach.',
      'btnIcon': FontAwesomeIcons.flagCheckered,
      'btnText': 'Set My Goals',
    },
    {
      'icon': FontAwesomeIcons.bookOpen,
      'color': Colors.blue,
      'title': 'Book & Resource Finder',
      'desc':
          'Get curated textbooks, free online courses, and educational resources based on your current subjects.',
      'btnIcon': FontAwesomeIcons.magnifyingGlass,
      'btnText': 'Find Resources',
    },
  ];

  static const List<Map<String, dynamic>> _instructorTools = [
    {
      'icon': FontAwesomeIcons.calendarDay,
      'color': AppColors.p600,
      'title': 'Dean Scheduling',
      'desc':
          'Automate meeting coordination with the Dean\'s schedule using AI-powered planning.',
      'btnIcon': FontAwesomeIcons.calendarCheck,
      'btnText': 'Schedule Meeting',
    },
    {
      'icon': FontAwesomeIcons.bookOpen,
      'color': AppColors.amber,
      'title': 'Curriculum Resources',
      'desc':
          'Get curated links to teaching materials, syllabi, and reference books for your subjects.',
      'btnIcon': FontAwesomeIcons.magnifyingGlass,
      'btnText': 'Find Materials',
    },
    {
      'icon': FontAwesomeIcons.bullseye,
      'color': AppColors.teal,
      'title': 'Teaching Goal Coach',
      'desc':
          'Set and track professional teaching goals, class performance targets, and curriculum milestones.',
      'btnIcon': FontAwesomeIcons.flagCheckered,
      'btnText': 'Set Goals',
    },
    {
      'icon': FontAwesomeIcons.wandMagicSparkles,
      'color': AppColors.mag,
      'title': 'AI Exam Generator',
      'desc':
          'Paste a topic or syllabus block and instantly generate quizzes, MCQs, and rubrics.',
      'btnIcon': FontAwesomeIcons.bolt,
      'btnText': 'Generate Exam',
    },
  ];
}
