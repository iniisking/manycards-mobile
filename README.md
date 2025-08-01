# Multi-Currency Digital Wallet

A modern, feature-rich Flutter application that provides users with a comprehensive digital wallet experience supporting multiple currencies (NGN, USD, GBP). this app allows users to create virtual cards, manage subcards, perform transactions, and handle payments through Paystack integration.

## 📱 Features

### Core Functionality
- **Multi-Currency Support**: Create and manage cards in NGN, USD, and GBP
- **Virtual Card Management**: Generate and manage virtual cards for each currency
- **Subcard System**: Create and manage subcards for controlled spending
- **Transaction History**: Complete transaction tracking and history
- **Real-time Balance**: Live balance updates across all currencies
- **Currency Conversion**: Built-in currency conversion capabilities

### Payment & Security
- **Paystack Integration**: Secure payment processing for funding accounts
- **JWT Authentication**: Secure token-based authentication
- **Biometric Security**: Optional biometric authentication
- **Secure Storage**: Encrypted local storage for sensitive data

### User Experience
- **Modern UI/UX**: Clean, intuitive interface with dark theme
- **Responsive Design**: Optimized for various screen sizes
- **Pull-to-Refresh**: Smooth data refresh functionality
- **Loading States**: Comprehensive loading indicators and shimmer effects
- **Error Handling**: Robust error handling and user feedback

## 🏗️ Architecture

### Project Structure
```
lib/
├── config/                 # API endpoints and configuration
├── controller/            # State management controllers
├── model/                # Data models and DTOs
│   ├── auth/            # Authentication models
│   ├── cards/           # Card-related models
│   ├── currency/        # Currency conversion models
│   ├── payment/         # Payment processing models
│   ├── subcards/        # Subcard management models
│   └── transaction/     # Transaction history models
├── services/            # API services and business logic
├── utils/              # Utility functions and helpers
├── view/               # UI components and screens
│   ├── actions/        # Action screens (top-up, transfer)
│   ├── authentication/ # Auth screens (login, signup)
│   ├── bottom nav bar/ # Navigation components
│   ├── cards/          # Card management screens
│   ├── constants/      # UI constants and widgets
│   ├── home/           # Home screen components
│   ├── settings/       # Settings and profile screens
│   └── transaction/    # Transaction history screens
└── main.dart           # Application entry point
```

### State Management
- **Provider Pattern**: Uses Provider for state management
- **Controllers**: Dedicated controllers for each feature area
- **Service Layer**: Clean separation between UI and business logic

### Key Controllers
- `AuthController`: Handles authentication and user state
- `CardController`: Manages virtual cards and card operations
- `CurrencyController`: Handles currency conversion and balance display
- `PaymentController`: Manages payment processing and Paystack integration
- `TransactionController`: Handles transaction history and data
- `SubcardController`: Manages subcard creation and operations

## 🚀 Getting Started

### Prerequisites

Before running this project, ensure you have the following installed:

1. **Flutter SDK** (version 3.7.0 or higher)
   ```bash
   # Check Flutter version
   flutter --version
   ```

2. **Dart SDK** (included with Flutter)
   ```bash
   # Check Dart version
   dart --version
   ```

3. **Android Studio** or **VS Code** with Flutter extensions
4. **Git** for version control
5. **Android SDK** (for Android development)
6. **Xcode** (for iOS development, macOS only)

### Installation Steps

#### 1. Clone the Repository
```bash
git clone <repository-url>
cd manycards
```

#### 2. Install Dependencies
```bash
flutter pub get
```

#### 3. Generate Asset References
```bash
# Generate asset references for images, fonts, and SVG files
flutter pub run build_runner build --delete-conflicting-outputs
```

#### 4. Configure Environment Variables

**Important**: This project uses environment variables for configuration. You need to set up the `.env` file before running the application.

1. **Copy the example file:**
   ```bash
   cp .env.example .env
   ```

2. **Edit the `.env` file** with your actual values:
   ```env
   # API Base URLs
   API_BASE_URL=https://your-api-base-url.com
   AUTH_SIGNUP_URL=https://your-auth-signup-url.com
   AUTH_CONFIRM_SIGNUP_URL=https://your-auth-confirm-url.com
   AUTH_LOGIN_URL=https://your-auth-login-url.com
   AUTH_FORGOT_PASSWORD_URL=https://your-auth-forgot-password-url.com
   AUTH_CONFIRM_FORGOT_PASSWORD_URL=https://your-auth-confirm-forgot-password-url.com
   
   # AWS Configuration
   AWS_REGION=us-east-1
   AWS_SERVICE=execute-api
   AWS_ACCESS_KEY_ID=your_aws_access_key
   AWS_SECRET_ACCESS_KEY=your_aws_secret_key
   
   # Storage Keys
   STORAGE_AUTH_TOKEN_KEY=auth_token
   STORAGE_NGN_CARD_ID_KEY=ngn_card_id
   
   # App Configuration
   APP_NAME=ManyCards
   APP_VERSION=1.0.0
   DEBUG_MODE=true
   
   # API Timeout (in seconds)
   API_TIMEOUT_SECONDS=15
   
   # User Agent
   USER_AGENT=ManyCards/1.0
   ```

**Security Note**: Never commit your actual `.env` file to version control. The `.env.example` file is provided as a template.

#### 5. Platform-Specific Setup

##### Android Setup
1. Open `android/app/build.gradle.kts`
2. Update `applicationId` if needed
3. Ensure `minSdkVersion` is set to 21 or higher
4. Add any required permissions in `android/app/src/main/AndroidManifest.xml`

##### iOS Setup (macOS only)
1. Navigate to the iOS folder: `cd ios`
2. Install CocoaPods dependencies: `pod install`
3. Open `ios/Runner.xcworkspace` in Xcode
4. Configure signing and capabilities as needed

#### 6. Run the Application

##### Development Mode
```bash
# Run in debug mode
flutter run

# Run on specific device
flutter run -d <device-id>

# Run with hot reload
flutter run --hot
```

##### Production Build
```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS (requires macOS and Xcode)
flutter build ios --release
```

## 🔧 Development

### Code Generation
The project uses code generation for assets and other boilerplate code:

```bash
# Generate assets, fonts, and localization
dart run build_runner build --delete-conflicting-outputs

# Watch for changes and auto-generate
flutter pub run build_runner watch
```

### Asset Management
- **Images**: Place in `assets/images/`
- **SVG Files**: Place in `assets/svg/`
- **Fonts**: Place in `assets/fonts/`

After adding new assets, run the build runner to generate references.

### State Management Best Practices
1. **Controllers**: Extend `ChangeNotifier` for state management
2. **Services**: Handle API calls and business logic
3. **Models**: Define data structures and serialization
4. **Views**: Use `Provider.of<T>(context)` or `context.read<T>()` to access state

### Error Handling
- All API calls are wrapped in try-catch blocks
- User-friendly error messages are displayed
- Loading states are properly managed
- Network errors are handled gracefully

## 🧪 Testing

### Running Tests
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

### Test Structure
- `test/`: Contains all test files
- `test/widget_test.dart`: Main widget test file
- Create additional test files for specific features

## 📦 Dependencies

### Core Dependencies
- **flutter_screenutil**: Responsive UI scaling
- **provider**: State management
- **http**: HTTP client for API calls
- **shared_preferences**: Local data storage
- **flutter_secure_storage**: Secure storage for sensitive data
- **webview_flutter**: WebView for payment processing
- **liquid_pull_to_refresh**: Pull-to-refresh functionality
- **shimmer**: Loading state animations

### Development Dependencies
- **build_runner**: Code generation
- **flutter_gen_runner**: Asset generation
- **flutter_lints**: Code linting

## 🔐 Security Features

### Authentication
- JWT token-based authentication
- Secure token storage using `flutter_secure_storage`
- Automatic token refresh (when implemented)
- Biometric authentication support

### Data Protection
- Encrypted local storage for sensitive data
- Secure API communication with HTTPS
- Input validation and sanitization
- Error handling without exposing sensitive information

## 🌐 API Integration

### Backend Requirements
The application expects a RESTful API with the following endpoints:

#### Authentication
- `POST /auth/signup` - User registration
- `POST /auth/login` - User login
- `POST /auth/logout` - User logout
- `POST /auth/forgot-password` - Password reset
- `POST /auth/confirm-forgot-password` - Confirm password reset

#### Cards
- `GET /cards` - Get user cards
- `POST /cards/generate` - Generate new cards
- `GET /cards/{id}` - Get specific card details

#### Payments
- `POST /payments/fund-account` - Fund account
- `POST /payments/paystack-webhook` - Paystack webhook verification

#### Transactions
- `GET /transactions` - Get transaction history

#### Subcards
- `GET /subcards` - Get user subcards
- `POST /subcards` - Create subcard
- `DELETE /subcards/{id}` - Delete subcard

## 🚨 Troubleshooting

### Common Issues

#### 1. Environment Variables Issues
```bash
# Check if .env file exists
ls -la .env

# If .env doesn't exist, copy from example
cp .env.example .env

# Verify environment variables are loaded
flutter run --verbose
```

**Common Environment Issues:**
- **Missing .env file**: Copy from `.env.example`
- **Invalid API URLs**: Check your API endpoints in `.env`
- **AWS credentials**: Ensure AWS keys are correct
- **Debug mode**: Set `DEBUG_MODE=false` for production

#### 2. Build Runner Issues
```bash
# Clean and regenerate
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

#### 3. Dependency Issues
```bash
# Update dependencies
flutter pub upgrade
flutter pub get
```

#### 4. Platform-Specific Issues

##### Android
- **Gradle Issues**: Clean and rebuild
  ```bash
  cd android
  ./gradlew clean
  cd ..
  flutter clean
  flutter pub get
  ```

- **Permission Issues**: Check `android/app/src/main/AndroidManifest.xml`

##### iOS
- **Pod Issues**: Update CocoaPods
  ```bash
  cd ios
  pod install --repo-update
  ```

- **Signing Issues**: Configure signing in Xcode

#### 5. Network Issues
- Check API endpoint configuration in `.env` file
- Verify network connectivity
- Check firewall settings

#### 6. Asset Issues
```bash
# Regenerate assets
flutter pub run build_runner build --delete-conflicting-outputs
```

### Debug Mode
```bash
# Run with verbose logging
flutter run --verbose

# Check Flutter doctor
flutter doctor -v
```

## 📱 Platform Support

### Android
- **Minimum SDK**: 21 (Android 5.0)
- **Target SDK**: Latest stable
- **Architecture**: ARM64, ARMv7, x86_64

### iOS
- **Minimum Version**: iOS 12.0
- **Target Version**: Latest stable
- **Architecture**: ARM64

### Web (Experimental)
- Basic web support available
- Some features may be limited

## 🤝 Contributing

### Development Workflow
1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Make your changes
4. Run tests: `flutter test`
5. Commit your changes: `git commit -m 'Add feature'`
6. Push to the branch: `git push origin feature/your-feature`
7. Create a Pull Request

### Code Style
- Follow Flutter/Dart conventions
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused
- Use proper error handling

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the troubleshooting section above

## 🔄 Version History

### v1.0.0
- Initial release
- Multi-currency support
- Virtual card management
- Paystack integration
- Transaction history
- Subcard system

---

**Note**: This is a comprehensive documentation for the ManyCards application. For specific implementation details, refer to the inline comments in the source code.