import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/app_colors.dart';
import '../components/app_layout.dart';

class EnrollmentPage extends StatefulWidget {
  const EnrollmentPage({super.key});

  @override
  State<EnrollmentPage> createState() => _EnrollmentPageState();
}

class _EnrollmentPageState extends State<EnrollmentPage> {
  final _searchController = TextEditingController();
  bool _showEnrollmentProcess = false;

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Enrollment',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 32),

          // Search Student
          _buildStepCard(
            'Select Student',
            'Choose a student to process enrollment',
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search by Student ID, Name, or Email...',
                          prefixIcon: const Icon(FontAwesomeIcons.magnifyingGlass, size: 14, color: AppColors.g300),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.g200)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.g200)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () => setState(() => _showEnrollmentProcess = true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.p600,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(120, 54),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Search'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (_showEnrollmentProcess) ...[
            const SizedBox(height: 32),
            _buildAIRecommendations(),
            const SizedBox(height: 32),
            _buildEnrollmentProcess(),
          ],

          const SizedBox(height: 32),
          _buildEnrollmentHistory(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enrollment Process',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: AppColors.g900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Student enrollment with AI recommendations and ADD/DROP functionality',
          style: GoogleFonts.dmSans(
            fontSize: 15,
            color: AppColors.g500,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStepCard(String title, String desc, Widget child) {
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
                  Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.g900)),
                  Text(desc, style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.g400, fontWeight: FontWeight.w500)),
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

  Widget _buildAIRecommendations() {
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
              const Icon(FontAwesomeIcons.lightbulb, size: 16, color: Colors.amber),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('AI Recommendations', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.g900)),
                  Text('Recommended subjects based on academic progress and prerequisites', style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.g400, fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildRecommendationChip('CC 201', 'Algorithm & Complexity'),
              _buildRecommendationChip('NET 1', 'Networking 1'),
              _buildRecommendationChip('OS 1', 'Operating Systems'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationChip(String code, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.p50.withOpacity(0.5),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColors.p200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(FontAwesomeIcons.circleCheck, size: 12, color: AppColors.p600),
          const SizedBox(width: 8),
          Text(
            '$code: $title',
            style: const TextStyle(color: AppColors.p900, fontWeight: FontWeight.w700, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildEnrollmentProcess() {
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
              const Icon(FontAwesomeIcons.userPlus, size: 16, color: Colors.green),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Enrollment Process', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.g900)),
                  Text('ADD/DROP subjects for selected student', style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.g400, fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Current Subject Load', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.g700)),
                    const SizedBox(height: 16),
                    _buildSubjectItem('CC 101', 'Intro to Computing', 'Passed'),
                    _buildSubjectItem('CC 102', 'Computer Programming 1', 'Passed'),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Add Specific Subject', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.g700)),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.g50,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.g200)),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'CC201', child: Text('CC201 - Algorithm & Complexity')),
                        DropdownMenuItem(value: 'NET1', child: Text('NET1 - Networking 1')),
                      ],
                      onChanged: (v) {},
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Add Subject'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Divider(color: AppColors.g100),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem('Total Units', '6.0'),
              _buildSummaryItem('Status', 'Pending', color: Colors.amber),
              const Spacer(),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.p600,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Proceed to Enrollment'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectItem(String code, String title, String status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.g50, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          const Icon(FontAwesomeIcons.book, size: 12, color: AppColors.g400),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(code, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                Text(title, style: const TextStyle(color: AppColors.g500, fontSize: 11)),
              ],
            ),
          ),
          IconButton(onPressed: () {}, icon: const Icon(FontAwesomeIcons.trash, size: 12, color: AppColors.red)),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(right: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.g400, fontWeight: FontWeight.bold)),
          Text(value, style: TextStyle(fontSize: 18, color: color ?? AppColors.g900, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildEnrollmentHistory() {
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
              const Icon(FontAwesomeIcons.history, size: 16, color: AppColors.g400),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Enrollment History', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.g900)),
                  Text('Recent enrollment transactions', style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.g400, fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(FontAwesomeIcons.inbox, size: 32, color: AppColors.g200),
                  SizedBox(height: 16),
                  Text('No enrollment history available', style: TextStyle(color: AppColors.g400, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
