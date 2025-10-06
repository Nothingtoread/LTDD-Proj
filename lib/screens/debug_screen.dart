import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../services/auth_service.dart";

/// Debug screen to test SMS OTP functionality
class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  String _status = "Ready to test SMS OTP";
  String _verificationId = "";

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  /// Test sending SMS OTP
  Future<void> _testSendOTP() async {
    setState(() {
      _status = "Sending OTP...";
    });

    final authService = Provider.of<AuthService>(context, listen: false);
    final phoneNumber = _phoneController.text.trim();

    if (phoneNumber.isEmpty) {
      setState(() {
        _status = "Please enter a phone number";
      });
      return;
    }

    try {
      final success = await authService.sendOTP(phoneNumber);
      
      if (success) {
        setState(() {
          _status = "OTP sent successfully! Check your phone for SMS.";
          _verificationId = authService.verificationId ?? "No verification ID";
        });
      } else {
        setState(() {
          _status = "Failed to send OTP: ${authService.errorMessage ?? 'Unknown error'}";
        });
      }
    } catch (e) {
      setState(() {
        _status = "Error: $e";
      });
    }
  }

  /// Test verifying OTP
  Future<void> _testVerifyOTP() async {
    setState(() {
      _status = "Verifying OTP...";
    });

    final authService = Provider.of<AuthService>(context, listen: false);
    final otpCode = _otpController.text.trim();

    if (otpCode.isEmpty) {
      setState(() {
        _status = "Please enter the OTP code";
      });
      return;
    }

    try {
      final success = await authService.verifyOTP(otpCode);
      
      if (success) {
        setState(() {
          _status = "OTP verified successfully! User authenticated.";
        });
      } else {
        setState(() {
          _status = "Failed to verify OTP: ${authService.errorMessage ?? 'Unknown error'}";
        });
      }
    } catch (e) {
      setState(() {
        _status = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SMS OTP Debug"),
        backgroundColor: Colors.orange[600],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status display
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Status:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(_status),
                  if (_verificationId.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      "Verification ID: $_verificationId",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Phone number input
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Phone Number (with country code)",
                hintText: "+1234567890",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Send OTP button
            ElevatedButton(
              onPressed: _testSendOTP,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text("Send OTP"),
            ),
            
            const SizedBox(height: 24),
            
            // OTP input
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "OTP Code",
                hintText: "123456",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.sms),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Verify OTP button
            ElevatedButton(
              onPressed: _testVerifyOTP,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text("Verify OTP"),
            ),
            
            const SizedBox(height: 24),
            
            // Instructions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Instructions:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text("1. Enter your phone number with country code (e.g., +1234567890)"),
                  Text("2. Tap 'Send OTP' to request SMS verification"),
                  Text("3. Check your phone for the SMS with 6-digit code"),
                  Text("4. Enter the code and tap 'Verify OTP'"),
                  SizedBox(height: 8),
                  Text(
                    "Note: For testing, you can use Firebase test phone numbers in the Firebase Console.",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            
            const Spacer(),
            
            // Back to main app button
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Back to Main App"),
            ),
          ],
        ),
      ),
    );
  }
}
