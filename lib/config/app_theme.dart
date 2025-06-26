import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Couleurs principales
  static const Color primaryBlue = Color(0xFF667eea);
  static const Color primaryPurple = Color(0xFF764ba2);
  static const Color accentOrange = Color(0xFFffa500);
  static const Color accentRed = Color(0xFFff6b6b);

  // Couleurs pour le mode sombre
  static const Color darkBackground = Color(0xFF1a1a1a);
  static const Color darkSurface = Color(0xFF2d2d2d);

  // Thème clair
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'System',
      useMaterial3: true,

      // ColorScheme pour Material 3
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: accentOrange,
        surface: Colors.white,
        background: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black87,
        onBackground: Colors.black87,
      ),

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      // Boutons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        ),
      ),

      // Cartes
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.all(8),
      ),

      // Texte - CORRIGÉ pour le mode clair
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.black87, // ← Noir pour le mode clair
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black87, // ← Noir pour le mode clair
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.black87, // ← Noir pour le mode clair
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Colors.black54, // ← Gris pour le mode clair
        ),
      ),
    );
  }

  // Thème sombre
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      fontFamily: 'System',
      useMaterial3: true,

      // ColorScheme pour Material 3 - Mode sombre
      colorScheme: const ColorScheme.dark(
        primary: primaryBlue,
        secondary: accentOrange,
        surface: darkSurface,
        background: darkBackground,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onBackground: Colors.white,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),

      cardTheme: CardTheme(
        color: darkSurface,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),

      // Texte - CORRIGÉ pour le mode sombre
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white, // ← Blanc pour le mode sombre
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white, // ← Blanc pour le mode sombre
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.white, // ← Blanc pour le mode sombre
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Colors.white70, // ← Gris clair pour le mode sombre
        ),
      ),
    );
  }

  // Dégradés adaptatifs
  static LinearGradient primaryGradient(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isDark) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF2d2d2d), Color(0xFF1a1a1a)],
      );
    } else {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [primaryBlue, primaryPurple],
      );
    }
  }

  static LinearGradient buttonGradient(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isDark) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFff4757), Color(0xFFffa726)],
      );
    } else {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [accentRed, accentOrange],
      );
    }
  }

  // Dégradés météo adaptatifs
  static LinearGradient weatherGradient(BuildContext context, String weatherIcon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (weatherIcon.contains('01')) {
      // Ciel dégagé
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [const Color(0xFF2c3e50), const Color(0xFF3498db)]
            : [const Color(0xFF87CEEB), const Color(0xFF4682B4)],
      );
    } else if (weatherIcon.contains('02') || weatherIcon.contains('03')) {
      // Nuageux
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [const Color(0xFF34495e), const Color(0xFF2c3e50)]
            : [const Color(0xFF708090), const Color(0xFF2F4F4F)],
      );
    } else if (weatherIcon.contains('09') || weatherIcon.contains('10')) {
      // Pluvieux
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [const Color(0xFF2c3e50), const Color(0xFF1a252f)]
            : [const Color(0xFF4682B4), const Color(0xFF191970)],
      );
    } else if (weatherIcon.contains('11')) {
      // Orageux
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [const Color(0xFF1a252f), const Color(0xFF000000)]
            : [const Color(0xFF2F4F4F), const Color(0xFF000000)],
      );
    } else if (weatherIcon.contains('13')) {
      // Neigeux
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [const Color(0xFF5f6c7b), const Color(0xFF2c3e50)]
            : [const Color(0xFFB0C4DE), const Color(0xFF4682B4)],
      );
    } else {
      // Par défaut
      return primaryGradient(context);
    }
  }
}