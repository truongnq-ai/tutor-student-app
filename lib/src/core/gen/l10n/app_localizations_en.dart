// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language_vietnamese => 'Tiếng Việt';

  @override
  String get language_english => 'English';

  @override
  String get navigation_home => 'Home';

  @override
  String get navigation_profile => 'Profile';

  @override
  String get auth_login_title => 'Login';

  @override
  String get auth_login_button => 'Login';

  @override
  String get auth_login_remember_me => 'Remember me';

  @override
  String get auth_login_forgot_password => 'Forgot password?';

  @override
  String get auth_signup_title => 'Sign up';

  @override
  String get auth_signup_button => 'Sign up';

  @override
  String get auth_signin_button => 'Sign in';

  @override
  String get auth_forgot_password_title => 'Forgot Password';

  @override
  String get auth_forgot_password_description =>
      'Enter the email associated with your account and we\'ll send an email with instructions to reset your password.';

  @override
  String get auth_forgot_password_button => 'Send';

  @override
  String get auth_forgot_password_back_to_login => 'Back to login';

  @override
  String get auth_reset_password_title => 'Reset Password';

  @override
  String get auth_reset_password_new_password => 'New Password';

  @override
  String get auth_reset_password_confirm_password => 'Confirm Password';

  @override
  String get auth_reset_password_hint =>
      'Your new password must be different from previous used passwords.';

  @override
  String get auth_reset_password_button => 'Reset Password';

  @override
  String get auth_reset_password_success => 'Password Changed Successfully';

  @override
  String get auth_reset_password_success_message =>
      'Your password has been changed successfully.';

  @override
  String get auth_account_dont_have => 'Don\'t have an account? ';

  @override
  String get auth_account_already_have => 'Already have an account? ';

  @override
  String get auth_verification_check_mail => 'Check your mail';

  @override
  String auth_verification_enter_code(String email) {
    return 'Please enter 4 digit code sent to your mail $email.';
  }

  @override
  String get auth_verification_didnt_get_code => 'Didn\'t get a code? ';

  @override
  String get auth_verification_resend => 'Click to resend';

  @override
  String get auth_verification_did_not_receive =>
      'Did not receive the email? Check your spam filter. or ';

  @override
  String get auth_verification_try_another_email => 'try another email address';

  @override
  String get common_field_email => 'Email';

  @override
  String get common_field_email_address => 'Email Address';

  @override
  String get common_field_password => 'Password';

  @override
  String get common_field_first_name => 'First Name';

  @override
  String get common_field_last_name => 'Last Name';

  @override
  String get common_button_continue => 'Continue';

  @override
  String get common_button_ok => 'OK';

  @override
  String get common_button_cancel => 'Cancel';

  @override
  String get common_button_close => 'Close';

  @override
  String get common_button_back => 'Back';

  @override
  String get common_button_get_started => 'Get Started';

  @override
  String get common_button_logout => 'Logout';

  @override
  String get common_button_start_learning => 'Start Learning';

  @override
  String get common_button_load_more => 'Load More';

  @override
  String get validation_required => 'This field is required';

  @override
  String get validation_email_required => 'Email is required';

  @override
  String get validation_password_required => 'Password is required';

  @override
  String get validation_email_invalid => 'Please enter valid email address';

  @override
  String validation_length_min(int min) {
    return 'This field must be at least $min characters long';
  }

  @override
  String validation_length_max(int max) {
    return 'This field must be at most $max characters long';
  }

  @override
  String validation_password_min_length(String minLength) {
    return 'Password must be at least $minLength characters';
  }

  @override
  String get validation_password_number =>
      'Password must contain at least one number';

  @override
  String get validation_password_lowercase =>
      'Password must contain at least one lowercase letter';

  @override
  String get validation_password_uppercase =>
      'Password must contain at least one uppercase letter';

  @override
  String get validation_password_special_char =>
      'Password must contain at least one special character';

  @override
  String get error_network_connection =>
      'Cannot connect. Please check your internet.';

  @override
  String get error_network_timeout => 'Connection timeout. Please try again.';

  @override
  String get error_network_generic =>
      'Please check your internet connection and try again.';

  @override
  String get error_auth_unauthorized => 'Session expired. Please login again.';

  @override
  String get error_system_internal => 'System error. Please try again later.';

  @override
  String get error_resource_not_found => 'Not found.';

  @override
  String get error_generic => 'An error occurred';

  @override
  String get practice_question_title => 'Question';

  @override
  String practice_question_counter(int current, int total) {
    return 'Question $current/$total';
  }

  @override
  String practice_question_progress(int current, int total) {
    return '$current/$total questions done';
  }

  @override
  String get practice_question_select_answer => 'Select answer:';

  @override
  String get practice_question_enter_answer => 'Enter answer:';

  @override
  String get practice_question_answer_hint => 'Enter your answer';

  @override
  String get practice_question_check => 'Check';

  @override
  String get practice_question_hint => '💡 Hint';

  @override
  String practice_question_skill_label(String skillName) {
    return 'Skill: $skillName';
  }

  @override
  String get practice_question_not_found => 'Question not found';

  @override
  String get practice_question_load_error => 'Cannot load question';

  @override
  String get practice_skill_selection_title => 'Select Skill to Practice';

  @override
  String get practice_skill_selection_description =>
      'You can select one of the following skills to improve';

  @override
  String get practice_skill_selection_info =>
      'Select a skill to start practicing. The system will create exercises suitable for your level.';

  @override
  String get practice_skill_selection_no_weak_skills =>
      'No weak skills. Great!';

  @override
  String get practice_skill_selection_load_error => 'Cannot load skill list';

  @override
  String get practice_skill_selection_back_to_home => 'Back to Home';

  @override
  String get practice_skill_status_weak => 'Weak';

  @override
  String get practice_skill_status_unstable => 'Unstable';

  @override
  String get practice_history_title => 'Practice History';

  @override
  String get practice_history_empty_title => 'No practice sessions yet';

  @override
  String get practice_history_empty_description =>
      'Start learning to see your history here';

  @override
  String get practice_history_load_error => 'Cannot load history';

  @override
  String practice_card_exercises(int count) {
    return '$count exercises';
  }

  @override
  String practice_card_correct(int count) {
    return 'Correct: $count';
  }

  @override
  String practice_card_incorrect(int count) {
    return 'Incorrect: $count';
  }

  @override
  String practice_card_accuracy(int accuracy) {
    return '$accuracy%';
  }

  @override
  String practice_card_mastery(String change) {
    return 'Mastery: $change%';
  }

  @override
  String practice_card_mastery_positive(int change) {
    return 'Mastery: +$change%';
  }

  @override
  String practice_card_duration(String duration) {
    return 'Duration: $duration';
  }

  @override
  String practice_card_duration_seconds(int seconds) {
    return '${seconds}s';
  }

  @override
  String practice_card_duration_minutes(int minutes) {
    return '${minutes}p';
  }

  @override
  String practice_card_duration_minutes_seconds(int minutes, int seconds) {
    return '${minutes}p ${seconds}s';
  }

  @override
  String practice_history_mastery(int level) {
    return 'Mastery: $level%';
  }

  @override
  String practice_history_duration(int seconds) {
    return 'Duration: ${seconds}s';
  }

  @override
  String difficulty_label(String level) {
    return 'Difficulty: $level';
  }

  @override
  String get difficulty_easy => 'Easy';

  @override
  String get difficulty_medium => 'Medium';

  @override
  String get difficulty_hard => 'Hard';

  @override
  String get difficulty_very_hard => 'Very Hard';

  @override
  String get difficulty_fair => 'Fair';

  @override
  String get learning_today_title => 'Today\'s Learning';

  @override
  String learning_difficulty_label(String level) {
    return 'Difficulty: $level';
  }

  @override
  String learning_skill_estimated_time(int minutes) {
    return '~$minutes min';
  }

  @override
  String get auth_reset_password_create_new => 'Create New Password';

  @override
  String get auth_verification_enter_code_label => 'Enter verification code';

  @override
  String get auth_forgot_password_enter_associated_email =>
      'Enter the email associated with your account';

  @override
  String get onboarding_learn_flutter_title => 'Learn Flutter';

  @override
  String get onboarding_learn_flutter_subtitle => 'Build amazing apps';

  @override
  String get onboarding_learn_flutter_description =>
      'Learn Flutter and build beautiful, fast apps for multiple platforms.';

  @override
  String get onboarding_join_community_title => 'Join Community';

  @override
  String get onboarding_join_community_subtitle => 'Connect with developers';

  @override
  String get onboarding_join_community_description =>
      'Join our community of developers and share your knowledge.';

  @override
  String get onboarding_build_deploy_title => 'Build & Deploy';

  @override
  String get onboarding_build_deploy_subtitle => 'Ship your apps';

  @override
  String get onboarding_build_deploy_description =>
      'Build and deploy your apps to production with ease.';
}
