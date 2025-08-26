<!-- PROJECT TITLE & BADGES -->

# ManyCards – Multi‑Currency Digital Wallet (Flutter)

Modern multi-currency wallet for NGN, USD, and GBP. Create virtual cards, manage subcards, fund via Paystack, track transactions, and convert currency with a clean, responsive UI.

## Demo

![Voice to note flow](docs/intro.gif)

![Voice to note flow](docs/transfer.gif)

![Voice to note flow](docs/card.gif)

![Voice to note flow](docs/subcard.gif)

## Overview

ManyCards is a production-ready Flutter app that brings a seamless digital wallet experience:

- Multi-currency virtual cards (NGN, USD, GBP)
- Subcards for controlled spending
- Real-time balances and currency conversion
- Secure funding via Paystack
- Comprehensive transaction history

## Features

- **Multi-Currency Cards**: Create and manage NGN, USD, GBP cards
- **Virtual Card Management**: Generate, view, and manage card details
- **Subcards**: Create subcards with spending controls
- **Transactions**: Full history with clear UX
- **Currency Conversion**: Up-to-date conversion and totals
- **Top-Up via Paystack**: Embedded WebView flow
- **Auth & Security**: JWT, secure storage, optional biometrics
- **Responsive UI**: Modern design with dark theme support

## Architecture

- **State Management**: Provider + feature-specific controllers (`AuthController`, `CardController`, `CurrencyController`, `PaymentController`, `TransactionController`, `SubcardController`)
- **Services Layer**: Clean separation of UI and business logic (`auth_service.dart`, `card_service.dart`, etc.)
- **Models/DTOs**: Clear request/response models for API integration
- **Views**: Modular screens and reusable widgets

### Project Structure

```
lib/
├── config/                 # API endpoints and configuration
├── controller/            # State management controllers
├── model/                 # Data models and DTOs
├── services/              # API services and business logic
├── utils/                 # Utilities
├── view/                  # UI components and screens
└── main.dart              # App entry point
```

## Tech Stack

- **Flutter** (3.7+), **Dart**
- **provider**, **http**, **flutter_secure_storage**, **shared_preferences**
- **webview_flutter**, **shimmer**, **liquid_pull_to_refresh**, **flutter_screenutil**
- Build tooling: **build_runner**, **flutter_gen_runner**, **flutter_lints**

## Getting Started

### Prerequisites

- Flutter SDK 3.7.0+
- Android Studio or VS Code (Flutter/Dart extensions)
- Android SDK; Xcode for iOS (macOS only)

### Setup

```bash
git clone <your-repo-url>
cd manycards
flutter pub get
```

Generate asset references (if applicable):

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Environment Variables

Create a `.env` from the example and fill in your values:

```bash
cp .env.example .env
```

Example keys:

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

# Network
API_TIMEOUT_SECONDS=15
USER_AGENT=ManyCards/1.0
```

> Security: Never commit `.env` with real values.

### Run

```bash
flutter run
# Specific device
flutter run -d <device-id>
```

### Build

```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS (macOS only)
flutter build ios --release
```

## Security

- JWT-based auth, secure token storage, optional biometrics
- HTTPS-only API communication, input validation, safe error messages

## API Endpoints (expected)

- Auth: `POST /auth/signup`, `POST /auth/login`, `POST /auth/logout`, `POST /auth/forgot-password`, `POST /auth/confirm-forgot-password`
- Cards: `GET /cards`, `POST /cards/generate`, `GET /cards/{id}`
- Payments: `POST /payments/fund-account`, `POST /payments/paystack-webhook`
- Transactions: `GET /transactions`
- Subcards: `GET /subcards`, `POST /subcards`, `DELETE /subcards/{id}`

## Testing

```bash
flutter test
flutter test --coverage
flutter test test/widget_test.dart
```

## Development Tips

- Codegen: `dart run build_runner build --delete-conflicting-outputs`
- Watch mode: `flutter pub run build_runner watch`
- Assets: place images in `assets/images/`, SVGs in `assets/svg/`, fonts in `assets/fonts/`

## Troubleshooting

```bash
# Clean & regenerate
flutter clean && flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

# Android Gradle clean
cd android && ./gradlew clean | cat && cd ..

# iOS pods (macOS)
cd ios && pod install --repo-update | cat && cd ..
```

Common checks:

- `.env` exists and is valid
- API URLs reachable
- `flutter doctor -v` is green

## Platform Support

- Android: minSdk 21+, latest target
- iOS: iOS 12+, ARM64
- Web: experimental

## Roadmap

- [ ] In-app notifications
- [ ] Advanced analytics and budgeting
- [ ] More funding providers
- [ ] Card freeze/unfreeze

## Contributing

1. Fork → create feature branch → commit → PR
2. Run tests before pushing: `flutter test`

## License

MIT License. See `LICENSE`.

## Contact

- Open an issue or reach out to the maintainers.

---

Tip: Put your screenshots and GIFs in `docs/` and update the paths above.
