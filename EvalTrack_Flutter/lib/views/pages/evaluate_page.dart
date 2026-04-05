import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/app_colors.dart';
import '../components/app_layout.dart';

class EvaluatePage extends StatefulWidget {
  const EvaluatePage({super.key});

  @override
  State<EvaluatePage> createState() => _EvaluatePageState();
}

class _EvaluatePageState extends State<EvaluatePage> {
  final _searchController = TextEditingController();
  bool _isSyncing = false;
  bool _showForecast = false;

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Evaluate / Grade',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _buildGradingForm()),
              const SizedBox(width: 32),
              Expanded(child: _buildStudentSidebar()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Evaluate & Grade',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: AppColors.g900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Search a student → set semester → enter grades → sync AI automation',
          style: GoogleFonts.dmSans(
            fontSize: 15,
            color: AppColors.g500,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildGradingForm() {
    return Column(
      children: [
        // STEP 1: Find Student
        _buildStepCard(
          1,
          'Find Student',
          'Search by name or student ID',
          Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Type student name or ID number...',
                  prefixIcon: const Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    size: 14,
                    color: AppColors.g300,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.g200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.g200),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // STEP 2: Select Semester
        _buildStepCard(
          2,
          'Select Semester',
          'Choose the target academic term to grade',
          SizedBox(
            width: 320,
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Target Semester',
                labelStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.g400,
                ),
                filled: true,
                fillColor: AppColors.g50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.g200),
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: '2025-1',
                  child: Text('2025 — 1st Semester'),
                ),
                DropdownMenuItem(
                  value: '2025-2',
                  child: Text('2025 — 2nd Semester'),
                ),
              ],
              onChanged: (v) {},
            ),
          ),
        ),
        const SizedBox(height: 24),

        // STEP 3: Grade Input
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.g100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    const Icon(
                      FontAwesomeIcons.tableCells,
                      size: 16,
                      color: AppColors.p600,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Grade Input',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.g900,
                          ),
                        ),
                        Text(
                          'Enter grades below',
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            color: AppColors.g400,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.p600.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Text(
                        'Regular Mode',
                        style: TextStyle(
                          color: AppColors.p600,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: AppColors.g100, height: 1),
              _buildTable(),
              Padding(
                padding: const EdgeInsets.all(24),
                child: ElevatedButton.icon(
                  onPressed: _isSyncing
                      ? null
                      : () {
                          setState(() => _isSyncing = true);
                          Future.delayed(const Duration(seconds: 2), () {
                            setState(() {
                              _isSyncing = false;
                              _showForecast = true;
                            });
                          });
                        },
                  icon: _isSyncing
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(FontAwesomeIcons.bolt, size: 14),
                  label: Text(
                    _isSyncing
                        ? 'Syncing AI Records...'
                        : 'Generate n8n Automation & Sync AI Records',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              if (_showForecast) ...[
                const SizedBox(height: 24),
                _buildForecastBox(),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(FontAwesomeIcons.chartBar, size: 14),
                  label: const Text('Proceed to AI Reports'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.p600,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        horizontalMargin: 24,
        headingRowColor: WidgetStateProperty.all(AppColors.g50),
        columns: const [
          DataColumn(
            label: Text(
              'SUBJECT CODE',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: AppColors.g400,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'DESCRIPTION',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: AppColors.g400,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'PREREQUISITE',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: AppColors.g400,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'GRADE',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: AppColors.g400,
              ),
            ),
          ),
        ],
        rows: [
          _buildRow('CC 101', 'Introduction to Computing 1', 'none'),
          _buildRow('CC 102', 'Computer Programming 1', 'none'),
          _buildRow('GE 4', 'Reading in Philippine History', 'none'),
        ],
      ),
    );
  }

  DataRow _buildRow(String code, String desc, String pre) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            code,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.g900,
              fontSize: 13,
            ),
          ),
        ),
        DataCell(
          Text(
            desc,
            style: const TextStyle(color: AppColors.g600, fontSize: 13),
          ),
        ),
        DataCell(
          Text(
            pre,
            style: const TextStyle(color: AppColors.g400, fontSize: 12),
          ),
        ),
        DataCell(
          Container(
            width: 60,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.g50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.g200),
            ),
            child: const TextField(
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
              decoration: InputDecoration(border: InputBorder.none),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepCard(int num, String title, String desc, Widget child) {
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
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.p600,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    num.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.g900,
                    ),
                  ),
                  Text(
                    desc,
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: AppColors.g400,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }

  Widget _buildStudentSidebar() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.p900,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    FontAwesomeIcons.circleInfo,
                    color: AppColors.p300,
                    size: 16,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'System Guidance',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Please select a student first to begin the evaluation process. The AI engine will automatically compute eligibility once grades are synced.',
                style: GoogleFonts.dmSans(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildForecastBox() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.p50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.p200, style: BorderStyle.none), // Wait, web uses dashed?
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(FontAwesomeIcons.wandMagicSparkles, size: 14, color: AppColors.p600),
              const SizedBox(width: 12),
              Text(
                'AI Enrollment Recommendation',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.p900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Based on passed subjects, student is eligible for these next semester:',
            style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.p800.withOpacity(0.7), fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildForecastChip('CC 201'),
              _buildForecastChip('NET 1'),
              _buildForecastChip('OS 1'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildForecastChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColors.p200),
      ),
      child: Text(
        label,
        style: const TextStyle(color: AppColors.p600, fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }
}
