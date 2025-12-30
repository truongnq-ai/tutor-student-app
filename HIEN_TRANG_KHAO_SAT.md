# KHẢO SÁT HIỆN TRẠNG STUDENT APP (FLUTTER)
## Dự án: Gia sư Toán AI

**Ngày khảo sát:** 2025-01-22  
**Module:** Student App (Flutter)  
**Mục tiêu:** Mô tả toàn bộ hiện trạng codebase, không đánh giá hay đề xuất

---

## 1. TECH STACK & NỀN TẢNG

### Flutter & Dart
- **Flutter SDK:** 3.38.4+ (theo README), yêu cầu tối thiểu 3.16+
- **Dart SDK:** 3.10.3+ (theo pubspec.yaml `sdk: ^3.10.3`)
- **Null-safety:** ✅ Đã bật (Dart 3.x mặc định null-safe)
- **Platform target:** 
  - Android (có thư mục `android/`)
  - iOS (có thư mục `ios/`)
  - Web (có thể hỗ trợ, chưa xác nhận rõ)

### State Management
- **Framework:** `flutter_riverpod` version 2.5.1
- **Code generation:** `riverpod_annotation` 2.3.5 + `riverpod_generator`
- **Pattern:** Sử dụng Riverpod với code generation (`.g.dart` files)
- **Equatable:** 2.0.5 (cho value comparison)

### Navigation
- **Solution:** `go_router` version 17.0.1
- **Pattern:** Navigator 2.0 declarative routing
- **Shell navigation:** Sử dụng `StatefulShellRoute` cho bottom navigation

### Dependency Injection
- **Approach:** Riverpod providers làm DI container
- **Location:** `lib/src/core/di/dependency_injection.dart`
- **Code generation:** Có file `.g.dart` cho DI setup

### HTTP Client & API
- **HTTP client:** `dio` version 5.8.0+1
- **API client:** `retrofit` version >=4.6.0 <4.9.0
- **Code generation:** `retrofit_generator` 9.7.0
- **Logging:** `pretty_dio_logger` 1.4.0

### Local Storage
- **Primary:** `shared_preferences` version 2.3.1
- **Cache service:** Có custom `CacheService` tại `lib/src/data/services/cache/`

### Serialization
- **Library:** `dart_mappable` (code generation)
- **Builder:** `dart_mappable_builder`

### UI Libraries
- **Icons:** `cupertino_icons` 1.0.6
- **Spacing:** `gap` 3.0.1
- **Loading:** `shimmer` 3.0.0
- **SVG:** `flutter_svg` 2.0.10+1
- **Images:** 
  - `image_picker` 1.0.5
  - `image_cropper` 8.0.2
  - `camera` 0.10.5+5
  - `cached_network_image` 3.3.0

### Authentication
- **Google Sign-In:** `google_sign_in` 6.2.1
- **Apple Sign-In:** `sign_in_with_apple` 6.1.3

### Utilities
- **UUID:** `uuid` 4.5.1
- **Device Info:** `device_info_plus` 10.1.0
- **URL Launcher:** `url_launcher` 6.3.1
- **Logging:** `logger` 2.4.0

### Firebase
- **Core:** `firebase_core` 3.6.0
- **Installations:** `firebase_app_installations` 0.3.1+4
- **Purpose:** Device ID generation (fallback)

### Localization
- **Framework:** `flutter_localizations` (SDK)
- **Package:** `intl` 0.20.2
- **Config:** `l10n.yaml` với generate: true
- **Output:** `lib/src/core/gen/l10n/`
- **Languages:** 
  - `intl_vi.arb` (Tiếng Việt)
  - `intl_en.arb` (English)

### Code Quality Tools
- **Linter:** `flutter_lints` 6.0.0
- **Custom lint:** `custom_lint` + `flutter_guardian` (local package tại `packages/flutter_guardian/`)
- **Riverpod lint:** `riverpod_lint`
- **Build runner:** `build_runner` (cho code generation)

### Code Generation Tools
- **Freezed:** 3.0.6 (cho immutable classes, exceptions, failures)
- **Retrofit generator:** 9.7.0
- **Riverpod generator:** (từ riverpod_generator)
- **Dart mappable builder:** (từ dart_mappable_builder)
- **Flutter gen runner:** `flutter_gen_runner` (cho assets)

---

## 2. CẤU TRÚC THƯ MỤC & MODULE

### Cấu trúc Root
```
tutor-student-app/
├── lib/
│   ├── main.dart
│   └── src/
├── test/
├── android/
├── ios/
├── packages/ (local packages)
│   └── flutter_guardian/
├── docs/
├── .github/
├── pubspec.yaml
├── analysis_options.yaml
├── l10n.yaml
├── build.yaml
└── devtools_options.yaml
```

### Kiến trúc: Clean Architecture (theo README)

#### Core Layer (`lib/src/core/`)
- **base/**: Base classes
  - `exceptions.dart` + `.freezed.dart`
  - `failure.dart` + `.freezed.dart`
  - `repository.dart` (base repository interface)
  - `response_object.dart`
  - `result.dart` + `.freezed.dart`
- **config/**: 
  - `env.dart` (environment configuration)
  - `mini_test_config.dart` (mini test constants)
- **constants/**: 
  - `error_codes.dart`
- **di/**: Dependency injection
  - `dependency_injection.dart` + `.g.dart`
  - `parts/`: 
    - `externals.dart`
    - `repository.dart`
    - `services.dart`
    - `use_cases.dart`
- **extensions/**: 
  - `app_localization.dart`
  - `go_router_extension.dart`
  - `riverpod_extensions.dart`
  - `validation.dart`
- **gen/**: Generated code
  - `l10n/` (localization generated files)
- **localization/**: 
  - `intl_vi.arb`
  - `intl_en.arb`
- **logger/**: 
  - `log.dart`
  - `riverpod_log.dart`
- **utility/validation/**: 6 files validation
- **utils/**: 
  - `error_handler.dart`
  - `error_message_mapper.dart`

#### Domain Layer (`lib/src/domain/`)
- **entities/**: 20+ entity files
  - `chapter_progress_entity.dart`
  - `image_upload_entity.dart`
  - `learning_entity.dart`
  - `login_entity.dart`
  - `mini_test_result_entity.dart`
  - `mini_test_session_entity.dart`
  - `practice_entity.dart`
  - `practice_session_entity.dart`
  - `profile_entity.dart`
  - `progress_dashboard_entity.dart`
  - `question_entity.dart`
  - `recommendation_entity.dart`
  - `session_info_entity.dart`
  - `settings_entity.dart`
  - `sign_up_entity.dart`
  - `skill_detail_entity.dart`
  - `student_check_entity.dart`
  - `trial_entity.dart`
  - `tutor_entity.dart`
  - `weak_skill_entity.dart`
- **repositories/**: 17 repository interface files
- **use_cases/**: 7 use case files
  - `authentication_use_case.dart`
  - `locale_use_case.dart`
  - `onboarding_use_case.dart`
  - `parent_linking_use_case.dart`
  - `reset_repository_use_case.dart`
  - `router_use_case.dart`
  - `trial_use_case.dart`

#### Data Layer (`lib/src/data/`)
- **models/**: 25+ model files với `.mapper.dart` (dart_mappable)
  - `chapter_progress_model.dart` + mapper
  - `image_upload_model.dart`
  - `learning_model.dart`
  - `login_model.dart` + mapper
  - `mini_test_result_model.dart` + mapper
  - `mini_test_session_model.dart` + mapper
  - `practice_model.dart`
  - `practice_session_model.dart` + mapper
  - `profile_model.dart` + mapper
  - `progress_dashboard_model.dart` + mapper
  - `question_model.dart`
  - `recommendation_model.dart` + mapper
  - `session_info_model.dart` + mapper
  - `settings_model.dart` + mapper
  - `sign_up_model.dart`
  - `skill_detail_model.dart` + mapper
  - `student_check_model.dart`
  - `trial_model.dart`
  - `tutor_model.dart`
  - `weak_skill_model.dart` + mapper
- **repositories/**: 17 repository implementations
  - `authentication_repository_impl.dart`
  - `image_upload_repository_impl.dart`
  - `learning_repository_impl.dart`
  - `locale_repository_impl.dart`
  - `mini_test_repository_impl.dart`
  - `onboarding_repository_impl.dart`
  - `parent_linking_repository_impl.dart`
  - `password_repository_impl.dart`
  - `practice_repository_impl.dart`
  - `practice_session_repository_impl.dart`
  - `profile_repository_impl.dart`
  - `progress_repository_impl.dart`
  - `question_repository_impl.dart`
  - `router_repository_impl.dart`
  - `settings_repository_impl.dart`
  - `trial_repository_impl.dart`
  - `tutor_repository_impl.dart`
- **services/**:
  - **cache/**: 2 files cache service
  - **device/**: 1 file device service
  - **mock/**: 1 file mock service
  - **network/**: 16 files
    - `endpoints.dart`
    - `rest_client.dart`
    - `interceptor/token_manager.dart`
    - **services/**: 15 API service files (Retrofit)
      - `auth_service.dart` + `.g.dart`
      - `image_upload_service.dart` + `.g.dart`
      - `learning_service.dart` + `.g.dart`
      - `linking_service.dart` + `.g.dart`
      - `mini_test_service.dart` + `.g.dart`
      - `password_service.dart` + `.g.dart`
      - `practice_service.dart` + `.g.dart`
      - `practice_session_service.dart` + `.g.dart`
      - `profile_service.dart` + `.g.dart`
      - `progress_service.dart` + `.g.dart`
      - `settings_service.dart` + `.g.dart`
      - `student_service.dart` + `.g.dart`
      - `tutor_service.dart` + `.g.dart`
  - **oauth/**: 5 files OAuth services

#### Presentation Layer (`lib/src/presentation/`)
- **core/**:
  - **application_state/**: 3 files app state providers
  - **base/**: 1 file base classes
  - **gen/**: Generated assets
  - **router/**: 10 files routing
    - `router.dart` + `.g.dart`
    - `routes.dart`
    - `router_state/router_state_provider.dart` + `.g.dart`
    - **parts/**: 7 route definition files
      - `authentication_routes.dart`
      - `learning_routes.dart`
      - `on_boarding_routes.dart`
      - `profile_routes.dart`
      - `progress_routes.dart`
      - `shell_routes.dart`
      - `tutor_routes.dart`
  - **theme/**: 18 files theming
  - **widgets/**: 11 files reusable widgets
- **features/**: 101+ files feature-specific UI
  - `authentication/` (login, registration, OAuth, forgot password)
  - `home/` (home page)
  - `learning/` (today learning plan)
  - `onboarding/` (welcome, trial, grade selection, OTP)
  - `practice/` (practice sessions, questions, results)
  - `profile/` (profile, settings, password)
  - `progress/` (dashboard, skill detail, mini test)
  - `splash/` (splash screen)
  - `tutor/` (tutor mode, camera, solution)

### Module Organization
- **Pattern:** Feature-based organization trong `presentation/features/`
- **Mỗi feature có:**
  - `view/`: Screen pages
  - `widgets/`: Feature-specific widgets
  - `riverpod/`: State providers (với `.g.dart` generated)
  - `utils/`: Feature utilities (nếu có)
  - `model/`: Feature models (nếu có)

### Legacy / Experimental / Unused
- **Không rõ ràng:** Cần xác nhận thêm về code không dùng
- **Mock service:** Có file tại `lib/src/data/services/mock/` (1 file) - cần xác nhận mục đích

---

## 3. ROUTING & NAVIGATION

### Navigation Solution
- **Framework:** GoRouter 17.0.1 (Navigator 2.0 declarative)
- **Entry point:** `lib/src/presentation/core/router/router.dart`
- **Provider:** `goRouterProvider` (Riverpod, keepAlive: true)
- **Root navigator key:** `_rootNavigatorKey` (GlobalKey<NavigatorState>)

### Route Structure
- **Initial route:** `/` (splash/startup)
- **Route groups:** Tách thành các part files
  - Authentication routes
  - Onboarding routes
  - Learning routes
  - Tutor routes
  - Progress routes
  - Profile routes
  - Shell routes (bottom navigation)

### Danh sách Routes (từ `routes.dart`)

#### Initial & Splash
- `/` - Initial (splash/startup)
- `/splash` - Splash screen

#### Onboarding
- `/welcome` - Welcome page
- `/trial-start` - Trial start page
- `/select-grade-and-goals` - Grade and goals selection
- `/trial-status` - Trial status page
- `/trial-expiry` - Trial expiry page
- `/otp-verification` - OTP verification (parent linking)
- `/linking-success` - Linking success page
- `/onboarding` - Onboarding page (legacy?)

#### Authentication
- `/auth-entry` - Auth entry point
- `/login` - Login page
- `reset-password` - Reset password entry
- `email-verification` - Email verification
- `create-new-password` - Create new password
- `reset-password-success` - Reset password success
- `registration` - Registration page
- `set-credential` - Set credential after OAuth

#### Main Shell (Bottom Navigation)
- `/home` - Home page (index 0)
- `/practice/skill-selection` - Skill selection (index 1)
- `/tutor` - Tutor mode entry (index 2)
- `/profile` - Profile overview (index 3)

#### Learning Flow
- `/learning/today` - Today's learning plan
- `/practice/question` - Practice question page
- `/practice/result` - Practice result page
- `/practice/session-complete` - Practice session complete
- `/practice/skill-selection` - Skill selection
- `/practice/history` - Practice history
- `/practice/session-resume` - Resume practice session

#### Progress & Mini Test
- `/progress` - Progress dashboard
- `/progress/skill` - Skill detail page
- `/progress/recommendations` - Recommendations page
- `/progress/mini-test/start` - Mini test start
- `/progress/mini-test` - Mini test question page
- `/progress/mini-test/result` - Mini test result

#### Tutor Mode
- `/tutor` - Tutor mode entry
- `/tutor/camera` - Camera capture
- `/tutor/text` - Text input
- `/tutor/ocr-confirmation` - OCR confirmation
- `/tutor/solution` - Solution step-by-step
- `/tutor/solution-complete` - Solution complete
- `/tutor/recent` - Recent problems list

#### Profile
- `/profile` - Profile overview
- `/profile/edit` - Edit profile
- `/profile/settings` - Settings
- `/profile/change-password` - Change password
- `/profile/about-help` - About & Help

### Route Guards & Redirects
- **Redirect logic:** Trong `goRouterProvider`, có `redirect` function
- **Startup flow:** 
  - Check onboarding status
  - Check login status
  - Redirect tới welcome/auth-entry/home tương ứng
- **Router state provider:** `routerStateProvider` quản lý state routing
- **Startup provider:** `appStartupProvider` xử lý initialization

### Deep Links
- **Chưa xác nhận:** Cần kiểm tra cấu hình deep link trong Android/iOS manifests

### Navigation Shell
- **Type:** `StatefulShellRoute.indexedStack`
- **Branches:** 4 branches (Home, Practice, Tutor, Profile)
- **UI:** `NavigationShell` widget với `BottomNavigationBar`
- **Labels:** 
  - Home (localized)
  - "Luyện tập" (hardcoded)
  - "Giải bài" (hardcoded)
  - Profile (localized)

---

## 4. MENU / TAB / NAVIGATION UI

### Bottom Navigation Bar
- **Location:** `NavigationShell` widget
- **Type:** `BottomNavigationBarType.fixed` (4 items)
- **Items:**
  1. **Home** (index 0)
     - Icon: `Icons.home`
     - Label: `context.locale.navigation_home`
  2. **Practice** (index 1)
     - Icon: `Icons.school`
     - Label: "Luyện tập" (hardcoded, không localized)
  3. **Tutor** (index 2)
     - Icon: `Icons.calculate`
     - Label: "Giải bài" (hardcoded, không localized)
  4. **Profile** (index 3)
     - Icon: `Icons.person`
     - Label: `context.locale.navigation_profile`

### Menu Mapping
- **Home branch:** `/home` → `HomePage`
- **Practice branch:** `/practice/skill-selection` → `SkillSelectionPage`
- **Tutor branch:** `/tutor` → `TutorModeEntryPage`
- **Profile branch:** `/profile` → `ProfileOverviewPage`

### Menu Conditions
- **Không có guard rõ ràng:** Bottom nav luôn hiển thị khi trong shell
- **Cần xác nhận:** Logic ẩn/hiện menu theo auth state

### Menu Bị Comment / Disable
- **Chưa phát hiện:** Cần xác nhận thêm

---

## 5. DANH SÁCH SCREEN / FLOW

### Screen Học Tập

#### Learning Plan
- **`TodayLearningPlanPage`** (`/learning/today`)
  - Hiển thị lộ trình học hôm nay
  - Có recommended chapter
  - Progress summary
  - Week progress section

#### Chapter Learning
- **`ChapterLearningCard`** (widget trong HomePage)
  - Hiển thị chapter được recommend
  - Progress indicator

#### Practice Flow
- **`SkillSelectionPage`** (`/practice/skill-selection`)
  - Chọn skill để luyện tập
  - Skill cards với mastery status
  
- **`PracticeQuestionPage`** (`/practice/question`)
  - Hiển thị câu hỏi luyện tập
  - Input câu trả lời
  - Timer (nếu có)
  
- **`PracticeResultPage`** (`/practice/result`)
  - Hiển thị kết quả sau mỗi câu
  - Correct/incorrect indicator
  - Explanation
  
- **`PracticeSessionCompletePage`** (`/practice/session-complete`)
  - Tổng kết session
  - Mastery update
  - Next steps
  
- **`SessionResumePage`** (`/practice/session-resume`)
  - Resume session đang dở
  - Progress indicator
  - Continue/Cancel options
  
- **`PracticeHistoryPage`** (`/practice/history`)
  - Lịch sử luyện tập
  - Filter by skill (nếu có)

#### Mini Test Flow
- **`MiniTestStartPage`** (`/progress/mini-test/start`)
  - Bắt đầu mini test
  - Unlock celebration (nếu vừa unlock)
  - Instructions
  - Start button (chỉ enable khi unlocked)
  
- **`MiniTestQuestionPage`** (`/progress/mini-test`)
  - Câu hỏi mini test
  - Timer widget
  - Answer options
  - Navigation giữa các câu
  
- **`MiniTestResultPage`** (`/progress/mini-test/result`)
  - Kết quả mini test
  - Score
  - Statistics
  - Recommendations

#### Progress & Skill Detail
- **`ProgressDashboardPage`** (`/progress`)
  - Dashboard tổng quan
  - Mastery levels
  - Recent practice
  - Weak skills
  - Recommendations
  
- **`SkillDetailPage`** (`/progress/skill`)
  - Chi tiết skill
  - Mastery timeline
  - Prerequisites
  - Practice history
  - Mini test status
  
- **`RecommendationsPage`** (`/progress/recommendations`)
  - Gợi ý học tập
  - Skill recommendations

### Screen Tiến Độ / Kết Quả
- **Progress Dashboard:** Đã liệt kê ở trên
- **Skill Detail:** Đã liệt kê ở trên
- **Practice History:** Đã liệt kê ở trên
- **Mini Test Result:** Đã liệt kê ở trên

### Screen Phụ

#### Home
- **`HomePage`** (`/home`)
  - Progress summary card
  - Recommended chapter card
  - Week progress section
  - Empty state
  - Error state

#### Profile
- **`ProfileOverviewPage`** (`/profile`)
  - Profile information
  - Settings access
  - Edit profile
  
- **`EditProfilePage`** (`/profile/edit`)
  - Edit profile form
  - Avatar upload (có thể)
  
- **`SettingsPage`** (`/profile/settings`)
  - App settings
  - Language selection
  - Theme (nếu có)
  
- **`ChangePasswordPage`** (`/profile/change-password`)
  - Change password form
  
- **`AboutHelpPage`** (`/profile/about-help`)
  - About app
  - Help/Support

#### Authentication
- **`AuthEntryPage`** (`/auth-entry`)
  - Entry point cho auth flow
  - Login/Register options
  
- **`LoginPage`** (`/login`)
  - Login form
  - OAuth buttons (Google/Apple)
  - Forgot password link
  
- **`RegistrationPage`** (`registration`)
  - Registration form
  
- **`SetCredentialPage`** (`set-credential`)
  - Set username/password sau OAuth
  
- **Forgot Password Flow:**
  - `ResetPasswordPage` (`reset-password`)
  - `EmailVerificationPage` (`email-verification`)
  - `CreateNewPasswordPage` (`create-new-password`)
  - `ResetPasswordSuccessPage` (`reset-password-success`)

#### Onboarding
- **`WelcomePage`** (`/welcome`)
  - Welcome screen
  
- **`TrialStartPage`** (`/trial-start`)
  - Bắt đầu trial
  
- **`SelectGradeAndGoalsPage`** (`/select-grade-and-goals`)
  - Chọn lớp (6 hoặc 7)
  - Chọn mục tiêu học tập
  
- **`TrialStatusPage`** (`/trial-status`)
  - Trạng thái trial
  
- **`TrialExpiryPage`** (`/trial-expiry`)
  - Trial hết hạn
  
- **`OtpVerificationPage`** (`/otp-verification`)
  - Xác thực OTP cho parent linking
  
- **`LinkingSuccessPage`** (`/linking-success`)
  - Thành công liên kết phụ huynh
  
- **`OnboardingPage`** (`/onboarding`)
  - Onboarding page (có thể legacy)

#### Tutor Mode
- **`TutorModeEntryPage`** (`/tutor`)
  - Entry point tutor mode
  - Chọn camera hoặc text input
  
- **`CameraCapturePage`** (`/tutor/camera`)
  - Chụp ảnh bài Toán
  - Camera preview
  
- **`TextInputPage`** (`/tutor/text`)
  - Nhập văn bản bài Toán
  - Math symbols toolbar
  
- **`OcrConfirmationPage`** (`/tutor/ocr-confirmation`)
  - Xác nhận OCR text
  
- **`SolutionStepByStepPage`** (`/tutor/solution`)
  - Hiển thị lời giải từng bước
  - Step navigation
  
- **`SolutionCompletePage`** (`/tutor/solution-complete`)
  - Hoàn thành giải bài
  
- **`RecentProblemsListPage`** (`/tutor/recent`)
  - Danh sách bài đã giải gần đây

#### Splash
- **`SplashPage`** (`/splash`)
  - Splash screen
  - Startup loading

### Screen Demo / Placeholder / Test
- **Chưa xác định rõ:** Cần kiểm tra thêm các screen có comment "demo", "test", "placeholder"

---

## 6. LOGIC NGHIỆP VỤ TRONG STUDENT APP (RẤT QUAN TRỌNG)

### Logic Suy Luận Trạng Thái Học Tập

#### Chapter Completion / In-Progress
- **Nguồn dữ liệu:** Từ API `getProgressDashboard`, `getChapterProgress`
- **Entity:** `ChapterProgressEntity`
- **Model:** `ChapterProgressModel`
- **Provider:** `ChapterProgressProvider` (trong `progress_provider.dart`)
- **Logic frontend:** 
  - Hiển thị trạng thái từ API response
  - **Cần xác nhận:** Frontend có tự tính toán completion hay chỉ hiển thị từ backend

#### Skill Mastery
- **Nguồn dữ liệu:** Từ API `getSkillDetail`, `getProgressDashboard`
- **Entity:** `SkillDetailEntity`
- **Model:** `SkillDetailModel`
- **Provider:** `SkillDetailProvider`, `ProgressDashboardProvider`
- **UI hiển thị:**
  - `MasteryCircle` widget: Màu xanh cho "mastered"
  - `SkillCard` widget: Case 'mastered' với styling đặc biệt
  - `SkillDetailPage`: Hiển thị mastery status với case 'mastered'
- **Logic frontend:**
  - **Cần xác nhận:** Frontend có tự tính mastery hay chỉ hiển thị từ backend

#### Mini Test Unlock Logic
- **Location:** `MiniTestStartPage`
- **Logic:**
  - Check `isUnlocked` từ API response
  - Hiển thị `UnlockCelebrationCard` nếu vừa unlock
  - Disable start button nếu `!isUnlocked`
  - Error handling: Check message chứa "not unlocked"
- **Config:** `MiniTestConfig.defaultRequiredPracticeCount = 10` (minimum practice để unlock)
- **Cần xác nhận:** Logic unlock được tính ở backend hay frontend có tham gia

### Logic Quyết Định Hành Động

#### Cho Làm Bài Hay Không
- **Practice:**
  - **Skill Selection:** Không có guard rõ ràng, user có thể chọn skill
  - **Cần xác nhận:** Có logic check prerequisite skills không
  
- **Mini Test:**
  - **Unlock check:** `isUnlocked` từ API
  - **Start button:** Chỉ enable khi `isUnlocked && !_isStarting`
  - **Logic:** Frontend disable button, nhưng unlock logic từ backend

#### Cho Xem Lời Giải Hay Không
- **Practice Result:**
  - **Cần xác nhận:** Logic hiển thị explanation từ API response
  - **Không rõ:** Có điều kiện nào ẩn explanation không
  
- **Tutor Mode:**
  - **Solution:** Luôn hiển thị sau khi submit
  - **Không có guard:** User có thể xem solution bất cứ lúc nào sau giải bài

### Logic Frontend Tự "Điều Khiển Flow Học"

#### Learning Plan Utils
- **File:** `learning_plan_utils.dart`
- **Function:** `calculateTotalQuestionsForLearningPlan(int? difficultyLevel)`
- **Logic:**
  - Difficulty 1-2: 10 questions
  - Difficulty 3-4: 8 questions
  - Difficulty 5: 5 questions
  - Default: 10 questions
- **⚠️ QUAN TRỌNG:** Đây là logic frontend tự quyết định số câu hỏi dựa trên difficulty level

#### Practice Session Management
- **Provider:** `SessionManagementProvider`, `SessionProvider`
- **Logic:**
  - Resume session logic
  - Track completed questions / total questions
  - Progress calculation: `completedQuestions / totalQuestions`
- **Cần xác nhận:** Logic này có phối hợp với backend hay frontend tự quản lý

#### Difficulty Adjustment
- **Cần xác nhận:** Frontend có tự điều chỉnh difficulty hay chỉ nhận từ backend

#### Mastery Calculation
- **Cần xác nhận:** Frontend có tự tính mastery hay chỉ hiển thị từ backend

### Logic Khác

#### Trial Status
- **Provider:** `TrialProvider`
- **Logic:** Quản lý trial status, expiry
- **Cần xác nhận:** Logic expiry check ở frontend hay backend

#### Router Decision Logic
- **File:** `router_state_provider.dart`
- **Function:** `decideNextRoute()`
- **Logic:**
  - Check `isOnboarded` → go to welcome nếu chưa
  - Check `isLoggedIn` → go to home nếu đã login, auth-entry nếu chưa
- **⚠️ QUAN TRỌNG:** Frontend tự quyết định routing dựa trên local state (onboarding, login)

#### Weak Skills
- **Provider:** `WeakSkillsProvider`
- **Logic:** Fetch weak skills từ API
- **Cần xác nhận:** Logic xác định "weak" ở backend hay frontend

---

## 7. STATE MANAGEMENT & DATA FLOW

### State Management Pattern
- **Framework:** Riverpod với code generation
- **Pattern:** Provider-based state management
- **Code generation:** Tất cả providers có `.g.dart` files

### Các State Chính Được Quản Lý

#### Application State
- **`appStartupProvider`** (keepAlive: true)
  - Initialize app
  - Firebase setup
  - Device ID
  - Localization
  
- **`localizationProvider`**
  - Current locale
  - Set locale
  
- **`routerStateProvider`** (keepAlive: true)
  - Current route state
  - Route decision logic
  
- **`logoutProvider`**
  - Logout state
  - Navigation sau logout

#### Authentication State
- **`loginProvider`** (trong `authentication/login/riverpod/`)
  - Login state
  - Login action
  
- **`oauthProvider`** (trong `authentication/login/riverpod/`)
  - OAuth state
  - OAuth actions
  
- **`registrationProvider`** (trong `authentication/registration/riverpod/`)
  - Registration state

#### Onboarding State
- **`gradeProvider`**
  - Selected grade
  
- **`learningGoalProvider`**
  - Selected learning goals
  
- **`trialProvider`**
  - Trial status
  - Trial actions
  
- **`otpProvider`**
  - OTP verification state

#### Learning State
- **`learningPlanProvider`**
  - Today's learning plan
  - Load/refresh actions

#### Practice State
- **`practiceProvider`** (`PracticeSubmission`, `PracticeHistory`)
  - Submit practice
  - Practice history
  
- **`questionProvider`**
  - Current question state
  
- **`sessionProvider`**
  - Practice session state
  
- **`sessionManagementProvider`**
  - Session management
  - Resume session
  
- **`weakSkillsProvider`**
  - Weak skills list

#### Progress State
- **`progressProvider`** (`ProgressDashboard`, `SkillDetail`, `WeakSkills`, `Recommendations`, `ChapterProgress`)
  - Progress dashboard
  - Skill detail
  - Weak skills
  - Recommendations
  - Chapter progress
  
- **`miniTestProvider`**
  - Mini test state
  - Start/submit test
  
- **`practiceSessionProvider`**
  - Practice session history

#### Tutor State
- **`tutorProvider`**
  - Tutor mode state
  - Submit problem
  
- **`imageUploadProvider`**
  - Image upload state

#### Profile State
- **`profileProvider`**
  - Profile data
  - Update profile
  
- **`settingsProvider`**
  - Settings state
  
- **`passwordProvider`**
  - Change password state

### State Local vs Global
- **Global:** Providers với `keepAlive: true` (router, startup)
- **Local:** Feature-specific providers (auto-dispose khi không dùng)
- **Pattern:** Riverpod auto-dispose cho hầu hết providers

### Cách State Được Update
- **Async operations:** Sử dụng `AsyncValue` (loading/data/error)
- **State updates:** 
  - `state = AsyncValue.loading()`
  - `state = AsyncValue.data(...)`
  - `state = AsyncValue.error(...)`
- **Reset methods:** Nhiều providers có `reset()` method

### Side-Effects
- **API calls:** Trong repository implementations
- **Navigation:** Sử dụng `context.go()`, `context.push()` từ GoRouter
- **Cache:** Sử dụng `CacheService` cho local storage
- **Logging:** Sử dụng `Log` utility

---

## 8. API USAGE & BACKEND INTERACTION

### API Client Setup
- **Base:** `RestClient` tại `lib/src/data/services/network/rest_client.dart`
- **Configuration:** 
  - Base URL từ `Env.apiBaseUrl`
  - Interceptors: Token manager
  - Logging: PrettyDioLogger

### Danh sách API Services (15 services)

#### Authentication
- **`AuthService`**
  - Endpoints: Login, Register, OAuth login, Set credential
  - Repository: `AuthenticationRepositoryImpl`

#### Learning
- **`LearningService`**
  - Endpoint: `GET /api/learning/today`
  - Repository: `LearningRepositoryImpl`

#### Practice
- **`PracticeService`**
  - Endpoints: Submit practice, Get practice history
  - Repository: `PracticeRepositoryImpl`

- **`PracticeSessionService`**
  - Endpoints: Practice session management
  - Repository: `PracticeSessionRepositoryImpl`

#### Progress
- **`ProgressService`**
  - Endpoints: Progress dashboard, Skill detail, Chapter progress, Weak skills, Recommendations
  - Repository: `ProgressRepositoryImpl`

#### Mini Test
- **`MiniTestService`**
  - Endpoints: Start mini test, Submit mini test
  - Repository: `MiniTestRepositoryImpl`

#### Tutor
- **`TutorService`**
  - Endpoints: Solve from image, Solve from text
  - Repository: `TutorRepositoryImpl`

#### Image Upload
- **`ImageUploadService`**
  - Endpoint: Upload image
  - Repository: `ImageUploadRepositoryImpl`

#### Profile
- **`ProfileService`**
  - Endpoints: Get profile, Update profile
  - Repository: `ProfileRepositoryImpl`

#### Settings
- **`SettingsService`**
  - Endpoints: Get settings, Update settings
  - Repository: `SettingsRepositoryImpl`

#### Password
- **`PasswordService`**
  - Endpoints: Change password, Reset password
  - Repository: `PasswordRepositoryImpl`

#### Student
- **`StudentService`**
  - Endpoints: Student-related operations
  - Repository: (cần xác nhận)

#### Linking
- **`LinkingService`**
  - Endpoints: Request OTP, Verify OTP
  - Repository: `ParentLinkingRepositoryImpl`

#### Onboarding
- **`TrialService`** (có thể)
  - Endpoints: Trial operations
  - Repository: `TrialRepositoryImpl`

### Context Gọi API

#### Screen Level
- **HomePage:** Gọi `learningPlanProvider.loadTodayPlan()`
- **PracticeQuestionPage:** Gọi `practiceProvider.submitPractice()`
- **ProgressDashboardPage:** Gọi `progressProvider.loadDashboard()`
- **MiniTestStartPage:** Gọi API để check unlock status
- **TutorModeEntryPage:** Gọi `tutorProvider` để submit problem

#### Provider Level
- **Tất cả providers:** Gọi API thông qua repository
- **Pattern:** Provider → Repository → Service → API

### Mock Data / Fake Data / Hard-coded Data

#### Mock Service
- **Location:** `lib/src/data/services/mock/` (1 file)
- **Cần xác nhận:** Mục đích và usage

#### Hard-coded Data
- **Mini Test Config:** 
  - `defaultTotalQuestions = 6`
  - `defaultTimeLimitMinutes = 10`
  - `defaultPassingScore = 70`
  - `defaultRequiredPracticeCount = 10`
- **Learning Plan Utils:**
  - Question count mapping (10/8/5) dựa trên difficulty
- **Navigation Labels:**
  - "Luyện tập", "Giải bài" (hardcoded, không localized)
- **HomePage Messages:**
  - Positive messages dựa trên mastery level (hardcoded Vietnamese)

### Error Handling Strategy
- **Base:** `Result<T>` pattern với `isSuccess`, `getErrorMessage()`
- **Exception:** `BaseException` với Freezed
- **Failure:** `Failure` với Freezed
- **UI:** `ErrorMessageMapper` để map error thành user-friendly message
- **Widgets:** `ErrorStateWidget` cho error display

### Retry / Cache
- **Cache:** `CacheService` với `SharedPreferences`
- **Cache keys:** `CacheKey` enum (deviceId, etc.)
- **Retry:** Chưa thấy retry logic rõ ràng, cần xác nhận

---

## 9. AUTH / ROLE / GUARD

### Login Flow
- **Entry:** `AuthEntryPage` → `LoginPage`
- **Methods:**
  - Username/Password login
  - Google OAuth (`google_sign_in`)
  - Apple OAuth (`sign_in_with_apple`)
- **Provider:** `loginProvider`, `oauthProvider`
- **Repository:** `AuthenticationRepositoryImpl`
- **Service:** `AuthService`

### Token Storage
- **Location:** `lib/src/data/services/network/interceptor/token_manager.dart`
- **Storage:** Có thể dùng `SharedPreferences` hoặc `CacheService`
- **Cần xác nhận:** Cơ chế lưu token cụ thể

### Auth Guard
- **Router redirect:** Trong `goRouterProvider.redirect()`
- **Logic:**
  - Check `isOnboarded` → redirect to welcome
  - Check `isLoggedIn` → redirect to home hoặc auth-entry
- **Use cases:** `GetOnboardingStatusUseCase`, `GetUserLoginStatusUseCase`
- **Repository:** `RouterRepositoryImpl` (check local storage)

### Logic Xác Định Student / Quyền Truy Cập Screen
- **Onboarding check:** `isOnboardingCompleted()` từ `RouterRepository`
- **Login check:** `isUserLoggedIn()` từ `RouterRepository`
- **Storage:** Local storage (SharedPreferences) để lưu trạng thái
- **Cần xác nhận:** Có role-based access control không, hay chỉ check login/onboarding

### OAuth Flow
- **Google Sign-In:** `google_sign_in` package
- **Apple Sign-In:** `sign_in_with_apple` package
- **Post-OAuth:** `SetCredentialPage` để set username/password sau OAuth
- **Service:** OAuth services trong `lib/src/data/services/oauth/` (5 files)

---

## 10. UI / UX & CODE QUALITY

### UI Pattern
- **Design system:** Material Design (`uses-material-design: true`)
- **Theme:** Custom theme tại `lib/src/presentation/core/theme/` (18 files)
- **Dark mode:** Có support (`darkTheme: context.darkTheme`)
- **Theme mode:** `ThemeMode.system` (theo system)

### Reusable Widgets
- **Location:** `lib/src/presentation/core/widgets/` (11 files)
- **Widgets:**
  - `AppStartupWidget` (startup handling)
  - `NavigationShell` (bottom navigation)
  - `EmptyStateWidget`
  - `ErrorStateWidget`
  - `SkeletonList` (loading skeleton)
  - Typography widgets
  - (cần liệt kê đầy đủ)

### Feature-Specific Widgets
- **Learning:** `ChapterLearningCard`, `ProgressIndicator`
- **Practice:** `SkillCard`, `PracticeCard`, `ResultIndicator`, `MasteryProgressBar`, `DifficultyBadge`, `AdaptiveNotification`
- **Progress:** `MasteryCircle`, `MasteryTimeline`, `ProgressChart`, `SkillCard`, `WeakSkillCard`, `RecommendationItemCard`, `TestTimerWidget`, `TestQuestionCard`, `TestAnswerOption`, `UnlockCelebrationCard`, và nhiều widgets khác
- **Tutor:** `MathSymbolsToolbar`, `SolutionStepCard`

### Naming Convention
- **Files:** snake_case (ví dụ: `learning_plan_provider.dart`)
- **Classes:** PascalCase (ví dụ: `LearningPlanProvider`)
- **Variables:** camelCase (ví dụ: `learningPlan`)
- **Constants:** (cần xác nhận pattern)

### Comments / TODO
- **Grep timeout:** Không thể search TODO/FIXME do timeout
- **Cần xác nhận:** Số lượng và nội dung TODO comments

### Dead Widget / Screen Không Dùng
- **Chưa xác định:** Cần phân tích usage để xác định dead code
- **OnboardingPage:** Có thể legacy (có comment "New flow: Go to Welcome instead of old onboarding" trong router)

### Code Quality Tools
- **Linter:** `flutter_lints` 6.0.0
- **Custom lint:** `custom_lint` + `flutter_guardian`
- **Riverpod lint:** `riverpod_lint`
- **Analysis:** `analysis_options.yaml` với strict settings
- **Formatter:** Page width 80 chars

### Localization
- **Framework:** Flutter localization với ARB files
- **Languages:** Vietnamese (vi), English (en)
- **Usage:** `context.locale.xxx` extension
- **Coverage:** 
  - ✅ Một số labels đã localized
  - ⚠️ Một số labels hardcoded ("Luyện tập", "Giải bài")

---

## 11. BUILD, FLAVOR & CONFIG

### Build Mode
- **Debug:** Mặc định khi `flutter run`
- **Release:** `flutter run --release` hoặc `flutter build`

### Flavor / Environment
- **Config:** `lib/src/core/config/env.dart`
- **Environment variable:** `ENVIRONMENT` (development/production)
- **API URL:**
  - Production: `https://apitutor.dienluc.vn`
  - Development: `https://apitutor.dienluc.vn` (hiện tại giống production)
- **Override:** Có thể override bằng `--dart-define=API_BASE_URL=<url>`
- **Priority:**
  1. `API_BASE_URL` từ `--dart-define`
  2. Auto-select dựa trên `ENVIRONMENT`
  3. Default to development URL

### Environment Config
- **File:** `lib/src/core/config/env.dart`
- **Properties:**
  - `apiBaseUrl` (dynamic)
  - `appName = 'Tutor'`
  - `appVersion = '1.0.0'`
  - `environment` (development/production)
  - `isDevelopment`, `isProduction` helpers

### Feature Flags
- **Chưa thấy:** Không có feature flag system rõ ràng
- **Cần xác nhận:** Có sử dụng feature flags không

### Build Configuration Files
- **Android:** `android/app/build.gradle` (cần đọc để xác nhận config)
- **iOS:** `ios/Runner/Info.plist` (cần đọc để xác nhận config)
- **Build config:** `build.yaml` (12 lines)

### Code Generation
- **Build runner:** `dart run build_runner build --delete-conflicting-outputs`
- **Watch mode:** `dart run build_runner watch`
- **Generated files:** 
  - `.g.dart` (Riverpod, Retrofit, Freezed)
  - `.mapper.dart` (Dart mappable)
  - `.freezed.dart` (Freezed)

---

## 🔎 TỔNG KẾT KHẢO SÁT

### Các Feature / Flow Lớn Đang Tồn Tại

#### 1. Authentication & Onboarding Flow
- **Onboarding:** Welcome → Trial → Grade/Goals → OTP (parent linking)
- **Authentication:** Login (username/password, OAuth), Registration, Forgot password
- **State:** Trial management, OTP verification

#### 2. Learning Plan Flow
- **Today's Plan:** Hiển thị recommended chapter, progress summary
- **Chapter Learning:** Chapter cards với progress
- **Week Progress:** Streak, exercises done

#### 3. Practice Flow
- **Skill Selection:** Chọn skill để luyện tập
- **Practice Session:** Questions → Results → Session Complete
- **Session Management:** Resume session, History
- **Weak Skills:** Hiển thị weak skills

#### 4. Mini Test Flow
- **Unlock Logic:** Check unlock status (10 practice questions required)
- **Test Flow:** Start → Questions (với timer) → Results
- **Celebration:** Unlock celebration card

#### 5. Progress Tracking
- **Dashboard:** Overall mastery, recent practice, weak skills, recommendations
- **Skill Detail:** Mastery timeline, prerequisites, practice history
- **Recommendations:** Learning recommendations

#### 6. Tutor Mode Flow
- **Entry:** Chọn camera hoặc text input
- **Input:** Camera capture hoặc text input với math symbols toolbar
- **OCR:** Confirmation step
- **Solution:** Step-by-step solution display
- **History:** Recent problems list

#### 7. Profile & Settings
- **Profile:** View, Edit, Avatar upload (có thể)
- **Settings:** App settings, Language, Theme
- **Password:** Change password
- **About/Help:** About page

### Khu Vực Code Nhiều Logic

#### 1. Learning Plan Utils
- **File:** `learning_plan_utils.dart`
- **Logic:** Frontend tự tính số câu hỏi dựa trên difficulty (10/8/5)
- **⚠️ QUAN TRỌNG:** Business logic ở frontend

#### 2. Router Decision Logic
- **File:** `router_state_provider.dart`
- **Logic:** Frontend tự quyết định routing (onboarding → login → home)
- **⚠️ QUAN TRỌNG:** Navigation logic ở frontend

#### 3. Mini Test Unlock Logic
- **File:** `mini_test_start_page.dart`
- **Logic:** Check unlock status, disable/enable start button
- **Config:** `MiniTestConfig.defaultRequiredPracticeCount = 10`
- **⚠️ QUAN TRỌNG:** Unlock logic có thể có phần frontend

#### 4. Practice Session Management
- **Files:** `session_provider.dart`, `session_management_provider.dart`
- **Logic:** Track progress, resume session, completed/total questions
- **Cần xác nhận:** Logic này có phối hợp với backend hay frontend tự quản lý

#### 5. Mastery Display Logic
- **Files:** `skill_detail_page.dart`, `skill_card.dart`, `mastery_circle.dart`
- **Logic:** Hiển thị mastery status với case 'mastered'
- **Cần xác nhận:** Logic tính mastery ở đâu

### Khu Vực Demo / Thử Nghiệm

#### 1. Mock Service
- **Location:** `lib/src/data/services/mock/` (1 file)
- **Cần xác nhận:** Mục đích và usage

#### 2. OnboardingPage (Legacy?)
- **Route:** `/onboarding`
- **Comment:** "New flow: Go to Welcome instead of old onboarding"
- **Status:** Có thể là legacy code

### Danh Sách Điểm Chưa Rõ Cần Confirm

#### 1. Business Logic Location
- ❓ **Chapter completion:** Frontend tự tính hay chỉ hiển thị từ backend?
- ❓ **Skill mastery:** Frontend tự tính hay chỉ hiển thị từ backend?
- ❓ **Mini test unlock:** Logic unlock hoàn toàn ở backend hay frontend có tham gia?
- ❓ **Difficulty adjustment:** Frontend có tự điều chỉnh difficulty không?
- ❓ **Practice prerequisite:** Có logic check prerequisite skills không?

#### 2. Code Usage
- ❓ **Mock service:** Mục đích và usage?
- ❓ **OnboardingPage:** Còn được dùng không?
- ❓ **Dead code:** Có widget/screen nào không được dùng không?

#### 3. Configuration
- ❓ **Feature flags:** Có sử dụng feature flags không?
- ❓ **Deep links:** Có cấu hình deep links không?
- ❓ **Token storage:** Cơ chế lưu token cụ thể?
- ❓ **Retry logic:** Có retry logic cho API calls không?

#### 4. Localization
- ❓ **Coverage:** Bao nhiêu % code đã được localized?
- ❓ **Hardcoded strings:** Còn strings nào hardcoded không?

#### 5. Build & Deployment
- ❓ **Android config:** Min SDK, target SDK, permissions?
- ❓ **iOS config:** Info.plist settings, capabilities?
- ❓ **Flavors:** Có sử dụng flavors (dev/staging/prod) không?

#### 6. Testing
- ❓ **Test coverage:** Có test files không? Coverage bao nhiêu?
- ❓ **Test structure:** Unit/widget/integration tests?

---

## LƯU Ý

⚠️ **File reads timeout:** Một số file lớn không thể đọc được do timeout, cần đọc thủ công để bổ sung thông tin.

⚠️ **Grep timeout:** Không thể search TODO/FIXME comments do timeout.

⚠️ **Cần xác nhận:** Nhiều điểm cần xác nhận bằng cách đọc code hoặc hỏi team.

---

**Kết thúc báo cáo khảo sát**

