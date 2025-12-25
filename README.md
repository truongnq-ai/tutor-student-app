# Tutor Student App

**Ứng dụng Flutter cho học sinh - Học Toán cá nhân hóa**

## Tổng Quan Dự Án

Tutor Student App là ứng dụng mobile Flutter dành cho học sinh trung học cơ sở (lớp 6-7) để học Toán thông qua gia sư AI cá nhân hóa. Học sinh có thể giải bài Toán bằng cách chụp ảnh hoặc nhập văn bản, luyện tập kỹ năng, làm mini test, và theo dõi tiến độ học tập.

Module này là một phần của hệ thống Tutor - nền tảng gia sư Toán AI.

## Vai Trò Trong Hệ Thống

Student App cho phép học sinh:
- **Onboarding**: Thiết lập lớp học và mục tiêu học tập
- **Tutor Mode**: Giải bài Toán bằng cách upload ảnh hoặc nhập văn bản
- **Practice**: Hoàn thành các buổi luyện tập cá nhân hóa
- **Mini Test**: Làm bài kiểm tra đánh giá kỹ năng
- **Progress Tracking**: Xem mức độ thành thạo và lịch sử học tập
- **Parent Linking**: Liên kết với phụ huynh bằng số điện thoại

## Tech Stack

### Yêu Cầu (từ Project Specification)

| Component | Version | Mục Đích |
|-----------|---------|----------|
| Flutter | 3.16+ | Mobile framework |
| Dart | 3.2+ | Ngôn ngữ lập trình |
| State Management | Riverpod/BLoC | Quản lý state |
| REST API | Retrofit/Dio | Giao tiếp API |
| Camera/Image | image_picker, camera | Chụp ảnh |

### Hiện Trạng Triển Khai

| Component | Version | Trạng Thái |
|-----------|---------|------------|
| Flutter | 3.38.4+ | ✅ Đạt yêu cầu |
| Dart | 3.10.3+ | ✅ Đạt yêu cầu |
| Riverpod | 2.5.1 | ✅ State management |
| go_router | 17.0.1 | ✅ Navigation |
| Retrofit | 4.4.0 | ✅ API client |
| Dio | 5.8.0+1 | ✅ HTTP client |
| SharedPreferences | 2.3.1 | ✅ Local storage |
| flutter_localizations | Latest | ✅ Đa ngôn ngữ |
| logger | 2.4.0 | ✅ Logging |

### Thiếu / Cần Bổ Sung

- [ ] **image_picker** - Để chọn ảnh từ thư viện
- [ ] **camera** - Để chụp ảnh
- [ ] **google_sign_in** - Cho Google OAuth
- [ ] **sign_in_with_apple** - Cho Apple OAuth
- [ ] **cached_network_image** - Để cache ảnh từ mạng
- [ ] **API Client Setup** - Cấu hình Retrofit cho Core Service
- [ ] **Environment Configuration** - Thiết lập API endpoints

## Kiến Trúc Module

Module này sử dụng **Clean Architecture** với các layer:

- **Presentation Layer**: UI components, pages, widgets, routing
- **Domain Layer**: Business logic, entities, use cases, repository interfaces
- **Data Layer**: API services, repository implementations, models
- **Core Layer**: Dependency injection, utilities, extensions, logging

### Cấu Trúc Thư Mục

```
tutor-student-app/
├── lib/
│   ├── src/
│   │   ├── core/              # Core utilities
│   │   │   ├── base/          # Base classes (exceptions, failures, repositories)
│   │   │   ├── di/            # Dependency injection
│   │   │   ├── extensions/    # Extension methods
│   │   │   ├── logger/        # Logging
│   │   │   └── utiliity/      # Utilities (validation)
│   │   ├── domain/            # Business logic layer
│   │   │   ├── entities/      # Business entities
│   │   │   ├── repositories/  # Repository interfaces
│   │   │   └── use_cases/     # Business use cases
│   │   ├── data/              # Data layer
│   │   │   ├── models/        # Data models
│   │   │   ├── repositories/  # Repository implementations
│   │   │   └── services/      # API services
│   │   │       ├── cache/     # Cache services
│   │   │       └── network/   # Network services (Retrofit, Dio)
│   │   └── presentation/      # UI layer
│   │       ├── core/          # Core UI components
│   │       │   ├── application_state/  # App state providers
│   │       │   ├── router/     # Navigation
│   │       │   ├── theme/      # Theming
│   │       │   └── widgets/    # Reusable widgets
│   │       └── features/       # Feature-specific UI
│   │           ├── authentication/  # Auth flow
│   │           ├── onboarding/      # Onboarding flow
│   │           ├── home/           # Home screen
│   │           ├── profile/        # Profile screen
│   │           └── splash/         # Splash screen
│   └── main.dart              # Application entry point
├── test/                       # Test files
├── android/                    # Android-specific
├── ios/                        # iOS-specific
└── pubspec.yaml               # Dependencies
```

## Yêu Cầu Hệ Thống

- **Flutter SDK** 3.38.4 trở lên
- **Dart SDK** 3.10.3 trở lên
- **Android Studio** (cho phát triển Android)
- **Xcode** 15+ (cho phát triển iOS, chỉ trên macOS)
- **Git** để quản lý phiên bản

### Kiểm Tra Cài Đặt

```bash
flutter --version
flutter doctor
```

Đảm bảo tất cả các kiểm tra trong `flutter doctor` đều pass.

## Cài Đặt

### 1. Cài Đặt Dependencies

```bash
cd tutor-student-app
flutter pub get
```

### 2. Generate Code

Dự án sử dụng code generation cho:
- Riverpod providers
- Retrofit API clients
- Freezed models
- JSON serialization

```bash
# Generate một lần
dart run build_runner build --delete-conflicting-outputs

# Watch mode (cho development)
dart run build_runner watch --delete-conflicting-outputs
```

### 3. Cấu Hình Environment

File `lib/src/core/config/env.dart` đã được cấu hình sẵn với:
- Auto-select API URL theo environment (development/production)
- Production URL mặc định: `https://apitutor.dienluc.vn`
- Development URL mặc định: `https://apitutor.dienluc.vn`
- Có thể override bằng `--dart-define=API_BASE_URL=<url>`

**Lưu ý:** Base URL không bao gồm `/api` vì endpoints đã có prefix `/api/v1/...`

### 4. Chạy Ứng Dụng

```bash
# Liệt kê các thiết bị có sẵn
flutter devices

# Chạy trên thiết bị/emulator đã kết nối
flutter run

# Chạy trên thiết bị cụ thể
flutter run -d <device-id>

# Chạy ở chế độ release
flutter run --release
```

## Cấu Hình

### Environment Variables

Thiết lập environment variables khi chạy:

```bash
# Development (sử dụng URL mặc định từ code)
flutter run --dart-define=ENVIRONMENT=development

# Development với custom API URL
flutter run --dart-define=API_BASE_URL=http://localhost:8080 \
           --dart-define=ENVIRONMENT=development

# Production (sử dụng URL mặc định từ code)
flutter run --dart-define=ENVIRONMENT=production

# Production với custom API URL
flutter run --dart-define=API_BASE_URL=https://apitutor.dienluc.vn \
           --dart-define=ENVIRONMENT=production
```

**Lưu ý:** 
- Base URL không bao gồm `/api` (ví dụ: `http://localhost:8080` thay vì `http://localhost:8080/api`)
- Nếu không truyền `API_BASE_URL`, hệ thống sẽ tự động chọn URL dựa trên `ENVIRONMENT`

### Cấu Hình Platform-Specific

#### Android

1. Cập nhật `android/app/build.gradle`:
   ```gradle
   android {
       compileSdkVersion 34
       minSdkVersion 21
       targetSdkVersion 34
   }
   ```

2. Thêm permissions trong `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <uses-permission android:name="android.permission.CAMERA" />
   <uses-permission android:name="android.permission.INTERNET" />
   <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
   ```

#### iOS

1. Cập nhật `ios/Runner/Info.plist`:
   ```xml
   <key>NSCameraUsageDescription</key>
   <string>Chúng tôi cần quyền truy cập camera để chụp ảnh bài Toán</string>
   <key>NSPhotoLibraryUsageDescription</key>
   <string>Chúng tôi cần quyền truy cập thư viện ảnh để chọn ảnh bài Toán</string>
   ```

2. Cấu hình signing trong Xcode

## Phát Triển

### Các Lệnh Có Sẵn

```bash
# Cài đặt dependencies
flutter pub get

# Generate code
dart run build_runner build --delete-conflicting-outputs

# Chạy app
flutter run

# Build APK (Android)
flutter build apk

# Build IPA (iOS)
flutter build ios

# Chạy tests
flutter test

# Phân tích code
flutter analyze

# Format code
dart format lib/
```

### Thêm Dependencies

Thêm vào `pubspec.yaml`:

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

Sau đó chạy:
```bash
flutter pub get
```

## Build

### Android APK

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# Split APKs (kích thước nhỏ hơn)
flutter build apk --split-per-abi
```

### iOS IPA

```bash
# Build cho iOS
flutter build ios --release

# Sau đó archive và export trong Xcode
```

### App Bundle (Android)

```bash
# Build app bundle cho Play Store
flutter build appbundle --release
```

## Deployment

### Android Deployment

1. **Tạo Keystore**:
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks \
     -keyalg RSA -keysize 2048 -validity 10000 \
     -alias upload
   ```

2. **Cấu Hình Signing**:
   Tạo `android/key.properties`:
   ```properties
   storePassword=<password>
   keyPassword=<password>
   keyAlias=upload
   storeFile=<path-to-keystore>
   ```

3. **Cập Nhật build.gradle**:
   Tham chiếu `key.properties` trong `android/app/build.gradle`

4. **Build Release**:
   ```bash
   flutter build appbundle --release
   ```

5. **Upload lên Play Store**:
   - Sử dụng Google Play Console
   - Upload file `.aab`

### iOS Deployment

1. **Cấu Hình Signing**:
   - Mở project trong Xcode
   - Cấu hình signing & capabilities
   - Thiết lập bundle identifier

2. **Build Archive**:
   ```bash
   flutter build ios --release
   ```
   Sau đó archive trong Xcode

3. **Upload lên App Store**:
   - Sử dụng Xcode Organizer
   - Upload lên App Store Connect

## Tích Hợp API

### API Client Setup

Ứng dụng sử dụng Retrofit cho giao tiếp API. Cấu hình tại:

```
lib/src/data/services/network/rest_client.dart
```

### Core Service Endpoints

Ứng dụng tích hợp với Core Service cho:

- **Authentication**:
  - `POST /api/student/register` - Đăng ký học sinh
  - `POST /api/student/login` - Đăng nhập học sinh
  - `POST /api/student/oauth/login` - Đăng nhập OAuth
  - `POST /api/student/set-credential` - Thiết lập username/password sau OAuth

- **Tutor Mode**:
  - `POST /api/tutor/solve/image` - Giải bài từ ảnh
  - `POST /api/tutor/solve/text` - Giải bài từ văn bản

- **Learning**:
  - `GET /api/learning/today` - Lộ trình học hôm nay
  - `POST /api/practice/submit` - Nộp bài luyện tập
  - `GET /api/practice/history` - Lịch sử luyện tập

- **Mini Test**:
  - `POST /api/minitest/start` - Bắt đầu mini test
  - `POST /api/minitest/submit` - Nộp kết quả mini test

- **Linking**:
  - `POST /api/link/request-otp` - Yêu cầu OTP để liên kết phụ huynh
  - `POST /api/link/verify-otp` - Xác thực OTP và liên kết

### Response Format

Tất cả API trả về response với cấu trúc:

```dart
// Success Response
{
  "errorCode": "0000",        // Optional - mã thành công
  "errorDetail": "Operation successful",  // Optional
  "data": {...}               // Dữ liệu trả về
}
// HTTP 200

// Error Response
{
  "errorCode": "0001",        // Required - mã lỗi
  "errorDetail": "Error description",  // Required
  "data": null                // Optional
}
// HTTP 400/401/403/404/500
```

## Roadmap

Xem [Student App Roadmap](../../tutor_docs/04-for-developers/roadmap/student-app.md) để theo dõi tiến độ triển khai chi tiết.

## Cần Triển Khai

### 1. Thêm Packages Còn Thiếu

**Thêm vào `pubspec.yaml`**:
- `image_picker` - Để chọn ảnh từ thư viện
- `camera` - Để chụp ảnh
- `google_sign_in` - Cho Google OAuth
- `sign_in_with_apple` - Cho Apple OAuth
- `cached_network_image` - Để cache ảnh từ mạng

### 2. Onboarding Flow

**Cần implement**:
- Màn hình chọn lớp học (lớp 6 hoặc lớp 7)
- Màn hình chọn mục tiêu học tập
- Setup trial account nếu chưa đăng nhập
- Lưu thông tin onboarding vào local storage

**Files cần tạo/customize**:
- `lib/src/presentation/features/onboarding/view/grade_selection_page.dart`
- `lib/src/presentation/features/onboarding/view/learning_goal_page.dart`
- `lib/src/presentation/features/onboarding/view/onboarding_page.dart` (customize)

### 3. Tutor Mode

**Cần implement**:
- Tích hợp camera để chụp ảnh bài Toán
- Image picker để chọn ảnh từ thư viện
- Upload ảnh lên Core Service
- Hiển thị lời giải từng bước
- Hiển thị cảnh báo lỗi sai thường gặp

**Files cần tạo**:
- `lib/src/presentation/features/tutor/view/tutor_page.dart`
- `lib/src/presentation/features/tutor/view/solution_display_page.dart`
- `lib/src/presentation/features/tutor/widgets/camera_widget.dart`
- `lib/src/presentation/features/tutor/widgets/image_picker_widget.dart`
- `lib/src/data/services/network/tutor_service.dart`

### 4. Practice Sessions

**Cần implement**:
- Hiển thị câu hỏi luyện tập
- Input câu trả lời
- Hiển thị kết quả và giải thích
- Cập nhật mastery sau mỗi bài
- Điều chỉnh độ khó dựa trên performance

**Files cần tạo**:
- `lib/src/presentation/features/practice/view/practice_page.dart`
- `lib/src/presentation/features/practice/view/question_display_widget.dart`
- `lib/src/presentation/features/practice/view/result_display_widget.dart`
- `lib/src/data/services/network/practice_service.dart`

### 5. Mini Test

**Cần implement**:
- Bắt đầu mini test cho một skill
- Hiển thị câu hỏi với timer
- Nộp kết quả
- Hiển thị điểm số và phân tích
- Cập nhật mastery dựa trên kết quả

**Files cần tạo**:
- `lib/src/presentation/features/mini_test/view/mini_test_page.dart`
- `lib/src/presentation/features/mini_test/view/test_result_page.dart`
- `lib/src/data/services/network/mini_test_service.dart`

### 6. Progress Tracking

**Cần implement**:
- Hiển thị mastery levels cho từng skill
- Biểu đồ tiến độ theo thời gian
- Lịch sử học tập
- Gợi ý cải thiện dựa trên điểm yếu

**Files cần tạo**:
- `lib/src/presentation/features/progress/view/progress_page.dart`
- `lib/src/presentation/features/progress/widgets/mastery_chart_widget.dart`
- `lib/src/presentation/features/progress/widgets/learning_history_widget.dart`
- `lib/src/data/services/network/progress_service.dart`

### 7. Parent Linking

**Cần implement**:
- Màn hình nhập số điện thoại phụ huynh
- Gửi OTP
- Xác thực OTP
- Liên kết với tài khoản phụ huynh

**Files cần tạo**:
- `lib/src/presentation/features/parent_linking/view/link_parent_page.dart`
- `lib/src/presentation/features/parent_linking/view/otp_verification_page.dart`
- `lib/src/data/services/network/linking_service.dart`

### 8. API Client Configuration

**Cần implement**:
- Cấu hình Retrofit endpoints cho tất cả API
- Setup authentication interceptors
- Xử lý error handling
- Token refresh mechanism

**Files cần customize**:
- `lib/src/data/services/network/rest_client.dart`
- `lib/src/data/services/network/endpoints.dart`
- `lib/src/data/services/network/interceptor/token_manager.dart`

### 9. Environment Configuration

**Cần implement**:
- Tạo `lib/src/core/config/env.dart`
- Setup environment-specific configs
- Cấu hình API endpoints
- Thêm build configurations

## Testing

### Chạy Tests

```bash
# Tất cả tests
flutter test

# Test file cụ thể
flutter test test/features/tutor/tutor_test.dart

# Với coverage
flutter test --coverage
```

### Cấu Trúc Test

```
test/
├── unit/              # Unit tests
├── widget/            # Widget tests
└── integration/       # Integration tests
```

## Troubleshooting

### Các Vấn Đề Thường Gặp

**Vấn đề**: Flutter doctor hiển thị lỗi
```bash
# Chạy flutter doctor và sửa lỗi
flutter doctor -v

# Các cách sửa thường gặp:
# - Cài đặt Android SDK
# - Chấp nhận Android licenses: flutter doctor --android-licenses
# - Cài đặt Xcode (chỉ trên macOS)
```

**Vấn đề**: Code generation thất bại
```bash
# Clean và regenerate
flutter clean
flutter pub get
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

**Vấn đề**: Android build thất bại
```bash
# Clean build
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk
```

**Vấn đề**: iOS build thất bại
```bash
# Clean và rebuild
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter pub get
flutter build ios
```

**Vấn đề**: Lỗi kết nối API
- Kiểm tra Core Service đang chạy
- Kiểm tra API_BASE_URL trong environment
- Kiểm tra network permissions trong AndroidManifest.xml / Info.plist

## Tài Liệu Liên Quan

- [System Architecture](../../tutor_docs/04-for-developers/architecture/system-architecture.md)
- [API Specification](../../tutor_docs/04-for-developers/architecture/api-specification.md)
- [Student User Stories](../../tutor_docs/03-for-product-owners/user-stories/student/README.md)
- [Development Setup](../../tutor_docs/04-for-developers/setup/development-setup.md)
- [Flutter Coding Standards](../../tutor_docs/04-for-developers/coding-standards/flutter/README.md)

## License

Dự án này là một phần của nền tảng Tutor và được cấp phép theo MIT License.

---

**Cập Nhật Lần Cuối**: 2025-01-22
