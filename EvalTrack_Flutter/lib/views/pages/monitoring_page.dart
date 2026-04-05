import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/app_colors.dart';
import '../components/app_layout.dart';

class MonitoringPage extends StatefulWidget {
  const MonitoringPage({super.key});

  @override
  State<MonitoringPage> createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Student Monitoring',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 32),

          // Filters Card
          _buildFiltersCard(),
          const SizedBox(height: 32),

          // Student List List
          _buildStudentList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Student Monitoring Dashboard',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: AppColors.g900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Track student enrollment status, academic progress, and subject enrollment history',
          style: GoogleFonts.dmSans(
            fontSize: 15,
            color: AppColors.g500,
            fontWeight: FontWeight.w500,
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
              const Icon(FontAwesomeIcons.filter, size: 16, color: AppColors.p600),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Student Filter & Selection', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.g900)),
                  Text('Filter students by various criteria and select for detailed monitoring', style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.g400, fontWeight: FontWeight.w500)),
                ],
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(FontAwesomeIcons.arrowsRotate, size: 12),
                label: const Text('Refresh Data'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(120, 44),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildDropdownFilter('Program', ['All Programs', 'BSIT', 'BSEMC'])),
              const SizedBox(width: 16),
              Expanded(child: _buildDropdownFilter('Year Level', ['All Years', '1st Year', '2nd Year', '3rd Year', '4th Year'])),
              const SizedBox(width: 16),
              Expanded(child: _buildDropdownFilter('Academic Year', ['All Years', '2023-2024', '2024-2025', '2025-2026'])),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildDropdownFilter('Enrollment Status', ['All Status', 'Enrolled', 'Pending', 'Dropped', 'Graduated'])),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Search Student', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.g400)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _searchController,
                      style: const TextStyle(fontSize: 13),
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
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownFilter(String label, List<String> items) {
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

  Widget _buildStudentList() {
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
              const Icon(FontAwesomeIcons.users, size: 16, color: AppColors.p600),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Student List', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.g900)),
                  Text('Click on a student to view detailed enrollment information', style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.g400, fontWeight: FontWeight.w500)),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: AppColors.p50, borderRadius: BorderRadius.circular(100)),
                child: const Text('15 Students', style: TextStyle(color: AppColors.p600, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Student Table (or list in mobile, but web-like in desktop)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(60),
              child: Column(
                children: [
                  const Icon(FontAwesomeIcons.graduationCap, size: 48, color: AppColors.g100),
                  const SizedBox(height: 16),
                  Text('No students match your current filtering criteria', style: TextStyle(color: AppColors.g400, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
