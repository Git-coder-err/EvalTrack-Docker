import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:particles_fly/particles_fly.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/app_colors.dart';
import '../../providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _error;

  Future<void> _handleLogin() async {
    setState(() => _error = null);
    
    final result = await context.read<AuthProvider>().login(
      _emailController.text,
      _passwordController.text,
    );

    if (result['success'] == true) {
      if (mounted) Navigator.pushReplacementNamed(context, '/');
    } else {
      setState(() => _error = result['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: Stack(
        children: [
          // Animated Background
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.authGradient,
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .shimmer(duration: 5.seconds, color: Colors.white10),

          // Particles
          ParticlesFly(
            height: size.height,
            width: size.width,
            connectDots: false,
            numberOfParticles: 40,
            lineColor: Colors.white.withOpacity(0.1),
            onTapAnimation: false,
            isRandomColor: false,
            maxParticleSize: 2,
          ),

          // Login Card
          Center(
            child: Container(
              width: 850,
              height: 500,
              constraints: const BoxConstraints(maxWidth: 0.9 * 1000), // Adjusted for web
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  )
                ],
              ),
              child: Row(
                children: [
                  // Left Side (Branding)
                  Expanded(
                    child: Container(
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
                          Image.asset(
                            'assets/images/logo.png',
                            height: 120,
                          ).animate().scale(delay: 200.ms, duration: 600.ms),
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'User Login',
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.p700,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Access your academic portal securely',
                            style: GoogleFonts.dmSans(
                              color: AppColors.g500,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 40),
                          
                          if (_error != null)
                            Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                color: AppColors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.red.withOpacity(0.2)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.error_outline, color: AppColors.red, size: 18),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      _error!,
                                      style: const TextStyle(color: AppColors.red, fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ).animate().shake(),

                          _buildTextField(
                            controller: _emailController,
                            hint: 'Username or Student ID',
                            icon: Icons.person_outline,
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            controller: _passwordController,
                            hint: 'Password',
                            icon: Icons.lock_outline,
                            isPassword: true,
                            obscure: _obscurePassword,
                            onToggleObscure: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          const SizedBox(height: 32),
                          
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: authProvider.isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.p600,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: authProvider.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                : Text(
                                    'Login',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                            ),
                          ),

                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account? ", style: TextStyle(color: AppColors.g500, fontSize: 13)),
                              TextButton(
                                onPressed: () => Navigator.pushReplacementNamed(context, '/register'),
                                child: const Text('Register here', style: TextStyle(color: AppColors.p600, fontWeight: FontWeight.bold)),
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
          ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.9, 0.9)),
        ],
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
        color: AppColors.g50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.g200),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: GoogleFonts.dmSans(fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.dmSans(color: AppColors.g400, fontWeight: FontWeight.w500),
          prefixIcon: Icon(icon, color: AppColors.g400, size: 20),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: AppColors.g400, size: 20),
                  onPressed: onToggleObscure,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}
