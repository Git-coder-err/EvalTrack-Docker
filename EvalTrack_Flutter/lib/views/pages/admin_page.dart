import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import '../../core/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../components/app_layout.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<dynamic> _users = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _roleFilter = '';

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() => _isLoading = true);
    try {
      final token = context.read<AuthProvider>().token;
      final response = await http.get(
        Uri.parse('http://127.0.0.1:5000/api/users'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        setState(() => _users = jsonDecode(response.body));
      }
    } catch (e) {
      debugPrint('Error fetching users: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _users.where((u) {
      final matchesSearch = u['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          u['id'].toString().contains(_searchQuery);
      final matchesRole = _roleFilter.isEmpty || u['role'] == _roleFilter;
      return matchesSearch && matchesRole;
    }).toList();

    return AppLayout(
      title: 'User Administration',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(filteredUsers.length),
          const SizedBox(height: 32),
          _buildFilterBar(),
          const SizedBox(height: 24),
          _buildUserTable(filteredUsers),
        ],
      ),
    );
  }

  Widget _buildHeader(int count) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Management',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: AppColors.g900,
              ),
            ),
            Text(
              'Manage all registered users across all roles',
              style: GoogleFonts.dmSans(fontSize: 15, color: AppColors.g500),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.p600,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            '$count Users',
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.g100),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Search by name or ID...',
                prefixIcon: const Icon(FontAwesomeIcons.magnifyingGlass, size: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _roleFilter.isEmpty ? null : _roleFilter,
              hint: const Text('All Roles'),
              items: const [
                DropdownMenuItem(value: '', child: Text('All Roles')),
                DropdownMenuItem(value: 'student', child: Text('Students')),
                DropdownMenuItem(value: 'instructor', child: Text('Instructors')),
                DropdownMenuItem(value: 'admin', child: Text('Admins / Deans')),
              ],
              onChanged: (v) => setState(() => _roleFilter = v ?? ''),
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserTable(List<dynamic> users) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.g100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(AppColors.g50),
          columns: const [
            DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('FULL NAME', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('ROLE', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('ACTION', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: users.map((u) => DataRow(
            cells: [
              DataCell(Text(u['id'].toString(), style: const TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Row(
                children: [
                  CircleAvatar(radius: 14, backgroundColor: AppColors.p100, child: Text(u['name'][0])),
                  const SizedBox(width: 12),
                  Text(u['name'], style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              )),
              DataCell(Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (u['role'] == 'admin' || u['role'] == 'dean') ? AppColors.p100 : Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(u['role'], style: TextStyle(color: (u['role'] == 'admin' || u['role'] == 'dean') ? AppColors.p700 : Colors.blue, fontSize: 11, fontWeight: FontWeight.bold)),
              )),
              DataCell(Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: u['status'] == 'Active' ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(u['status'] ?? 'Active', style: TextStyle(color: u['status'] == 'Active' ? Colors.green : Colors.red, fontSize: 11, fontWeight: FontWeight.bold)),
              )),
              DataCell(IconButton(icon: const Icon(FontAwesomeIcons.ellipsis), onPressed: () {})),
            ],
          )).toList(),
        ),
      ),
    );
  }
}
