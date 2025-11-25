import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'theme_notifier.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Enable edge-to-edge but with colored system bars
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  
  runApp(const VPNApp());
}

class VPNApp extends StatelessWidget {
  const VPNApp({super.key});

  // Light Theme Colors - Soft & Clean
  static const Color lightPrimaryPurple = Color(0xFF7E57C2);
  static const Color lightSecondaryPurple = Color(0xFFB39DDB);
  static const Color lightBackground = Color(0xFFFAFAFC); // Very subtle gray-white
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCardColor = Color(0xFFFFFFFF);

  // Dark Theme Colors - Deep Purple & Dark
  static const Color darkPrimaryPurple = Color(0xFFB388FF);
  static const Color darkSecondaryPurple = Color(0xFF7C4DFF);
  static const Color darkBackground = Color(0xFF1A1625);
  static const Color darkSurface = Color(0xFF2D2640);
  static const Color darkCardColor = Color(0xFF352F44);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, themeMode, child) {
        return MaterialApp(
          title: 'VPN App',
          debugShowCheckedModeBanner: false,
          themeMode: themeMode,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.light(
              primary: lightPrimaryPurple,
              secondary: lightSecondaryPurple,
              surface: lightSurface,
              onPrimary: Colors.white,
              onSecondary: Colors.white,
              onSurface: const Color(0xFF2D2D2D),
            ),
            scaffoldBackgroundColor: lightBackground,
            cardColor: lightCardColor,
            dividerColor: Colors.grey.shade200,
            appBarTheme: AppBarTheme(
              backgroundColor: lightBackground,
              elevation: 0,
              centerTitle: true,
              titleTextStyle: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              iconTheme: IconThemeData(color: Colors.grey.shade800),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: lightPrimaryPurple,
                foregroundColor: Colors.white,
              ),
            ),
            switchTheme: SwitchThemeData(
              thumbColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return lightPrimaryPurple;
                }
                return Colors.grey.shade400;
              }),
              trackColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return lightSecondaryPurple.withOpacity(0.5);
                }
                return Colors.grey.shade300;
              }),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.dark(
              primary: darkPrimaryPurple,
              secondary: darkSecondaryPurple,
              surface: darkSurface,
              onPrimary: Colors.white,
              onSecondary: Colors.white,
              onSurface: const Color(0xFFE8E8E8),
            ),
            scaffoldBackgroundColor: darkBackground,
            cardColor: darkCardColor,
            dividerColor: Colors.purple.shade900,
            appBarTheme: AppBarTheme(
              backgroundColor: darkBackground,
              elevation: 0,
              centerTitle: true,
              titleTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: darkPrimaryPurple,
                foregroundColor: Colors.white,
              ),
            ),
            switchTheme: SwitchThemeData(
              thumbColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return darkPrimaryPurple;
                }
                return Colors.grey.shade600;
              }),
              trackColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return darkSecondaryPurple.withOpacity(0.5);
                }
                return Colors.grey.shade800;
              }),
            ),
          ),
          // Use builder to wrap all screens with the correct SystemUiOverlayStyle
          builder: (context, child) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(
                // Status Bar - match background color
                statusBarColor: isDark ? darkBackground : lightBackground,
                statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
                statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
                
                // Navigation Bar - match background color
                systemNavigationBarColor: isDark ? darkBackground : lightBackground,
                systemNavigationBarDividerColor: isDark ? darkBackground : lightBackground,
                systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
              ),
              child: child!,
            );
          },
          home: const SplashScreen(),
        );
      },
    );
  }
}
