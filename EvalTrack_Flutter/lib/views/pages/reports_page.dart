import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/app_colors.dart';
import '../components/app_layout.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'AI Reports',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section (Matching PHP)
          _buildPageHeader(),
          const SizedBox(height: 32),

          // Student Selection Filters
          _buildFiltersCard(),
          const SizedBox(height: 32),

          // AI Hub Card
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.p800, AppColors.p900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.p500, AppColors.mag],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          FontAwesomeIcons.wandMagicSparkles,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI Intelligence Hub',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.2,
                            ),
                          ),
                          Text(
                            'EvalTrack Smart Engine · Gemini 2.0 Flash',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),

                      // Custom TabBar (Matching portal.css tabs)
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          indicator: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          labelColor: AppColors.p600,
                          unselectedLabelColor: Colors.white38,
                          labelStyle: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                          dividerColor: Colors.transparent,
                          indicatorSize: TabBarIndicatorSize.tab,
                          tabs: const [
                            Tab(text: 'RECOMMENDATIONS'),
                            Tab(text: 'GRADE REPORTS'),
                            Tab(text: 'AI CHAT'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(color: Colors.white10, height: 1),

                // Content Area
                SizedBox(
                  height: 600,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildRecommendations(),
                      _buildGradeReports(),
                      _buildAIChat(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Academic Reporting',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: AppColors.g900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Institutional overview of student standings and AI evaluation data',
          style: GoogleFonts.dmSans(
            fontSize: 15,
            color: AppColors.g500,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendations() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  'Enrollment Eligibility',
                  'AI analyzed prerequisite paths. 85% of students are eligible for all major subjects.',
                  FontAwesomeIcons.microchip,
                  const Color(0xFFab47bc),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildInfoCard(
                  'Retention Forecast',
                  'Based on current GPA trends, retention rate is projected at 92%.',
                  FontAwesomeIcons.graduationCap,
                  const Color(0xFF26a69a),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildInfoCard(
                  'Strategic Insight',
                  'Highly recommended to increase faculty focus on Networking 1.',
                  FontAwesomeIcons.bolt,
                  const Color(0xFF42a5f5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String desc, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeReports() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.02),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(
            Colors.white.withOpacity(0.02),
          ),
          columns: const [
            DataColumn(
              label: Text(
                'STUDENT ID',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'SUBJECT',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'GRADE',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'STATUS',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
          rows: [
            _buildGradeRow('107655', 'CC 101', '85.5', 'Passed'),
            _buildGradeRow('107655', 'CC 102', '88.0', 'Passed'),
          ],
        ),
      ),
    );
  }

  DataRow _buildGradeRow(
    String id,
    String subject,
    String grade,
    String status,
  ) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            id,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        DataCell(Text(subject, style: const TextStyle(color: Colors.white))),
        DataCell(
          Text(
            grade,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: status == 'Passed'
                  ? const Color(0xFF26a69a).withOpacity(0.2)
                  : Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: status == 'Passed'
                    ? const Color(0xFF26a69a)
                    : Colors.red,
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAIChat() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildChatMessage(
                    'bot',
                    'Hello! I can answer detailed questions about student academic performance and enrollment eligibility.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Ask the AI about academic trends...',
                    hintStyle: const TextStyle(color: Colors.white24),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.p600,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  FontAwesomeIcons.paperPlane,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessage(String role, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (role == 'bot')
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                const Icon(
                  FontAwesomeIcons.microchip,
                  color: Color(0xFFab47bc),
                  size: 12,
                ),
                const SizedBox(width: 8),
                Text(
                  'EVALTRACK AI',
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFFab47bc),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFiltersCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.g100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(FontAwesomeIcons.userGraduate, size: 16, color: AppColors.p600),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Student Selection', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.g900)),
                  Text('Select a student to view detailed reports and recommendations', style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.g400, fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildDropdownField('Program', ['BSIT', 'BSEMC'])),
              const SizedBox(width: 16),
              Expanded(child: _buildDropdownField('Semester', ['First Semester', 'Second Semester', 'Summer'])),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildDropdownField('Year Level', ['First Year', 'Second Year', 'Third Year', 'Fourth Year'])),
              const SizedBox(width: 16),
              Expanded(child: _buildDropdownField('Student Type', ['Regular', 'Irregular', 'Transferee'])),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Student Search', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.g400)),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search by ID, Name, or Email...',
                        prefixIcon: const Icon(FontAwesomeIcons.magnifyingGlass, size: 12, color: AppColors.g300),
                        filled: true,
                        fillColor: AppColors.g50,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.g200)),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(child: _buildDropdownField('Selected Student', ['Select Student', 'John Doe (107655)'])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.g400)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: items[0],
          isExpanded: true,
          style: const TextStyle(fontSize: 13, color: AppColors.g900),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.g50,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.g200)),
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          ),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) {},
        ),
      ],
    );
  }
}
