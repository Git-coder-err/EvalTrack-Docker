import 'package:flutter/material.dart';

class AppColors {
  // Purple Edition Palette (Matching portal.css)
  static const Color p900 = Color(0xFF1a0838);
  static const Color p800 = Color(0xFF2d0d5e);
  static const Color p700 = Color(0xFF4a148c);
  static const Color p600 = Color(0xFF6a1b9a);
  static const Color p500 = Color(0xFF7c3aed);
  static const Color p400 = Color(0xFFa78bfa);
  static const Color p300 = Color(0xFFc4b5fd);
  static const Color p200 = Color(0xFFddd6fe);
  static const Color p100 = Color(0xFFede9fe);
  static const Color p50 = Color(0xFFf5f3ff);

  static const Color mag = Color(0xFFdb2777); // Magenta accent
  static const Color teal = Color(0xFF0d9488); // Teal accent
  static const Color amber = Color(0xFFd97706); // Amber accent
  static const Color red = Color(0xFFef4444); // Red accent

  // Neutral Colors
  static const Color g900 = Color(0xFF0f172a);
  static const Color g800 = Color(0xFF1e293b);
  static const Color g700 = Color(0xFF334155);
  static const Color g600 = Color(0xFF475569);
  static const Color g500 = Color(0xFF64748b);
  static const Color g400 = Color(0xFF94a3b8);
  static const Color g300 = Color(0xFFcbd5e1);
  static const Color g200 = Color(0xFFe2e8f0);
  static const Color g100 = Color(0xFFf1f5f9);
  static const Color g50 = Color(0xFFf8fafc);

  // Gradients
  static const LinearGradient purpleGradient = LinearGradient(
    colors: [p700, p500],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient authGradient = LinearGradient(
    colors: [p900, p700, p600, p800],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
