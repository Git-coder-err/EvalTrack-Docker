import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/app_colors.dart';
import '../../providers/auth_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _passwordController = TextEditingController();
  
  String? _role;
  String _program = 'BSIT';
  String _studentType = 'regular';
  bool _obscurePassword = true;
  String? _error;
  bool _isLoading = false;

  Future<void> _handleRegister() async {
    if (_role == null) {
      setState(() => _error = 'Please select an account type');
      return;
    }

    if (!_emailController.text.endsWith('@jmc.edu.ph')) {
      setState(() => _error = 'Only school-issued JMC emails permitted');
      return;
    }

    setState(() {
      _error = null;
      _isLoading = true;
    });

    final authProvider = context.read<AuthProvider>();
    
    // Note: I need to add a register method to AuthProvider if it doesn't exist
    // For now, let's assume it exists or we will add it.
    final result = await authProvider.register({
      'role': _role,
      'name': _nameController.text,
      'email': _emailController.text,
      'id': _role == 'student' ? _studentIdController.text : 'INS${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}',
      'password': _role == 'student' ? _studentIdController.text : _passwordController.text,
      'program': _role == 'student' ? _program : null,
      'student_type': _role == 'student' ? _studentType : null,
    });

    if (result['success'] == true) {
      if (mounted) Navigator.pushReplacementNamed(context, '/');
    } else {
      setState(() {
        _error = result['message'];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: 850,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                )
              ],
            ),
            child: Row(
              children: [
                // Left Side (Branding) - Matching Login
                Expanded(
                  child: Container(
                    height: 650,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.p800, AppColors.p600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        bottomLeft: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/logo.png', height: 120),
                        const SizedBox(height: 24),
                        Text(
                          'Jose Maria College',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'Foundation, Inc.',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Right Side (Form)
                Expanded(
                  child: Container(
                    height: 650,
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
                    color: const Color(0xFFE6DEEC),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Create Account',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.p700,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Register using your JMC email',
                          style: GoogleFonts.dmSans(color: AppColors.g500, fontSize: 14),
                        ),
                        const SizedBox(height: 24),

                        if (_error != null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: AppColors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.red.withOpacity(0.2)),
                            ),
                            child: Text(_error!, style: const TextStyle(color: AppColors.red, fontSize: 12)),
                          ).animate().shake(),

                        // Role Select
                        _buildDropdown(
                          value: _role,
                          hint: 'Select Account Type',
                          items: const [
                            DropdownMenuItem(value: 'student', child: Text('Student')),
                            DropdownMenuItem(value: 'instructor', child: Text('Instructor')),
                          ],
                          onChanged: (v) => setState(() => _role = v),
                        ),
                        const SizedBox(height: 12),

                        // Name
                        _buildTextField(
                          controller: _nameController,
                          hint: 'Full Name',
                          icon: FontAwesomeIcons.user,
                        ),
                        const SizedBox(height: 12),

                        // Email
                        _buildTextField(
                          controller: _emailController,
                          hint: 'JMC Email (@jmc.edu.ph)',
                          icon: FontAwesomeIcons.envelope,
                        ),
                        const SizedBox(height: 12),

                        // Student Specific Fields
                        if (_role == 'student') ...[
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  controller: _studentIdController,
                                  hint: 'Student ID',
                                  icon: FontAwesomeIcons.idCard,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildDropdown(
                                  value: _program,
                                  items: const [
                                    DropdownMenuItem(value: 'BSIT', child: Text('BSIT')),
                                    DropdownMenuItem(value: 'BSEMC', child: Text('BSEMC')),
                                  ],
                                  onChanged: (v) => setState(() => _program = v!),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildDropdown(
                            value: _studentType,
                            items: const [
                              DropdownMenuItem(value: 'regular', child: Text('Regular Enrollment')),
                              DropdownMenuItem(value: 'irregular', child: Text('Irregular Enrollment')),
                              DropdownMenuItem(value: 'transferee', child: Text('Transferee')),
                            ],
                            onChanged: (v) => setState(() => _studentType = v!),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.p600.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border(left: BorderSide(color: AppColors.p600, width: 3)),
                            ),
                            child: const Text(
                              'Security Note: Your password will default to your Student ID Number. You can change it after login.',
                              style: TextStyle(fontSize: 11, color: AppColors.p600, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],

                        // Instructor Specific Fields
                        if (_role == 'instructor') ...[
                          _buildTextField(
                            controller: _passwordController,
                            hint: 'Create Password',
                            icon: FontAwesomeIcons.lock,
                            isPassword: true,
                            obscure: _obscurePassword,
                            onToggleObscure: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ],

                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleRegister,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.p600,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                              elevation: 0,
                            ),
                            child: _isLoading 
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Text('Register Account', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),

                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Already have an account? ', style: TextStyle(color: AppColors.g500, fontSize: 13)),
                            TextButton(
                              onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                              child: const Text('Login here', style: TextStyle(color: AppColors.p600, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? onToggleObscure,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: AppColors.p600, size: 16),
          suffixIcon: isPassword ? IconButton(
            icon: Icon(obscure ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye, size: 14, color: AppColors.p600),
            onPressed: onToggleObscure,
          ) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    String? hint,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: hint != null ? Text(hint, style: TextStyle(fontSize: 14, color: AppColors.g400)) : null,
          isExpanded: true,
          items: items,
          onChanged: onChanged,
          style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
        ),
      ),
    );
  }
}
