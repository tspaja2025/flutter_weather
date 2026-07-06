import 'dart:ui';
import 'package:flutter/material.dart';

class StormyTheme {
  StormyTheme._();

  //--------------------------------------------------------------------------
  // Colors
  //--------------------------------------------------------------------------

  static const Color background = Color(0xFF051426);

  static const Color surface = Color(0xFF051426);
  static const Color surfaceDim = Color(0xFF051426);
  static const Color surfaceBright = Color(0xFF2C3A4E);

  static const Color surfaceContainerLowest = Color(0xFF010F21);
  static const Color surfaceContainerLow = Color(0xFF0D1C2F);
  static const Color surfaceContainer = Color(0xFF122033);
  static const Color surfaceContainerHigh = Color(0xFF1C2B3E);
  static const Color surfaceContainerHighest = Color(0xFF273649);

  static const Color surfaceVariant = Color(0xFF273649);

  static const Color primary = Color(0xFF8ED5FF);
  static const Color primaryContainer = Color(0xFF38BDF8);

  static const Color secondary = Color(0xFFE2C62D);
  static const Color secondaryContainer = Color(0xFFC1A800);

  static const Color tertiary = Color(0xFFC5CCE6);

  static const Color outline = Color(0xFF87929A);
  static const Color outlineVariant = Color(0xFF3E484F);

  static const Color error = Color(0xFFFFB4AB);

  static const Color onBackground = Color(0xFFD5E3FD);
  static const Color onSurface = Color(0xFFD5E3FD);
  static const Color onSurfaceVariant = Color(0xFFBDC8D1);

  static const Color electricGlow = Color.fromRGBO(56, 189, 248, .15);

  //--------------------------------------------------------------------------
  // Color Scheme
  //--------------------------------------------------------------------------

  static const ColorScheme colorScheme = ColorScheme.dark(
    brightness: Brightness.dark,

    primary: primary,
    onPrimary: Color(0xFF00354A),
    primaryContainer: primaryContainer,
    onPrimaryContainer: Color(0xFF004965),

    secondary: secondary,
    onSecondary: Color(0xFF393000),
    secondaryContainer: secondaryContainer,
    onSecondaryContainer: Color(0xFF483D00),

    tertiary: tertiary,
    onTertiary: Color(0xFF283044),
    tertiaryContainer: Color(0xFFA9B1CA),
    onTertiaryContainer: Color(0xFF3C4459),

    error: error,
    onError: Color(0xFF690005),

    surface: surface,
    onSurface: onSurface,

    outline: outline,
    outlineVariant: outlineVariant,

    surfaceContainerLowest: surfaceContainerLowest,
    surfaceContainerLow: surfaceContainerLow,
    surfaceContainer: surfaceContainer,
    surfaceContainerHigh: surfaceContainerHigh,
    surfaceContainerHighest: surfaceContainerHighest,

    surfaceDim: surfaceDim,
    surfaceBright: surfaceBright,

    inverseSurface: Color(0xFFD5E3FD),
    onInverseSurface: Color(0xFF233144),

    inversePrimary: Color(0xFF00668A),
  );

  //--------------------------------------------------------------------------
  // Typography
  //--------------------------------------------------------------------------

  static TextTheme textTheme = const TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'Plus Jakarta Sans',
      fontSize: 48,
      fontWeight: FontWeight.w800,
      height: 56 / 48,
      letterSpacing: -.96,
    ),

    headlineLarge: TextStyle(
      fontFamily: 'Plus Jakarta Sans',
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 40 / 32,
      letterSpacing: -.32,
    ),

    titleMedium: TextStyle(
      fontFamily: 'Plus Jakarta Sans',
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 28 / 20,
    ),

    bodyLarge: TextStyle(
      fontFamily: 'Plus Jakarta Sans',
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 24 / 16,
    ),

    bodyMedium: TextStyle(
      fontFamily: 'Plus Jakarta Sans',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 20 / 14,
    ),

    labelMedium: TextStyle(
      fontFamily: 'Plus Jakarta Sans',
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 16 / 12,
      letterSpacing: 1,
    ),
  );

  //--------------------------------------------------------------------------
  // Theme
  //--------------------------------------------------------------------------

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      canvasColor: background,
      textTheme: textTheme,

      //----------------------------------------------------------------------
      // AppBar
      //----------------------------------------------------------------------
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: onSurface,
        centerTitle: false,
      ),

      //----------------------------------------------------------------------
      // Card
      //----------------------------------------------------------------------
      cardTheme: CardThemeData(
        color: surfaceContainer.withValues(alpha: .88),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: outlineVariant, width: 1),
        ),
      ),

      //----------------------------------------------------------------------
      // Buttons
      //----------------------------------------------------------------------
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: const Color(0xFF00354A),
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: onSurface,
          side: const BorderSide(color: outlineVariant),
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: onSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      //----------------------------------------------------------------------
      // Inputs
      //----------------------------------------------------------------------
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainerLowest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: outlineVariant),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: outlineVariant),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
      ),

      //----------------------------------------------------------------------
      // Chip
      //----------------------------------------------------------------------
      chipTheme: ChipThemeData(
        backgroundColor: surfaceContainerHigh,
        selectedColor: secondary,
        labelStyle: const TextStyle(
          color: onSurface,
          fontFamily: 'Plus Jakarta Sans',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),

      //----------------------------------------------------------------------
      // Divider
      //----------------------------------------------------------------------
      dividerTheme: const DividerThemeData(color: outlineVariant),

      //----------------------------------------------------------------------
      // Progress
      //----------------------------------------------------------------------
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primary,
        linearTrackColor: surfaceContainerHigh,
        circularTrackColor: surfaceContainerHigh,
      ),

      //----------------------------------------------------------------------
      // FAB
      //----------------------------------------------------------------------
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Color(0xFF00354A),
      ),

      //----------------------------------------------------------------------
      // Navigation Bar
      //----------------------------------------------------------------------
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceContainerLowest,
        indicatorColor: primary.withValues(alpha: .18),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontFamily: 'Plus Jakarta Sans'),
        ),
      ),
    );
  }
}

//----------------------------------------------------------------------
// Glass Morphism Helper
//----------------------------------------------------------------------
class StormGlass extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  const StormGlass({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: const Color(0xFF1C2B3E).withValues(alpha: .80),
            borderRadius: borderRadius,
            border: Border.all(color: const Color(0x33FFFFFF)),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(56, 189, 248, .15),
                blurRadius: 20,
                spreadRadius: 0,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

//--------------------------------------------------------------------------
// Stormy Spacing
//--------------------------------------------------------------------------
class StormSpacing {
  static const double unit = 8;

  static const double xs = unit;
  static const double sm = unit * 2;
  static const double md = unit * 3;
  static const double lg = unit * 4;
  static const double xl = unit * 6;
  static const double xxl = unit * 8;

  static const double mobileMargin = 16;
  static const double desktopMargin = 48;

  static const double gutter = 24;
  static const double maxWidth = 1280;
}

//--------------------------------------------------------------------------
// Stormy Radius
//--------------------------------------------------------------------------
class StormRadius {
  static const sm = Radius.circular(4);
  static const md = Radius.circular(8);
  static const lg = Radius.circular(12);
  static const xl = Radius.circular(16);
  static const xxl = Radius.circular(24);

  static const full = Radius.circular(999);
}
