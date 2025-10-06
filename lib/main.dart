import "package:flutter/material.dart";
import "package:firebase_core/firebase_core.dart";
import "package:provider/provider.dart";
import "dart:developer" as developer;
import "firebase_options.dart";
import "services/auth_service.dart";
import "screens/phone_input_screen.dart";
import "screens/otp_verification_screen.dart";
import "screens/home_screen.dart";
import "screens/debug_screen.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Suppress verbose Android system logs
  developer.log("Starting SMS OTP App", name: "SMS_OTP");
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const SMSOTPApp());
}

/// Main application widget for SMS OTP authentication
class SMSOTPApp extends StatelessWidget {
  const SMSOTPApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: "SMS OTP Authentication",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
            ),
          ),
        ),
        initialRoute: "/",
        routes: {
          "/": (context) => const AuthWrapper(),
          "/phone-input": (context) => const PhoneInputScreen(),
          "/otp-verification": (context) => const OTPVerificationScreen(),
          "/home": (context) => const HomeScreen(),
          "/debug": (context) => const DebugScreen(),
        },
      ),
    );
  }
}

/// Wrapper widget to handle authentication state
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        // Show loading screen while checking auth state
        if (authService.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Navigate based on authentication state
        if (authService.isAuthenticated) {
          return const HomeScreen();
        } else {
          return const PhoneInputScreen();
        }
      },
    );
  }
}
