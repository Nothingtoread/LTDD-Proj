# SMS OTP Authentication App

A Flutter application that demonstrates SMS OTP (One-Time Password) authentication using Firebase Authentication.

## Features

- 📱 Phone number input with international format validation
- 🔐 SMS OTP verification with 6-digit code input
- 🎨 Modern, responsive UI design
- 🔄 Real-time authentication state management
- 📊 User information display
- 🚪 Sign out functionality

## Prerequisites

Before running this application, make sure you have:

1. **Flutter SDK** installed (version 3.9.2 or higher)
2. **Firebase project** set up with Authentication enabled
3. **Phone Authentication** enabled in Firebase Console
4. **Firebase CLI** installed globally
5. **FlutterFire CLI** installed globally

## Setup Instructions

### 1. Firebase Configuration

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or use an existing one
3. Enable Authentication:
   - Go to Authentication > Sign-in method
   - Enable "Phone" provider
   - Configure your app's SHA-1 fingerprint (for Android)

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure FlutterFire

```bash
# Install Firebase CLI (if not already installed)
npm install -g firebase-tools

# Install FlutterFire CLI (if not already installed)
dart pub global activate flutterfire_cli

# Configure Firebase for your Flutter project
flutterfire configure --project=your-project-id
```

### 4. Run the Application

```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # Main application entry point
├── firebase_options.dart     # Firebase configuration (auto-generated)
├── services/
│   └── auth_service.dart     # Authentication service
└── screens/
    ├── phone_input_screen.dart      # Phone number input screen
    ├── otp_verification_screen.dart # OTP verification screen
    └── home_screen.dart             # Home screen for authenticated users
```

## Usage

### 1. Phone Number Input

- Enter your phone number in international format (e.g., +1234567890)
- The app will validate the format before sending SMS

### 2. OTP Verification

- Enter the 6-digit code received via SMS
- The app supports auto-focus between input fields
- Resend functionality available if needed

### 3. Home Screen

- View authenticated user information
- Access user settings and sign out

## Dependencies

- `firebase_core`: Firebase core functionality
- `firebase_auth`: Firebase Authentication
- `provider`: State management
- `intl`: Internationalization utilities

## Platform Support

- ✅ Android
- ✅ iOS
- ✅ Web (with reCAPTCHA configuration)
- ✅ Windows
- ✅ macOS
- ✅ Linux

## Troubleshooting

### Common Issues

1. **Firebase CLI not found**

   - Add npm global directory to your PATH
   - Or use full path: `C:\Users\[USER]\AppData\Roaming\npm\firebase.cmd`

2. **reCAPTCHA issues on web**

   - This is expected for Firebase Auth on web
   - Configure reCAPTCHA in Firebase Console for production

3. **Phone number validation**
   - Ensure phone numbers include country code (e.g., +1234567890)
   - Check Firebase Console for phone number format requirements

### Testing

For testing purposes, you can use:

- Test phone numbers provided by Firebase (Android/iOS)
- reCAPTCHA test mode (Web)

## Security Notes

- Phone numbers are validated on both client and server side
- OTP codes are time-limited and single-use
- User sessions are managed securely through Firebase Auth
- No sensitive data is stored locally

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
