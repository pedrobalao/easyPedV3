# easypedv3

A pediatric reference app built with Flutter.

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (>=3.0.0)
- A Firebase project configured for Android and iOS
- Google Sign-In credentials

### Environment Setup

This project uses environment variables loaded via [`flutter_dotenv`](https://pub.dev/packages/flutter_dotenv).

1. Copy `.env.example` to `.env` at the project root:

   ```bash
   cp .env.example .env
   ```

2. Fill in the required values in `.env`:

   | Variable           | Description                                      |
   |--------------------|--------------------------------------------------|
   | `API_BASE_URL`     | Base URL of the easyPed backend API              |
   | `GOOGLE_CLIENT_ID` | OAuth client ID for Firebase Google Sign-In      |

3. Place your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) in the correct platform folders.

### Running the App

```bash
flutter pub get
flutter run
```

### Building

```bash
# Android App Bundle
flutter build appbundle

# iOS IPA
flutter build ipa
```

## Resources

- [Flutter documentation](https://flutter.dev/docs)
- [Firebase for Flutter](https://firebase.flutter.dev/)
