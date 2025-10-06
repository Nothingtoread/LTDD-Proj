# SMS OTP App - API Reference

## Quick Function Reference

### Authentication Service (`AuthService`)

#### Properties
```dart
User? get user                    // Current authenticated user
bool get isAuthenticated         // Authentication status
bool get isLoading              // Loading state
```

#### Methods
```dart
// Send OTP to phone number
Future<void> sendOtp(String phoneNumber, BuildContext context)

// Verify OTP code
Future<void> verifyOtp(String otp, BuildContext context)

// Sign out current user
Future<void> signOut(BuildContext context)
```

### Screen Components

#### Phone Input Screen
```dart
// Validation function
String? _validatePhoneNumber(String? value)

// Form submission
void _onSubmit() // Triggers when "Send OTP" is pressed
```

#### OTP Verification Screen
```dart
// Handle OTP input changes
void _onOtpChanged(String value, int index)

// Validate complete OTP
void _validateOtp()

// Submit OTP for verification
void _onVerifyOtp() // Triggers when "Verify OTP" is pressed
```

#### Home Screen
```dart
// Display user information
Widget _buildUserInfo()

// Handle sign out
void _onSignOut() // Triggers when "Sign Out" is pressed
```

#### Debug Screen
```dart
// Send test OTP
void _onSendTestOtp()

// Verify test OTP
void _onVerifyTestOtp()

// Update debug message
void _updateDebugMessage(String message)
```

---

## Import Statements

### Core Flutter
```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer' as developer;
```

### Firebase
```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
```

### State Management
```dart
import 'package:provider/provider.dart';
```

### Project Files
```dart
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'screens/phone_input_screen.dart';
import 'screens/otp_verification_screen.dart';
import 'screens/home_screen.dart';
import 'screens/debug_screen.dart';
import 'utils/log_filter.dart';
```

---

## Firebase Methods Used

### FirebaseAuth Instance
```dart
FirebaseAuth.instance
```

### Phone Authentication
```dart
_auth.verifyPhoneNumber(
  phoneNumber: phoneNumber,
  verificationCompleted: (PhoneAuthCredential credential) async { ... },
  verificationFailed: (FirebaseAuthException e) { ... },
  codeSent: (String verificationId, int? resendToken) { ... },
  codeAutoRetrievalTimeout: (String verificationId) { ... },
  timeout: const Duration(seconds: 60),
  forceResendingToken: _resendToken,
)
```

### Credential Creation
```dart
PhoneAuthProvider.credential(
  verificationId: _verificationId!,
  smsCode: otp,
)
```

### User Authentication
```dart
await _auth.signInWithCredential(credential);
await _auth.signOut();
```

### Auth State Listening
```dart
_auth.authStateChanges().listen((User? user) { ... });
```

---

## Widget Types Used

### Input Widgets
```dart
TextFormField()           // Phone number input
TextFormField()           // OTP input fields (6 instances)
TextField()               // Debug screen inputs
```

### Button Widgets
```dart
ElevatedButton()          // Primary actions
TextButton()              // Secondary actions
IconButton()              // App bar actions
```

### Layout Widgets
```dart
Scaffold()                // Main screen structure
AppBar()                  // Top navigation
Column()                  // Vertical layout
Row()                     // Horizontal layout
Padding()                 // Spacing
SizedBox()                // Fixed size spacing
Spacer()                  // Flexible spacing
```

### Display Widgets
```dart
Text()                    // Text display
CircularProgressIndicator() // Loading indicator
SnackBar()                // Error/success messages
```

---

## Navigation Methods

### Route Navigation
```dart
Navigator.of(context).pushNamed('/route-name')
Navigator.of(context).pushNamedAndRemoveUntil('/route', (route) => false)
```

### Route Definition
```dart
routes: {
  '/': (context) => const AuthWrapper(),
  '/phone-input': (context) => const PhoneInputScreen(),
  '/otp-verification': (context) => const OTPVerificationScreen(),
  '/home': (context) => const HomeScreen(),
  '/debug': (context) => const DebugScreen(),
}
```

---

## Input Formatters

### Phone Number Input
```dart
keyboardType: TextInputType.phone
```

### OTP Input
```dart
keyboardType: TextInputType.number
inputFormatters: [
  FilteringTextInputFormatter.digitsOnly,
  LengthLimitingTextInputFormatter(1),
]
```

---

## State Management

### Provider Setup
```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthService()),
  ],
  child: SMSOTPApp(),
)
```

### State Access
```dart
final authService = Provider.of<AuthService>(context);
```

### State Updates
```dart
notifyListeners(); // Triggers UI rebuild
```

---

## Error Handling

### SnackBar Display
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Error message')),
);
```

### Try-Catch Blocks
```dart
try {
  // Firebase operation
} catch (e) {
  // Error handling
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error: $e')),
  );
}
```

---

## Theme Configuration

### Color Scheme
```dart
colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)
```

### App Bar Theme
```dart
appBarTheme: AppBarTheme(
  centerTitle: true,
  backgroundColor: Colors.deepPurple,
  foregroundColor: Colors.white,
)
```

---

## Platform-Specific Code

### Android Permissions
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.READ_SMS" />
<uses-permission android:name="android.permission.RECEIVE_SMS" />
<uses-permission android:name="android.permission.READ_PHONE_STATE" />
```

### Console Filtering (Windows)
```batch
flutter run -d device --verbose 2>&1 | findstr /V "IMGMapper"
```

---

## Testing Functions

### Widget Tests
```dart
testWidgets("Test description", (WidgetTester tester) async {
  // Test implementation
});
```

### Test Assertions
```dart
expect(find.text("Expected Text"), findsOneWidget);
expect(find.byType(TextFormField), findsNWidgets(6));
```

---

## Utility Functions

### Log Filtering
```dart
LogFilter.initialize();
LogFilter.shouldFilter(String message);
```

### Phone Validation
```dart
String? validatePhoneNumber(String? value) {
  if (value == null || value.isEmpty) return 'Please enter your phone number';
  if (!value.startsWith('+')) return 'Phone number must include country code';
  if (value.length < 10) return 'Please enter a valid phone number';
  return null;
}
```

---

*This API reference provides quick access to all functions, imports, and methods used in the SMS OTP Authentication Flutter App.*
