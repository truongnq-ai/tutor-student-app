# Tutor Student App

**Flutter mobile application for students - Personalized math learning**

## Project Overview

Tutor Student App is a Flutter mobile application that enables middle school students (Grades 6-7) to learn math through personalized tutoring. Students can solve math problems via image or text input, practice skills, take mini tests, and track their learning progress.

This module is part of the Tutor ecosystem - an AI-powered math tutoring platform.

## Role in System

The Student App enables students to:
- **Onboarding**: Set up grade and learning goals
- **Tutor Mode**: Solve math problems by uploading images or entering text
- **Practice**: Complete personalized practice sessions
- **Mini Tests**: Take skill assessment tests
- **Progress Tracking**: View mastery levels and learning history

## Tech Stack

### Required (from Project Specification)

| Component | Version | Purpose |
|-----------|---------|---------|
| Flutter | 3.16+ | Mobile framework |
| Dart | 3.2+ | Programming language |
| State Management | Riverpod/BLoC | State management |
| REST API | Retrofit/Dio | API communication |
| Camera/Image | image_picker, camera | Image capture |

### Current Implementation

| Component | Version | Status |
|-----------|---------|--------|
| Flutter | 3.38.4+ | ✅ Meets requirement |
| Dart | 3.10.3+ | ✅ Meets requirement |
| Riverpod | 2.5.1 | ✅ State management |
| go_router | 17.0.1 | ✅ Navigation |
| Retrofit | 4.4.0 | ✅ API client |
| Dio | 5.8.0+1 | ✅ HTTP client |
| SharedPreferences | 2.3.1 | ✅ Local storage |

### Missing / To Be Added

- [ ] **image_picker** - For selecting images from gallery
- [ ] **camera** - For capturing photos
- [ ] **google_sign_in** - For Google OAuth
- [ ] **sign_in_with_apple** - For Apple OAuth
- [ ] **cached_network_image** - For image caching
- [ ] **API Client Setup** - Configure Retrofit for Core Service
- [ ] **Environment Configuration** - API endpoints setup

## Prerequisites

- **Flutter SDK** 3.38.4 or later
- **Dart SDK** 3.10.3 or later
- **Android Studio** (for Android development)
- **Xcode** 15+ (for iOS development, macOS only)
- **Git** for version control

### Verify Installation

```bash
flutter --version
flutter doctor
```

Ensure all checks pass in `flutter doctor`.

## Installation

### 1. Install Dependencies

```bash
cd tutor-student-app
flutter pub get
```

### 2. Generate Code

This project uses code generation for:
- Riverpod providers
- Retrofit API clients
- Freezed models
- JSON serialization

```bash
# One-time generation
dart run build_runner build --delete-conflicting-outputs

# Watch mode (for development)
dart run build_runner watch --delete-conflicting-outputs
```

### 3. Environment Configuration

Create `lib/src/core/config/env.dart`:

```dart
class Env {
  // API Configuration
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080/api',
  );
  
  // Application
  static const String appName = 'Tutor';
  static const String appVersion = '1.0.0';
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );
}
```

### 4. Run Application

```bash
# List available devices
flutter devices

# Run on connected device/emulator
flutter run

# Run on specific device
flutter run -d <device-id>

# Run in release mode
flutter run --release
```

## Configuration

### Environment Variables

Set environment variables when running:

```bash
# Development
flutter run --dart-define=API_BASE_URL=http://localhost:8080/api \
           --dart-define=ENVIRONMENT=development

# Production
flutter run --dart-define=API_BASE_URL=https://api.tutor.app/api \
           --dart-define=ENVIRONMENT=production
```

### Platform-Specific Setup

#### Android

1. Update `android/app/build.gradle`:
   ```gradle
   android {
       compileSdkVersion 34
       minSdkVersion 21
       targetSdkVersion 34
   }
   ```

2. Add permissions in `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <uses-permission android:name="android.permission.CAMERA" />
   <uses-permission android:name="android.permission.INTERNET" />
   <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
   ```

#### iOS

1. Update `ios/Runner/Info.plist`:
   ```xml
   <key>NSCameraUsageDescription</key>
   <string>We need camera access to capture math problems</string>
   <key>NSPhotoLibraryUsageDescription</key>
   <string>We need photo library access to select math problem images</string>
   ```

2. Configure signing in Xcode

## Development

### Project Structure

```
tutor-student-app/
├── lib/
│   ├── src/
│   │   ├── core/              # Core utilities
│   │   │   ├── config/        # Environment config
│   │   │   ├── di/            # Dependency injection
│   │   │   ├── extensions/    # Extension methods
│   │   │   └── logger/        # Logging
│   │   ├── domain/            # Business logic layer
│   │   │   ├── entities/      # Business entities
│   │   │   ├── repositories/  # Repository interfaces
│   │   │   └── use_cases/     # Business use cases
│   │   ├── data/              # Data layer
│   │   │   ├── models/        # Data models
│   │   │   ├── repositories/  # Repository implementations
│   │   │   └── services/      # API services
│   │   └── presentation/      # UI layer
│   │       ├── core/          # Core UI components
│   │       │   ├── router/     # Navigation
│   │       │   ├── theme/      # Theming
│   │       │   └── widgets/    # Reusable widgets
│   │       └── features/       # Feature-specific UI
│   │           ├── onboarding/ # Onboarding flow
│   │           ├── tutor/      # Tutor mode (solve problems)
│   │           ├── practice/   # Practice sessions
│   │           └── progress/   # Progress tracking
│   └── main.dart              # Application entry point
├── test/                       # Test files
├── android/                    # Android-specific
├── ios/                        # iOS-specific
└── pubspec.yaml               # Dependencies
```

### Available Commands

```bash
# Get dependencies
flutter pub get

# Generate code
dart run build_runner build --delete-conflicting-outputs

# Run app
flutter run

# Build APK (Android)
flutter build apk

# Build IPA (iOS)
flutter build ios

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
dart format lib/
```

### Adding Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  # Image/Camera
  image_picker: ^1.0.5
  camera: ^0.10.5+5
  
  # OAuth
  google_sign_in: ^6.2.1
  sign_in_with_apple: ^5.0.0
  
  # Image caching
  cached_network_image: ^3.3.0
```

Then run:
```bash
flutter pub get
```

## Building

### Android APK

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# Split APKs (smaller size)
flutter build apk --split-per-abi
```

### iOS IPA

```bash
# Build for iOS
flutter build ios --release

# Then archive and export in Xcode
```

### App Bundle (Android)

```bash
# Build app bundle for Play Store
flutter build appbundle --release
```

## Deployment

### Android Deployment

1. **Generate Keystore**:
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks \
     -keyalg RSA -keysize 2048 -validity 10000 \
     -alias upload
   ```

2. **Configure Signing**:
   Create `android/key.properties`:
   ```properties
   storePassword=<password>
   keyPassword=<password>
   keyAlias=upload
   storeFile=<path-to-keystore>
   ```

3. **Update build.gradle**:
   Reference `key.properties` in `android/app/build.gradle`

4. **Build Release**:
   ```bash
   flutter build appbundle --release
   ```

5. **Upload to Play Store**:
   - Use Google Play Console
   - Upload the `.aab` file

### iOS Deployment

1. **Configure Signing**:
   - Open project in Xcode
   - Configure signing & capabilities
   - Set bundle identifier

2. **Build Archive**:
   ```bash
   flutter build ios --release
   ```
   Then archive in Xcode

3. **Upload to App Store**:
   - Use Xcode Organizer
   - Upload to App Store Connect

## API Integration

### API Client Setup

The app uses Retrofit for API communication. Configure in:

```
lib/src/data/services/api_client.dart
```

Example API client:

```dart
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;
  
  // Tutor Mode
  @POST('/tutor/solve/image')
  @MultiPart()
  Future<SolveResponse> solveImage(
    @Part() File image,
    @Part() int grade,
  );
  
  @POST('/tutor/solve/text')
  Future<SolveResponse> solveText(
    @Body() SolveTextRequest request,
  );
  
  // Learning
  @GET('/learning/today')
  Future<LearningPlanResponse> getTodayPlan();
  
  // Practice
  @POST('/practice/submit')
  Future<PracticeResponse> submitPractice(
    @Body() PracticeRequest request,
  );
}
```

### Core Service Endpoints

The app integrates with Core Service for:

- **Authentication**:
  - `POST /api/student/register` - Student registration
  - `POST /api/student/login` - Student login
  - `POST /api/student/oauth/login` - OAuth login

- **Tutor Mode**:
  - `POST /api/tutor/solve/image` - Solve from image
  - `POST /api/tutor/solve/text` - Solve from text

- **Learning**:
  - `GET /api/learning/today` - Today's learning plan
  - `POST /api/practice/submit` - Submit practice
  - `GET /api/practice/history` - Practice history

- **Linking**:
  - `POST /api/link/request-otp` - Request OTP for parent linking
  - `POST /api/link/verify-otp` - Verify OTP and link

## Next Steps

### Implementation Status

- ✅ **Foundation**: Flutter 3.38.4+ with Clean Architecture
- ✅ **State Management**: Riverpod setup
- ✅ **Navigation**: go_router configured
- ✅ **API Client**: Retrofit + Dio setup
- ✅ **Local Storage**: SharedPreferences configured
- 🚧 **Dependencies**: Need to add image_picker, camera, OAuth packages
- 📋 **Onboarding**: Need to implement onboarding flow
- 📋 **Tutor Mode**: Need to implement camera/image picker and solution display
- 📋 **Practice**: Need to implement practice sessions
- 📋 **Progress**: Need to implement progress tracking

### Required Implementations

1. **Add Missing Packages**
   - Add `image_picker` and `camera` to `pubspec.yaml`
   - Add `google_sign_in` and `sign_in_with_apple`
   - Add `cached_network_image`

2. **Onboarding Flow**
   - Grade selection screen
   - Learning goal selection
   - Trial setup

3. **Tutor Mode**
   - Camera integration
   - Image picker
   - Image upload to Core Service
   - Solution display (step-by-step)

4. **Practice & Mini Test**
   - Question display
   - Answer input
   - Result display
   - Progress update

5. **API Client**
   - Configure Retrofit endpoints
   - Setup authentication interceptors
   - Add error handling

6. **Environment Configuration**
   - Setup environment-specific configs
   - Configure API endpoints
   - Add build configurations

## Testing

### Run Tests

```bash
# All tests
flutter test

# Specific test file
flutter test test/features/tutor/tutor_test.dart

# With coverage
flutter test --coverage
```

### Test Structure

```
test/
├── unit/              # Unit tests
├── widget/            # Widget tests
└── integration/       # Integration tests
```

## Troubleshooting

### Common Issues

**Issue**: Flutter doctor shows issues
```bash
# Run flutter doctor and fix issues
flutter doctor -v

# Common fixes:
# - Install Android SDK
# - Accept Android licenses: flutter doctor --android-licenses
# - Install Xcode (macOS only)
```

**Issue**: Code generation fails
```bash
# Clean and regenerate
flutter clean
flutter pub get
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

**Issue**: Android build fails
```bash
# Clean build
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk
```

**Issue**: iOS build fails
```bash
# Clean and rebuild
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter pub get
flutter build ios
```

**Issue**: API connection errors
- Verify Core Service is running
- Check API_BASE_URL in environment
- Verify network permissions in AndroidManifest.xml / Info.plist

## Related Documentation

- [System Architecture](../../tutor_docs/technical_design/system_architecture_phase_1-2025-12-15-00-21.md)
- [API Specification](../../tutor_docs/technical_design/api_specification_phase_1-2025-12-15-03-30.md)
- [Student User Stories](../../tutor_docs/user_stories/student_user_stories_phase_1-2025-12-14-22-45.md)
- [Development Setup](../../tutor_docs/technical_design/development_setup_phase_1-2025-12-15-03-00.md)

## License

This project is part of the Tutor platform and is licensed under the MIT License.

---

**Last Updated**: 2025-12-15
