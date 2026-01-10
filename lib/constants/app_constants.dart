import 'package:flutter/material.dart';

// 🎨 Modern Color Palette
const Color primaryColor = Color(0xFF1976D2); // Safety Blue
const Color primaryBlue = Color(0xFF1976D2); // Alias for primaryColor
const Color secondaryColor = Color(0xFF0D47A1);
const Color accentColor = Color(0xFF42A5F5);
const Color backgroundColor = Color(0xFFF5F5F5);
const Color surfaceColor = Color(0xFFFFFFFF);
const Color errorColor = Color(0xFFD32F2F); // Red for danger
const Color warningColor = Color(0xFFFFC107); // Yellow for caution
const Color successColor = Color(0xFF4CAF50);
const Color textPrimary = Color(0xFF212121);
const Color textSecondary = Color(0xFF757575);

// Text Styles
final TextStyle kHeadline1 = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.bold,
  color: textPrimary,
  letterSpacing: -0.5,
);

final TextStyle kHeadline2 = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w600,
  color: textPrimary,
);

final TextStyle kBodyText1 = TextStyle(
  fontSize: 16,
  color: textPrimary,
  height: 1.5,
);

final TextStyle kBodyText2 = TextStyle(
  fontSize: 14,
  color: textSecondary,
  height: 1.5,
);

// Custom Card Decoration
final BoxDecoration kCardDecoration = BoxDecoration(
  color: surfaceColor,
  borderRadius: BorderRadius.circular(16),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ],
);
