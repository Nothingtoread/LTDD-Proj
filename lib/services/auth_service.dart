import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/foundation.dart";

/// Authentication service for handling Firebase Auth and SMS OTP
class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  String? _verificationId;
  bool _isLoading = false;
  String? _errorMessage;

  /// Current authenticated user
  User? get user => _user;

  /// Current verification ID for SMS OTP
  String? get verificationId => _verificationId;

  /// Loading state
  bool get isLoading => _isLoading;

  /// Error message
  String? get errorMessage => _errorMessage;

  /// Constructor
  AuthService() {
    _init();
  }

  /// Initialize the auth service
  void _init() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message
  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Send SMS OTP to phone number
  /// 
  /// [phoneNumber] - The phone number in international format (e.g., +1234567890)
  /// Returns true if SMS was sent successfully, false otherwise
  Future<bool> sendOTP(String phoneNumber) async {
    try {
      _setLoading(true);
      _setError(null);

      // Verify phone number format
      if (!phoneNumber.startsWith("+")) {
        _setError("Phone number must include country code (e.g., +1234567890)");
        return false;
      }

      // Request SMS verification
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          // Auto-verification completed
          _signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          _setError("Verification failed: ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _setLoading(false);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
        timeout: const Duration(seconds: 60),
      );

      return true;
    } catch (e) {
      _setError("Failed to send OTP: ${e.toString()}");
      _setLoading(false);
      return false;
    }
  }

  /// Verify SMS OTP code
  /// 
  /// [smsCode] - The 6-digit SMS code received
  /// Returns true if verification was successful, false otherwise
  Future<bool> verifyOTP(String smsCode) async {
    try {
      _setLoading(true);
      _setError(null);

      if (_verificationId == null) {
        _setError("No verification ID found. Please request OTP first.");
        return false;
      }

      // Create credential with verification ID and SMS code
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );

      // Sign in with credential
      await _signInWithCredential(credential);
      return true;
    } catch (e) {
      _setError("Failed to verify OTP: ${e.toString()}");
      _setLoading(false);
      return false;
    }
  }

  /// Sign in with phone auth credential
  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      final userCredential = await _auth.signInWithCredential(credential);
      _user = userCredential.user;
      _setLoading(false);
    } catch (e) {
      _setError("Authentication failed: ${e.toString()}");
      _setLoading(false);
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _user = null;
      _verificationId = null;
      _setError(null);
    } catch (e) {
      _setError("Failed to sign out: ${e.toString()}");
    }
  }

  /// Get current user's phone number
  String? get phoneNumber => _user?.phoneNumber;

  /// Check if user is authenticated
  bool get isAuthenticated => _user != null;
}
