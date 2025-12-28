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

  /// No description provided for @auth_forgot_password_enter_associated_email.
  ///
  /// In en, this message translates to:
  /// **'Enter the email associated with your account'**
  String get auth_forgot_password_enter_associated_email;

  /// No description provided for @auth_reset_password_title.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get auth_reset_password_title;

  /// No description provided for @auth_reset_password_create_new.
  ///
  /// In en, this message translates to:
  /// **'Create New Password'**
  String get auth_reset_password_create_new;

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

  /// No description provided for @auth_entry_title.
  ///
  /// In en, this message translates to:
  /// **'Choose Login Method'**
  String get auth_entry_title;

  /// No description provided for @auth_entry_divider_or.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get auth_entry_divider_or;

  /// No description provided for @auth_entry_manual_button.
  ///
  /// In en, this message translates to:
  /// **'Manual Login / Sign Up'**
  String get auth_entry_manual_button;

  /// No description provided for @auth_entry_no_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get auth_entry_no_account;

  /// No description provided for @auth_entry_manual_signup.
  ///
  /// In en, this message translates to:
  /// **'Manual Sign Up'**
  String get auth_entry_manual_signup;

  /// No description provided for @auth_login_error_invalid_credentials.
  ///
  /// In en, this message translates to:
  /// **'Username or password is incorrect. Please try again.'**
  String get auth_login_error_invalid_credentials;

  /// No description provided for @auth_oauth_error_student_not_found.
  ///
  /// In en, this message translates to:
  /// **'Student information not found'**
  String get auth_oauth_error_student_not_found;

  /// No description provided for @auth_registration_success_message.
  ///
  /// In en, this message translates to:
  /// **'Registration successful. Start your free trial!'**
  String get auth_registration_success_message;

  /// No description provided for @auth_registration_field_full_name.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get auth_registration_field_full_name;

  /// No description provided for @auth_registration_field_username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get auth_registration_field_username;

  /// No description provided for @auth_registration_field_confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get auth_registration_field_confirm_password;

  /// No description provided for @auth_registration_validation_full_name_required.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get auth_registration_validation_full_name_required;

  /// No description provided for @auth_registration_validation_username_required.
  ///
  /// In en, this message translates to:
  /// **'Please enter username'**
  String get auth_registration_validation_username_required;

  /// No description provided for @auth_registration_validation_username_format.
  ///
  /// In en, this message translates to:
  /// **'Username can only contain letters and numbers, case insensitive'**
  String get auth_registration_validation_username_format;

  /// No description provided for @auth_registration_validation_confirm_password_required.
  ///
  /// In en, this message translates to:
  /// **'Please confirm password'**
  String get auth_registration_validation_confirm_password_required;

  /// No description provided for @auth_registration_validation_password_mismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get auth_registration_validation_password_mismatch;

  /// No description provided for @auth_set_credential_title.
  ///
  /// In en, this message translates to:
  /// **'Set Login Credentials'**
  String get auth_set_credential_title;

  /// No description provided for @auth_set_credential_description.
  ///
  /// In en, this message translates to:
  /// **'Please set username and password to complete registration'**
  String get auth_set_credential_description;

  /// No description provided for @auth_set_credential_success_message.
  ///
  /// In en, this message translates to:
  /// **'Login credentials set successfully.'**
  String get auth_set_credential_success_message;

  /// Generic error message with error details
  ///
  /// In en, this message translates to:
  /// **'An error occurred: {error}'**
  String auth_set_credential_error_generic(String error);

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

  /// No description provided for @auth_verification_enter_code_label.
  ///
  /// In en, this message translates to:
  /// **'Enter verification code'**
  String get auth_verification_enter_code_label;

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

  /// No description provided for @validation_email_invalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid email address'**
  String get validation_email_invalid;

  /// No description provided for @validation_password_required.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get validation_password_required;

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

  /// No description provided for @practice_skill_selection_welcome_title.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Practice!'**
  String get practice_skill_selection_welcome_title;

  /// No description provided for @practice_skill_selection_welcome_description.
  ///
  /// In en, this message translates to:
  /// **'To get started, check out today\'s learning recommendations. The system will suggest the most suitable skills for you to practice.'**
  String get practice_skill_selection_welcome_description;

  /// No description provided for @practice_skill_selection_welcome_cta.
  ///
  /// In en, this message translates to:
  /// **'View Today\'s Learning Plan'**
  String get practice_skill_selection_welcome_cta;

  /// No description provided for @practice_skill_selection_welcome_tip_title.
  ///
  /// In en, this message translates to:
  /// **'Tip'**
  String get practice_skill_selection_welcome_tip_title;

  /// No description provided for @practice_skill_selection_welcome_tip_description.
  ///
  /// In en, this message translates to:
  /// **'Starting with the most basic skills will help you build a solid foundation. The system will automatically suggest suitable skills based on your progress.'**
  String get practice_skill_selection_welcome_tip_description;

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

  /// No description provided for @learning_plan_today_title.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Learning Plan'**
  String get learning_plan_today_title;

  /// No description provided for @learning_plan_progress_overview_title.
  ///
  /// In en, this message translates to:
  /// **'Progress Overview'**
  String get learning_plan_progress_overview_title;

  /// No description provided for @learning_plan_week_progress_title.
  ///
  /// In en, this message translates to:
  /// **'Week Progress'**
  String get learning_plan_week_progress_title;

  /// No description provided for @learning_plan_stat_total_skills.
  ///
  /// In en, this message translates to:
  /// **'Total Skills'**
  String get learning_plan_stat_total_skills;

  /// No description provided for @learning_plan_stat_mastered_skills.
  ///
  /// In en, this message translates to:
  /// **'Mastered Skills'**
  String get learning_plan_stat_mastered_skills;

  /// Week streak with number of days
  ///
  /// In en, this message translates to:
  /// **'{days} days streak'**
  String learning_plan_week_streak(int days);

  /// Number of exercises done this week
  ///
  /// In en, this message translates to:
  /// **'{count} exercises done'**
  String learning_plan_week_exercises_done(int count);

  /// No description provided for @learning_plan_focus_on_skills.
  ///
  /// In en, this message translates to:
  /// **'Focus on:'**
  String get learning_plan_focus_on_skills;

  /// No description provided for @learning_plan_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No learning plan today'**
  String get learning_plan_empty_title;

  /// No description provided for @learning_plan_empty_description.
  ///
  /// In en, this message translates to:
  /// **'Start learning to see your plan!'**
  String get learning_plan_empty_description;

  /// No description provided for @learning_plan_error_load_failed.
  ///
  /// In en, this message translates to:
  /// **'Cannot load learning plan'**
  String get learning_plan_error_load_failed;

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

  /// No description provided for @onboarding_welcome_title.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Tutor!'**
  String get onboarding_welcome_title;

  /// No description provided for @onboarding_welcome_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Personalized AI Math Tutor for you'**
  String get onboarding_welcome_subtitle;

  /// No description provided for @onboarding_welcome_trial_badge.
  ///
  /// In en, this message translates to:
  /// **'Free 7-day trial - Full features'**
  String get onboarding_welcome_trial_badge;

  /// No description provided for @onboarding_welcome_button_try_now.
  ///
  /// In en, this message translates to:
  /// **'Try Now'**
  String get onboarding_welcome_button_try_now;

  /// No description provided for @onboarding_welcome_button_learn_more.
  ///
  /// In en, this message translates to:
  /// **'Learn More'**
  String get onboarding_welcome_button_learn_more;

  /// No description provided for @onboarding_welcome_already_have_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get onboarding_welcome_already_have_account;

  /// No description provided for @onboarding_welcome_login_link.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get onboarding_welcome_login_link;

  /// No description provided for @onboarding_select_grade_title.
  ///
  /// In en, this message translates to:
  /// **'Select Grade'**
  String get onboarding_select_grade_title;

  /// No description provided for @onboarding_select_grade_header.
  ///
  /// In en, this message translates to:
  /// **'What grade are you in?'**
  String get onboarding_select_grade_header;

  /// No description provided for @onboarding_select_grade_button_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get onboarding_select_grade_button_retry;

  /// No description provided for @onboarding_grade_6_title.
  ///
  /// In en, this message translates to:
  /// **'Grade 6'**
  String get onboarding_grade_6_title;

  /// No description provided for @onboarding_grade_6_description.
  ///
  /// In en, this message translates to:
  /// **'Grade 6 Math Program'**
  String get onboarding_grade_6_description;

  /// No description provided for @onboarding_grade_7_title.
  ///
  /// In en, this message translates to:
  /// **'Grade 7'**
  String get onboarding_grade_7_title;

  /// No description provided for @onboarding_grade_7_description.
  ///
  /// In en, this message translates to:
  /// **'Grade 7 Math Program'**
  String get onboarding_grade_7_description;

  /// No description provided for @onboarding_select_goal_title.
  ///
  /// In en, this message translates to:
  /// **'Learning Goals'**
  String get onboarding_select_goal_title;

  /// No description provided for @onboarding_select_goal_header.
  ///
  /// In en, this message translates to:
  /// **'What are your learning goals?'**
  String get onboarding_select_goal_header;

  /// No description provided for @onboarding_select_goal_button_start.
  ///
  /// In en, this message translates to:
  /// **'Start Learning'**
  String get onboarding_select_goal_button_start;

  /// No description provided for @onboarding_select_goal_button_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get onboarding_select_goal_button_retry;

  /// No description provided for @onboarding_select_goal_semantics_selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get onboarding_select_goal_semantics_selected;

  /// No description provided for @onboarding_select_goal_semantics_not_selected.
  ///
  /// In en, this message translates to:
  /// **'Not selected'**
  String get onboarding_select_goal_semantics_not_selected;

  /// No description provided for @onboarding_goal_follow_curriculum_title.
  ///
  /// In en, this message translates to:
  /// **'Follow Curriculum'**
  String get onboarding_goal_follow_curriculum_title;

  /// No description provided for @onboarding_goal_follow_curriculum_description.
  ///
  /// In en, this message translates to:
  /// **'Learn at the right pace'**
  String get onboarding_goal_follow_curriculum_description;

  /// No description provided for @onboarding_goal_strengthen_weakness_title.
  ///
  /// In en, this message translates to:
  /// **'Strengthen Weak Areas'**
  String get onboarding_goal_strengthen_weakness_title;

  /// No description provided for @onboarding_goal_strengthen_weakness_description.
  ///
  /// In en, this message translates to:
  /// **'Focus on areas you\'re not confident in'**
  String get onboarding_goal_strengthen_weakness_description;

  /// No description provided for @onboarding_goal_exam_preparation_title.
  ///
  /// In en, this message translates to:
  /// **'Exam Preparation'**
  String get onboarding_goal_exam_preparation_title;

  /// No description provided for @onboarding_goal_exam_preparation_description.
  ///
  /// In en, this message translates to:
  /// **'Prepare for upcoming exams'**
  String get onboarding_goal_exam_preparation_description;

  /// No description provided for @onboarding_trial_start_title.
  ///
  /// In en, this message translates to:
  /// **'Start Trial'**
  String get onboarding_trial_start_title;

  /// No description provided for @onboarding_trial_start_header.
  ///
  /// In en, this message translates to:
  /// **'Start your free trial!'**
  String get onboarding_trial_start_header;

  /// No description provided for @onboarding_trial_start_description.
  ///
  /// In en, this message translates to:
  /// **'You have 7 days to experience all Tutor features'**
  String get onboarding_trial_start_description;

  /// No description provided for @onboarding_trial_start_button.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get onboarding_trial_start_button;

  /// No description provided for @onboarding_trial_start_button_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get onboarding_trial_start_button_retry;

  /// No description provided for @onboarding_trial_start_already_have_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get onboarding_trial_start_already_have_account;

  /// No description provided for @onboarding_trial_start_login_link.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get onboarding_trial_start_login_link;

  /// No description provided for @onboarding_trial_feature_unlimited_math.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Math problems (3-5 times/day)'**
  String get onboarding_trial_feature_unlimited_math;

  /// No description provided for @onboarding_trial_feature_daily_plan.
  ///
  /// In en, this message translates to:
  /// **'Daily learning plan'**
  String get onboarding_trial_feature_daily_plan;

  /// No description provided for @onboarding_trial_feature_personalized_practice.
  ///
  /// In en, this message translates to:
  /// **'Personalized practice'**
  String get onboarding_trial_feature_personalized_practice;

  /// No description provided for @onboarding_trial_feature_mini_test.
  ///
  /// In en, this message translates to:
  /// **'Mini test to check knowledge'**
  String get onboarding_trial_feature_mini_test;

  /// No description provided for @onboarding_trial_info_title.
  ///
  /// In en, this message translates to:
  /// **'Trial Information'**
  String get onboarding_trial_info_title;

  /// No description provided for @onboarding_trial_info_duration_label.
  ///
  /// In en, this message translates to:
  /// **'Duration:'**
  String get onboarding_trial_info_duration_label;

  /// No description provided for @onboarding_trial_info_duration_value.
  ///
  /// In en, this message translates to:
  /// **'7 days'**
  String get onboarding_trial_info_duration_value;

  /// No description provided for @onboarding_trial_info_start_label.
  ///
  /// In en, this message translates to:
  /// **'Start:'**
  String get onboarding_trial_info_start_label;

  /// No description provided for @onboarding_trial_info_end_label.
  ///
  /// In en, this message translates to:
  /// **'End:'**
  String get onboarding_trial_info_end_label;

  /// No description provided for @onboarding_trial_info_note.
  ///
  /// In en, this message translates to:
  /// **'Learning data will be saved when you link with parent'**
  String get onboarding_trial_info_note;

  /// No description provided for @onboarding_trial_status_title.
  ///
  /// In en, this message translates to:
  /// **'Trial Status'**
  String get onboarding_trial_status_title;

  /// Days remaining in trial
  ///
  /// In en, this message translates to:
  /// **'{days} days remaining'**
  String onboarding_trial_status_days_remaining(int days);

  /// No description provided for @onboarding_trial_status_start_label.
  ///
  /// In en, this message translates to:
  /// **'Start:'**
  String get onboarding_trial_status_start_label;

  /// No description provided for @onboarding_trial_status_end_label.
  ///
  /// In en, this message translates to:
  /// **'End:'**
  String get onboarding_trial_status_end_label;

  /// Trial progress with used and total days
  ///
  /// In en, this message translates to:
  /// **'Used: {used}/{total} days'**
  String onboarding_trial_status_progress_label(int used, int total);

  /// No description provided for @onboarding_trial_status_stats_title.
  ///
  /// In en, this message translates to:
  /// **'Usage Statistics'**
  String get onboarding_trial_status_stats_title;

  /// No description provided for @onboarding_trial_status_stats_solves_today.
  ///
  /// In en, this message translates to:
  /// **'Solves today:'**
  String get onboarding_trial_status_stats_solves_today;

  /// No description provided for @onboarding_trial_status_stats_total_exercises.
  ///
  /// In en, this message translates to:
  /// **'Total exercises done:'**
  String get onboarding_trial_status_stats_total_exercises;

  /// No description provided for @onboarding_trial_status_stats_skills_learned.
  ///
  /// In en, this message translates to:
  /// **'Skills learned:'**
  String get onboarding_trial_status_stats_skills_learned;

  /// No description provided for @onboarding_trial_status_features_title.
  ///
  /// In en, this message translates to:
  /// **'You have access to:'**
  String get onboarding_trial_status_features_title;

  /// No description provided for @onboarding_trial_status_feature_unlimited_math.
  ///
  /// In en, this message translates to:
  /// **'Math problems (3-5 times/day)'**
  String get onboarding_trial_status_feature_unlimited_math;

  /// No description provided for @onboarding_trial_status_feature_daily_plan.
  ///
  /// In en, this message translates to:
  /// **'Daily learning plan'**
  String get onboarding_trial_status_feature_daily_plan;

  /// No description provided for @onboarding_trial_status_feature_personalized_practice.
  ///
  /// In en, this message translates to:
  /// **'Personalized practice'**
  String get onboarding_trial_status_feature_personalized_practice;

  /// No description provided for @onboarding_trial_status_feature_mini_test.
  ///
  /// In en, this message translates to:
  /// **'Mini test'**
  String get onboarding_trial_status_feature_mini_test;

  /// Warning message with days remaining
  ///
  /// In en, this message translates to:
  /// **'{days} days left. Link with parent to continue learning!'**
  String onboarding_trial_status_warning_message(int days);

  /// No description provided for @onboarding_trial_status_button_link_parent.
  ///
  /// In en, this message translates to:
  /// **'Link with Parent'**
  String get onboarding_trial_status_button_link_parent;

  /// No description provided for @onboarding_trial_status_button_continue_learning.
  ///
  /// In en, this message translates to:
  /// **'Continue Learning'**
  String get onboarding_trial_status_button_continue_learning;

  /// No description provided for @onboarding_trial_status_button_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get onboarding_trial_status_button_retry;

  /// No description provided for @onboarding_trial_status_error_expired.
  ///
  /// In en, this message translates to:
  /// **'Trial expired'**
  String get onboarding_trial_status_error_expired;

  /// No description provided for @onboarding_trial_status_error_not_found.
  ///
  /// In en, this message translates to:
  /// **'Trial not found'**
  String get onboarding_trial_status_error_not_found;

  /// No description provided for @onboarding_trial_status_error_generic.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get onboarding_trial_status_error_generic;

  /// No description provided for @onboarding_trial_expiry_title.
  ///
  /// In en, this message translates to:
  /// **'Link Parent'**
  String get onboarding_trial_expiry_title;

  /// No description provided for @onboarding_trial_expiry_header.
  ///
  /// In en, this message translates to:
  /// **'Trial period has ended!'**
  String get onboarding_trial_expiry_header;

  /// No description provided for @onboarding_trial_expiry_description.
  ///
  /// In en, this message translates to:
  /// **'You\'ve completed 7 days of trial. To continue learning, you need to link with parent account'**
  String get onboarding_trial_expiry_description;

  /// No description provided for @onboarding_trial_expiry_achievement_title.
  ///
  /// In en, this message translates to:
  /// **'You\'ve accomplished:'**
  String get onboarding_trial_expiry_achievement_title;

  /// No description provided for @onboarding_trial_expiry_achievement_exercises.
  ///
  /// In en, this message translates to:
  /// **'exercises'**
  String get onboarding_trial_expiry_achievement_exercises;

  /// No description provided for @onboarding_trial_expiry_achievement_skills.
  ///
  /// In en, this message translates to:
  /// **'skills learned'**
  String get onboarding_trial_expiry_achievement_skills;

  /// No description provided for @onboarding_trial_expiry_achievement_streak.
  ///
  /// In en, this message translates to:
  /// **'days streak'**
  String get onboarding_trial_expiry_achievement_streak;

  /// No description provided for @onboarding_trial_expiry_note.
  ///
  /// In en, this message translates to:
  /// **'Your learning data will be preserved when linked'**
  String get onboarding_trial_expiry_note;

  /// No description provided for @onboarding_trial_expiry_phone_label.
  ///
  /// In en, this message translates to:
  /// **'Enter parent phone number'**
  String get onboarding_trial_expiry_phone_label;

  /// No description provided for @onboarding_trial_expiry_phone_hint.
  ///
  /// In en, this message translates to:
  /// **'0912345678'**
  String get onboarding_trial_expiry_phone_hint;

  /// No description provided for @onboarding_trial_expiry_phone_helper.
  ///
  /// In en, this message translates to:
  /// **'Example: 0912345678'**
  String get onboarding_trial_expiry_phone_helper;

  /// No description provided for @onboarding_trial_expiry_phone_validation_required.
  ///
  /// In en, this message translates to:
  /// **'Please enter parent phone number'**
  String get onboarding_trial_expiry_phone_validation_required;

  /// No description provided for @onboarding_trial_expiry_phone_validation_format.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number. Please enter Vietnamese phone number (10 digits).'**
  String get onboarding_trial_expiry_phone_validation_format;

  /// No description provided for @onboarding_trial_expiry_button_send_otp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get onboarding_trial_expiry_button_send_otp;

  /// No description provided for @onboarding_trial_expiry_footer_note.
  ///
  /// In en, this message translates to:
  /// **'OTP code will be sent to parent\'s phone number'**
  String get onboarding_trial_expiry_footer_note;

  /// No description provided for @onboarding_trial_expiry_alternative_link.
  ///
  /// In en, this message translates to:
  /// **'Or receive link code'**
  String get onboarding_trial_expiry_alternative_link;

  /// No description provided for @onboarding_trial_expiry_error_rate_limit.
  ///
  /// In en, this message translates to:
  /// **'⚠️ You\'ve sent more than 3 times today. Please try again tomorrow.'**
  String get onboarding_trial_expiry_error_rate_limit;

  /// No description provided for @onboarding_trial_expiry_error_trial_not_found.
  ///
  /// In en, this message translates to:
  /// **'Trial not found. Please try again.'**
  String get onboarding_trial_expiry_error_trial_not_found;

  /// No description provided for @onboarding_otp_verification_title.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP Code'**
  String get onboarding_otp_verification_title;

  /// OTP verification description with phone number
  ///
  /// In en, this message translates to:
  /// **'OTP code has been sent to {phone}. Please ask parent for the code.'**
  String onboarding_otp_verification_description(String phone);

  /// OTP input box label with index
  ///
  /// In en, this message translates to:
  /// **'OTP input box {index}'**
  String onboarding_otp_verification_input_label(int index);

  /// OTP timer label with time
  ///
  /// In en, this message translates to:
  /// **'Time remaining: {time}'**
  String onboarding_otp_verification_timer_label(String time);

  /// No description provided for @onboarding_otp_verification_timer_expired.
  ///
  /// In en, this message translates to:
  /// **'OTP code has expired. Please resend code.'**
  String get onboarding_otp_verification_timer_expired;

  /// OTP timer remaining with time
  ///
  /// In en, this message translates to:
  /// **'Remaining: {time}'**
  String onboarding_otp_verification_timer_remaining(String time);

  /// No description provided for @onboarding_otp_verification_button_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get onboarding_otp_verification_button_confirm;

  /// No description provided for @onboarding_otp_verification_button_resend.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP Code'**
  String get onboarding_otp_verification_button_resend;

  /// Resend OTP button with cooldown seconds
  ///
  /// In en, this message translates to:
  /// **'Resend OTP Code (in {seconds} seconds)'**
  String onboarding_otp_verification_button_resend_cooldown(int seconds);

  /// No description provided for @onboarding_otp_verification_success_resend.
  ///
  /// In en, this message translates to:
  /// **'OTP code resent'**
  String get onboarding_otp_verification_success_resend;

  /// OTP resend cooldown error with seconds
  ///
  /// In en, this message translates to:
  /// **'Please wait {seconds} seconds before requesting OTP again.'**
  String onboarding_otp_verification_error_cooldown(int seconds);

  /// No description provided for @onboarding_linking_success_title.
  ///
  /// In en, this message translates to:
  /// **'Linking Successful!'**
  String get onboarding_linking_success_title;

  /// No description provided for @onboarding_linking_success_description.
  ///
  /// In en, this message translates to:
  /// **'Your account has been linked with parent. Learning data from 7-day trial has been preserved.'**
  String get onboarding_linking_success_description;

  /// No description provided for @onboarding_linking_success_data_saved_title.
  ///
  /// In en, this message translates to:
  /// **'✅ Data saved:'**
  String get onboarding_linking_success_data_saved_title;

  /// No description provided for @onboarding_linking_success_data_exercises.
  ///
  /// In en, this message translates to:
  /// **'exercises'**
  String get onboarding_linking_success_data_exercises;

  /// No description provided for @onboarding_linking_success_data_skills.
  ///
  /// In en, this message translates to:
  /// **'skills'**
  String get onboarding_linking_success_data_skills;

  /// No description provided for @onboarding_linking_success_data_days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get onboarding_linking_success_data_days;

  /// No description provided for @onboarding_linking_success_parent_info_title.
  ///
  /// In en, this message translates to:
  /// **'Login information for parent:'**
  String get onboarding_linking_success_parent_info_title;

  /// No description provided for @onboarding_linking_success_parent_username_label.
  ///
  /// In en, this message translates to:
  /// **'Username:'**
  String get onboarding_linking_success_parent_username_label;

  /// No description provided for @onboarding_linking_success_parent_password_label.
  ///
  /// In en, this message translates to:
  /// **'Password:'**
  String get onboarding_linking_success_parent_password_label;

  /// No description provided for @onboarding_linking_success_parent_password_note.
  ///
  /// In en, this message translates to:
  /// **'Temporary password, please change after login'**
  String get onboarding_linking_success_parent_password_note;

  /// No description provided for @onboarding_linking_success_parent_dashboard_label.
  ///
  /// In en, this message translates to:
  /// **'Access dashboard:'**
  String get onboarding_linking_success_parent_dashboard_label;

  /// No description provided for @onboarding_linking_success_button_complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get onboarding_linking_success_button_complete;

  /// Copy success message with label
  ///
  /// In en, this message translates to:
  /// **'Copied {label}'**
  String onboarding_linking_success_copy_success(String label);

  /// No description provided for @onboarding_otp_error_phone_invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number. Please enter Vietnamese phone number (10 digits).'**
  String get onboarding_otp_error_phone_invalid;

  /// No description provided for @onboarding_otp_error_send_failed.
  ///
  /// In en, this message translates to:
  /// **'Cannot send OTP code. Please try again.'**
  String get onboarding_otp_error_send_failed;

  /// No description provided for @onboarding_otp_error_rate_limit.
  ///
  /// In en, this message translates to:
  /// **'You\'ve sent too many requests. Maximum 3 times per day. Please try again tomorrow.'**
  String get onboarding_otp_error_rate_limit;

  /// No description provided for @onboarding_otp_error_trial_not_found.
  ///
  /// In en, this message translates to:
  /// **'Trial not found. Please start trial first.'**
  String get onboarding_otp_error_trial_not_found;

  /// No description provided for @onboarding_otp_error_missing_parameter.
  ///
  /// In en, this message translates to:
  /// **'Missing required information. Please try again.'**
  String get onboarding_otp_error_missing_parameter;

  /// No description provided for @onboarding_otp_error_verify_invalid.
  ///
  /// In en, this message translates to:
  /// **'OTP code must have 6 digits.'**
  String get onboarding_otp_error_verify_invalid;

  /// No description provided for @onboarding_otp_error_verify_failed.
  ///
  /// In en, this message translates to:
  /// **'OTP code is incorrect. Please try again.'**
  String get onboarding_otp_error_verify_failed;

  /// OTP resend cooldown error with seconds
  ///
  /// In en, this message translates to:
  /// **'Please wait {seconds} seconds before requesting OTP again.'**
  String onboarding_otp_error_resend_cooldown(int seconds);

  /// No description provided for @profile_title.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile_title;

  /// No description provided for @profile_menu_personal_info.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get profile_menu_personal_info;

  /// No description provided for @profile_menu_trial_status.
  ///
  /// In en, this message translates to:
  /// **'Trial Status'**
  String get profile_menu_trial_status;

  /// No description provided for @profile_menu_trial_status_warning.
  ///
  /// In en, this message translates to:
  /// **'Less than 2 days remaining'**
  String get profile_menu_trial_status_warning;

  /// No description provided for @profile_menu_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profile_menu_settings;

  /// No description provided for @profile_menu_logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profile_menu_logout;

  /// No description provided for @core_widget_error_retry_default.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get core_widget_error_retry_default;

  /// No description provided for @core_widget_empty_action_default.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get core_widget_empty_action_default;

  /// No description provided for @practice_session_resume_title.
  ///
  /// In en, this message translates to:
  /// **'Continue Practice'**
  String get practice_session_resume_title;

  /// No description provided for @practice_session_current_mastery.
  ///
  /// In en, this message translates to:
  /// **'Current Mastery:'**
  String get practice_session_current_mastery;

  /// Session progress with completed and total questions
  ///
  /// In en, this message translates to:
  /// **'Done: {completed}/{total} questions'**
  String practice_session_progress_done(int completed, int total);

  /// Session start time
  ///
  /// In en, this message translates to:
  /// **'Started: {date}'**
  String practice_session_started_at(String date);

  /// Last activity time
  ///
  /// In en, this message translates to:
  /// **'Last activity: {date}'**
  String practice_session_last_activity(String date);

  /// Continue from question number
  ///
  /// In en, this message translates to:
  /// **'Continue from question {questionNumber}'**
  String practice_session_continue_from_question(int questionNumber);

  /// No description provided for @practice_session_restart_from_beginning.
  ///
  /// In en, this message translates to:
  /// **'Restart from beginning'**
  String get practice_session_restart_from_beginning;

  /// No description provided for @practice_session_discard_session.
  ///
  /// In en, this message translates to:
  /// **'Discard session'**
  String get practice_session_discard_session;

  /// No description provided for @practice_session_restart_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get practice_session_restart_dialog_title;

  /// No description provided for @practice_session_restart_dialog_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to restart from the beginning? Current progress will be lost.'**
  String get practice_session_restart_dialog_message;

  /// No description provided for @practice_session_restart_dialog_button.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get practice_session_restart_dialog_button;

  /// No description provided for @practice_session_discard_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Discard Session'**
  String get practice_session_discard_dialog_title;

  /// No description provided for @practice_session_discard_dialog_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to discard this session? Progress will be lost.'**
  String get practice_session_discard_dialog_message;

  /// No description provided for @practice_session_discard_dialog_button.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get practice_session_discard_dialog_button;

  /// No description provided for @practice_session_error_invalid_id.
  ///
  /// In en, this message translates to:
  /// **'Invalid session ID'**
  String get practice_session_error_invalid_id;

  /// No description provided for @practice_session_error_not_found.
  ///
  /// In en, this message translates to:
  /// **'Session not found'**
  String get practice_session_error_not_found;

  /// No description provided for @practice_session_error_load_failed.
  ///
  /// In en, this message translates to:
  /// **'Cannot load session information'**
  String get practice_session_error_load_failed;

  /// No description provided for @practice_session_error_cancel_failed.
  ///
  /// In en, this message translates to:
  /// **'Cannot cancel session. Please try again.'**
  String get practice_session_error_cancel_failed;

  /// No description provided for @practice_session_error_expired_message.
  ///
  /// In en, this message translates to:
  /// **'Session has expired or does not exist. Start a new session?'**
  String get practice_session_error_expired_message;

  /// No description provided for @practice_session_error_expired.
  ///
  /// In en, this message translates to:
  /// **'Session has expired or does not exist.'**
  String get practice_session_error_expired;

  /// No description provided for @practice_session_complete_title.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get practice_session_complete_title;

  /// No description provided for @practice_session_complete_message.
  ///
  /// In en, this message translates to:
  /// **'Session completed!'**
  String get practice_session_complete_message;

  /// Mastery increase display
  ///
  /// In en, this message translates to:
  /// **'Mastery increased: {previous}% → {current}% (+{change}%)'**
  String practice_session_complete_mastery_increase(
    int previous,
    int current,
    int change,
  );

  /// No description provided for @practice_session_complete_improvement_message.
  ///
  /// In en, this message translates to:
  /// **'You\'ve improved a lot!'**
  String get practice_session_complete_improvement_message;

  /// No description provided for @practice_session_complete_progress_saved.
  ///
  /// In en, this message translates to:
  /// **'Progress has been saved. You can continue later!'**
  String get practice_session_complete_progress_saved;

  /// Total questions done
  ///
  /// In en, this message translates to:
  /// **'{total}/{total} questions done'**
  String practice_session_complete_stat_questions_done(int total);

  /// Correct answers count
  ///
  /// In en, this message translates to:
  /// **'Correct: {count} questions'**
  String practice_session_complete_stat_correct(int count);

  /// Incorrect answers count
  ///
  /// In en, this message translates to:
  /// **'Incorrect: {count} questions'**
  String practice_session_complete_stat_incorrect(int count);

  /// Accuracy percentage
  ///
  /// In en, this message translates to:
  /// **'Accuracy: {accuracy}%'**
  String practice_session_complete_stat_accuracy(int accuracy);

  /// No description provided for @practice_session_skill_status_mastered.
  ///
  /// In en, this message translates to:
  /// **'Mastered'**
  String get practice_session_skill_status_mastered;

  /// No description provided for @practice_session_skill_status_improving.
  ///
  /// In en, this message translates to:
  /// **'Improving'**
  String get practice_session_skill_status_improving;

  /// No description provided for @practice_session_skill_status_unstable.
  ///
  /// In en, this message translates to:
  /// **'Unstable'**
  String get practice_session_skill_status_unstable;

  /// No description provided for @practice_session_skill_status_weak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get practice_session_skill_status_weak;

  /// No description provided for @practice_session_recommendation_ready_mini_test.
  ///
  /// In en, this message translates to:
  /// **'🎯 Ready for Mini Test!'**
  String get practice_session_recommendation_ready_mini_test;

  /// No description provided for @practice_session_recommendation_do_mini_test.
  ///
  /// In en, this message translates to:
  /// **'You\'ve done enough! Take the Mini Test to check your knowledge'**
  String get practice_session_recommendation_do_mini_test;

  /// Recommendation for more practice
  ///
  /// In en, this message translates to:
  /// **'Do {remaining} more questions to reach 70%'**
  String practice_session_recommendation_more_practice(int remaining);

  /// No description provided for @practice_session_complete_action_mini_test.
  ///
  /// In en, this message translates to:
  /// **'Take Mini Test'**
  String get practice_session_complete_action_mini_test;

  /// No description provided for @practice_session_complete_action_more_practice.
  ///
  /// In en, this message translates to:
  /// **'More Practice'**
  String get practice_session_complete_action_more_practice;

  /// No description provided for @practice_session_complete_action_review.
  ///
  /// In en, this message translates to:
  /// **'Review Answers'**
  String get practice_session_complete_action_review;

  /// No description provided for @practice_session_complete_action_home.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get practice_session_complete_action_home;

  /// No description provided for @practice_result_title.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get practice_result_title;

  /// No description provided for @practice_result_correct.
  ///
  /// In en, this message translates to:
  /// **'Correct!'**
  String get practice_result_correct;

  /// No description provided for @practice_result_incorrect.
  ///
  /// In en, this message translates to:
  /// **'Incorrect'**
  String get practice_result_incorrect;

  /// No description provided for @practice_result_encouragement_correct.
  ///
  /// In en, this message translates to:
  /// **'Great!'**
  String get practice_result_encouragement_correct;

  /// No description provided for @practice_result_encouragement_incorrect.
  ///
  /// In en, this message translates to:
  /// **'That\'s okay, you\'ve learned something!'**
  String get practice_result_encouragement_incorrect;

  /// Correct answer display
  ///
  /// In en, this message translates to:
  /// **'Correct answer: {answer}'**
  String practice_result_correct_answer(String answer);

  /// Explanation label
  ///
  /// In en, this message translates to:
  /// **'Explanation: {explanation}'**
  String practice_result_explanation_label(String explanation);

  /// Practice result progress
  ///
  /// In en, this message translates to:
  /// **'Done: {current}/{total} questions'**
  String practice_result_progress_done(int current, int total);

  /// Progress percentage
  ///
  /// In en, this message translates to:
  /// **'Progress: {percentage}%'**
  String practice_result_progress_percentage(String percentage);

  /// No description provided for @practice_result_difficulty_increase_notification.
  ///
  /// In en, this message translates to:
  /// **'🎉 Difficulty will increase in the next question!'**
  String get practice_result_difficulty_increase_notification;

  /// No description provided for @practice_result_difficulty_decrease_notification.
  ///
  /// In en, this message translates to:
  /// **'💡 Difficulty will decrease to help you understand better'**
  String get practice_result_difficulty_decrease_notification;

  /// No description provided for @practice_result_warning_check_steps.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Note: Please check your solution steps again'**
  String get practice_result_warning_check_steps;

  /// No description provided for @practice_result_action_next_question.
  ///
  /// In en, this message translates to:
  /// **'Next Question'**
  String get practice_result_action_next_question;

  /// No description provided for @practice_result_action_pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get practice_result_action_pause;

  /// No description provided for @practice_result_action_review_explanation.
  ///
  /// In en, this message translates to:
  /// **'Review Explanation'**
  String get practice_result_action_review_explanation;

  /// No description provided for @practice_result_explanation_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Explanation'**
  String get practice_result_explanation_dialog_title;

  /// Answer label in explanation dialog
  ///
  /// In en, this message translates to:
  /// **'Answer: {answer}'**
  String practice_result_explanation_dialog_answer_label(String answer);

  /// No description provided for @practice_result_explanation_generic.
  ///
  /// In en, this message translates to:
  /// **'Please review the solution steps in the explanation section.'**
  String get practice_result_explanation_generic;
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
