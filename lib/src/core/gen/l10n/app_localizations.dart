import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @language_vietnamese.
  ///
  /// In en, this message translates to:
  /// **'Tiếng Việt'**
  String get language_vietnamese;

  /// No description provided for @language_english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language_english;

  /// No description provided for @navigation_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navigation_home;

  /// No description provided for @navigation_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navigation_profile;

  /// No description provided for @auth_login_title.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get auth_login_title;

  /// No description provided for @auth_login_button.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get auth_login_button;

  /// No description provided for @auth_login_remember_me.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get auth_login_remember_me;

  /// No description provided for @auth_login_forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get auth_login_forgot_password;

  /// No description provided for @auth_signup_title.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get auth_signup_title;

  /// No description provided for @auth_signup_button.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get auth_signup_button;

  /// No description provided for @auth_signin_button.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get auth_signin_button;

  /// No description provided for @auth_forgot_password_title.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get auth_forgot_password_title;

  /// No description provided for @auth_forgot_password_description.
  ///
  /// In en, this message translates to:
  /// **'Enter the email associated with your account and we\'ll send an email with instructions to reset your password.'**
  String get auth_forgot_password_description;

  /// No description provided for @auth_forgot_password_button.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get auth_forgot_password_button;

  /// No description provided for @auth_forgot_password_back_to_login.
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get auth_forgot_password_back_to_login;

  /// No description provided for @auth_reset_password_title.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get auth_reset_password_title;

  /// No description provided for @auth_reset_password_new_password.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get auth_reset_password_new_password;

  /// No description provided for @auth_reset_password_confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get auth_reset_password_confirm_password;

  /// No description provided for @auth_reset_password_hint.
  ///
  /// In en, this message translates to:
  /// **'Your new password must be different from previous used passwords.'**
  String get auth_reset_password_hint;

  /// No description provided for @auth_reset_password_button.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get auth_reset_password_button;

  /// No description provided for @auth_reset_password_success.
  ///
  /// In en, this message translates to:
  /// **'Password Changed Successfully'**
  String get auth_reset_password_success;

  /// No description provided for @auth_reset_password_success_message.
  ///
  /// In en, this message translates to:
  /// **'Your password has been changed successfully.'**
  String get auth_reset_password_success_message;

  /// No description provided for @auth_account_dont_have.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get auth_account_dont_have;

  /// No description provided for @auth_account_already_have.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get auth_account_already_have;

  /// No description provided for @auth_verification_check_mail.
  ///
  /// In en, this message translates to:
  /// **'Check your mail'**
  String get auth_verification_check_mail;

  /// Verification code instruction with email placeholder
  ///
  /// In en, this message translates to:
  /// **'Please enter 4 digit code sent to your mail {email}.'**
  String auth_verification_enter_code(String email);

  /// No description provided for @auth_verification_didnt_get_code.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t get a code? '**
  String get auth_verification_didnt_get_code;

  /// No description provided for @auth_verification_resend.
  ///
  /// In en, this message translates to:
  /// **'Click to resend'**
  String get auth_verification_resend;

  /// No description provided for @auth_verification_did_not_receive.
  ///
  /// In en, this message translates to:
  /// **'Did not receive the email? Check your spam filter. or '**
  String get auth_verification_did_not_receive;

  /// No description provided for @auth_verification_try_another_email.
  ///
  /// In en, this message translates to:
  /// **'try another email address'**
  String get auth_verification_try_another_email;

  /// No description provided for @common_field_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get common_field_email;

  /// No description provided for @common_field_email_address.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get common_field_email_address;

  /// No description provided for @common_field_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get common_field_password;

  /// No description provided for @common_field_first_name.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get common_field_first_name;

  /// No description provided for @common_field_last_name.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get common_field_last_name;

  /// No description provided for @common_button_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get common_button_continue;

  /// No description provided for @common_button_ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get common_button_ok;

  /// No description provided for @common_button_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get common_button_cancel;

  /// No description provided for @common_button_close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get common_button_close;

  /// No description provided for @common_button_back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get common_button_back;

  /// No description provided for @common_button_get_started.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get common_button_get_started;

  /// No description provided for @common_button_logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get common_button_logout;

  /// No description provided for @common_button_start_learning.
  ///
  /// In en, this message translates to:
  /// **'Start Learning'**
  String get common_button_start_learning;

  /// No description provided for @common_button_load_more.
  ///
  /// In en, this message translates to:
  /// **'Load More'**
  String get common_button_load_more;

  /// No description provided for @validation_required.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get validation_required;

  /// No description provided for @validation_email_required.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get validation_email_required;

  /// No description provided for @validation_password_required.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get validation_password_required;

  /// No description provided for @validation_email_invalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid email address'**
  String get validation_email_invalid;

  /// Minimum length validation error
  ///
  /// In en, this message translates to:
  /// **'This field must be at least {min} characters long'**
  String validation_length_min(int min);

  /// Maximum length validation error
  ///
  /// In en, this message translates to:
  /// **'This field must be at most {max} characters long'**
  String validation_length_max(int max);

  /// Password minimum length validation
  ///
  /// In en, this message translates to:
  /// **'Password must be at least {minLength} characters'**
  String validation_password_min_length(String minLength);

  /// No description provided for @validation_password_number.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one number'**
  String get validation_password_number;

  /// No description provided for @validation_password_lowercase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one lowercase letter'**
  String get validation_password_lowercase;

  /// No description provided for @validation_password_uppercase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one uppercase letter'**
  String get validation_password_uppercase;

  /// No description provided for @validation_password_special_char.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one special character'**
  String get validation_password_special_char;

  /// No description provided for @error_network_connection.
  ///
  /// In en, this message translates to:
  /// **'Cannot connect. Please check your internet.'**
  String get error_network_connection;

  /// No description provided for @error_network_timeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timeout. Please try again.'**
  String get error_network_timeout;

  /// No description provided for @error_network_generic.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again.'**
  String get error_network_generic;

  /// No description provided for @error_auth_unauthorized.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please login again.'**
  String get error_auth_unauthorized;

  /// No description provided for @error_system_internal.
  ///
  /// In en, this message translates to:
  /// **'System error. Please try again later.'**
  String get error_system_internal;

  /// No description provided for @error_resource_not_found.
  ///
  /// In en, this message translates to:
  /// **'Not found.'**
  String get error_resource_not_found;

  /// No description provided for @error_generic.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get error_generic;

  /// No description provided for @practice_question_title.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get practice_question_title;

  /// Question counter with current and total
  ///
  /// In en, this message translates to:
  /// **'Question {current}/{total}'**
  String practice_question_counter(int current, int total);

  /// Practice progress with current and total
  ///
  /// In en, this message translates to:
  /// **'{current}/{total} questions done'**
  String practice_question_progress(int current, int total);

  /// No description provided for @practice_question_select_answer.
  ///
  /// In en, this message translates to:
  /// **'Select answer:'**
  String get practice_question_select_answer;

  /// No description provided for @practice_question_enter_answer.
  ///
  /// In en, this message translates to:
  /// **'Enter answer:'**
  String get practice_question_enter_answer;

  /// No description provided for @practice_question_answer_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your answer'**
  String get practice_question_answer_hint;

  /// No description provided for @practice_question_check.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get practice_question_check;

  /// No description provided for @practice_question_hint.
  ///
  /// In en, this message translates to:
  /// **'💡 Hint'**
  String get practice_question_hint;

  /// Skill label with skill name
  ///
  /// In en, this message translates to:
  /// **'Skill: {skillName}'**
  String practice_question_skill_label(String skillName);

  /// No description provided for @practice_question_not_found.
  ///
  /// In en, this message translates to:
  /// **'Question not found'**
  String get practice_question_not_found;

  /// No description provided for @practice_question_load_error.
  ///
  /// In en, this message translates to:
  /// **'Cannot load question'**
  String get practice_question_load_error;

  /// No description provided for @practice_skill_selection_title.
  ///
  /// In en, this message translates to:
  /// **'Select Skill to Practice'**
  String get practice_skill_selection_title;

  /// No description provided for @practice_skill_selection_description.
  ///
  /// In en, this message translates to:
  /// **'You can select one of the following skills to improve'**
  String get practice_skill_selection_description;

  /// No description provided for @practice_skill_selection_info.
  ///
  /// In en, this message translates to:
  /// **'Select a skill to start practicing. The system will create exercises suitable for your level.'**
  String get practice_skill_selection_info;

  /// No description provided for @practice_skill_selection_no_weak_skills.
  ///
  /// In en, this message translates to:
  /// **'No weak skills. Great!'**
  String get practice_skill_selection_no_weak_skills;

  /// No description provided for @practice_skill_selection_load_error.
  ///
  /// In en, this message translates to:
  /// **'Cannot load skill list'**
  String get practice_skill_selection_load_error;

  /// No description provided for @practice_skill_selection_back_to_home.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get practice_skill_selection_back_to_home;

  /// No description provided for @practice_skill_status_weak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get practice_skill_status_weak;

  /// No description provided for @practice_skill_status_unstable.
  ///
  /// In en, this message translates to:
  /// **'Unstable'**
  String get practice_skill_status_unstable;

  /// No description provided for @practice_history_title.
  ///
  /// In en, this message translates to:
  /// **'Practice History'**
  String get practice_history_title;

  /// No description provided for @practice_history_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No practice sessions yet'**
  String get practice_history_empty_title;

  /// No description provided for @practice_history_empty_description.
  ///
  /// In en, this message translates to:
  /// **'Start learning to see your history here'**
  String get practice_history_empty_description;

  /// No description provided for @practice_history_load_error.
  ///
  /// In en, this message translates to:
  /// **'Cannot load history'**
  String get practice_history_load_error;

  /// Number of exercises
  ///
  /// In en, this message translates to:
  /// **'{count} exercises'**
  String practice_card_exercises(int count);

  /// Correct answers count
  ///
  /// In en, this message translates to:
  /// **'Correct: {count}'**
  String practice_card_correct(int count);

  /// Incorrect answers count
  ///
  /// In en, this message translates to:
  /// **'Incorrect: {count}'**
  String practice_card_incorrect(int count);

  /// Accuracy percentage
  ///
  /// In en, this message translates to:
  /// **'{accuracy}%'**
  String practice_card_accuracy(int accuracy);

  /// Mastery change percentage
  ///
  /// In en, this message translates to:
  /// **'Mastery: {change}%'**
  String practice_card_mastery(String change);

  /// Positive mastery change
  ///
  /// In en, this message translates to:
  /// **'Mastery: +{change}%'**
  String practice_card_mastery_positive(int change);

  /// Practice duration
  ///
  /// In en, this message translates to:
  /// **'Duration: {duration}'**
  String practice_card_duration(String duration);

  /// Duration in seconds only
  ///
  /// In en, this message translates to:
  /// **'{seconds}s'**
  String practice_card_duration_seconds(int seconds);

  /// Duration in minutes only
  ///
  /// In en, this message translates to:
  /// **'{minutes}p'**
  String practice_card_duration_minutes(int minutes);

  /// Duration in minutes and seconds
  ///
  /// In en, this message translates to:
  /// **'{minutes}p {seconds}s'**
  String practice_card_duration_minutes_seconds(int minutes, int seconds);

  /// Mastery level percentage
  ///
  /// In en, this message translates to:
  /// **'Mastery: {level}%'**
  String practice_history_mastery(int level);

  /// Duration in seconds
  ///
  /// In en, this message translates to:
  /// **'Duration: {seconds}s'**
  String practice_history_duration(int seconds);

  /// Difficulty label with level
  ///
  /// In en, this message translates to:
  /// **'Difficulty: {level}'**
  String difficulty_label(String level);

  /// No description provided for @difficulty_easy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get difficulty_easy;

  /// No description provided for @difficulty_medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get difficulty_medium;

  /// No description provided for @difficulty_hard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get difficulty_hard;

  /// No description provided for @difficulty_very_hard.
  ///
  /// In en, this message translates to:
  /// **'Very Hard'**
  String get difficulty_very_hard;

  /// No description provided for @difficulty_fair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get difficulty_fair;

  /// No description provided for @learning_today_title.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Learning'**
  String get learning_today_title;

  /// Learning difficulty label
  ///
  /// In en, this message translates to:
  /// **'Difficulty: {level}'**
  String learning_difficulty_label(String level);

  /// Estimated time in minutes
  ///
  /// In en, this message translates to:
  /// **'~{minutes} min'**
  String learning_skill_estimated_time(int minutes);

  /// No description provided for @auth_reset_password_create_new.
  ///
  /// In en, this message translates to:
  /// **'Create New Password'**
  String get auth_reset_password_create_new;

  /// No description provided for @auth_verification_enter_code_label.
  ///
  /// In en, this message translates to:
  /// **'Enter verification code'**
  String get auth_verification_enter_code_label;

  /// No description provided for @auth_forgot_password_enter_associated_email.
  ///
  /// In en, this message translates to:
  /// **'Enter the email associated with your account'**
  String get auth_forgot_password_enter_associated_email;

  /// No description provided for @onboarding_learn_flutter_title.
  ///
  /// In en, this message translates to:
  /// **'Learn Flutter'**
  String get onboarding_learn_flutter_title;

  /// No description provided for @onboarding_learn_flutter_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Build amazing apps'**
  String get onboarding_learn_flutter_subtitle;

  /// No description provided for @onboarding_learn_flutter_description.
  ///
  /// In en, this message translates to:
  /// **'Learn Flutter and build beautiful, fast apps for multiple platforms.'**
  String get onboarding_learn_flutter_description;

  /// No description provided for @onboarding_join_community_title.
  ///
  /// In en, this message translates to:
  /// **'Join Community'**
  String get onboarding_join_community_title;

  /// No description provided for @onboarding_join_community_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Connect with developers'**
  String get onboarding_join_community_subtitle;

  /// No description provided for @onboarding_join_community_description.
  ///
  /// In en, this message translates to:
  /// **'Join our community of developers and share your knowledge.'**
  String get onboarding_join_community_description;

  /// No description provided for @onboarding_build_deploy_title.
  ///
  /// In en, this message translates to:
  /// **'Build & Deploy'**
  String get onboarding_build_deploy_title;

  /// No description provided for @onboarding_build_deploy_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Ship your apps'**
  String get onboarding_build_deploy_subtitle;

  /// No description provided for @onboarding_build_deploy_description.
  ///
  /// In en, this message translates to:
  /// **'Build and deploy your apps to production with ease.'**
  String get onboarding_build_deploy_description;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
