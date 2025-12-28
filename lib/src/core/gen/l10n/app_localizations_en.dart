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
  String get auth_forgot_password_enter_associated_email =>
      'Enter the email associated with your account';

  @override
  String get auth_reset_password_title => 'Reset Password';

  @override
  String get auth_reset_password_create_new => 'Create New Password';

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
  String get auth_entry_title => 'Choose Login Method';

  @override
  String get auth_entry_divider_or => 'Or';

  @override
  String get auth_entry_manual_button => 'Manual Login / Sign Up';

  @override
  String get auth_entry_no_account => 'Don\'t have an account? ';

  @override
  String get auth_entry_manual_signup => 'Manual Sign Up';

  @override
  String get auth_login_error_invalid_credentials =>
      'Username or password is incorrect. Please try again.';

  @override
  String get auth_oauth_error_student_not_found =>
      'Student information not found';

  @override
  String get auth_registration_success_message =>
      'Registration successful. Start your free trial!';

  @override
  String get auth_registration_field_full_name => 'Full Name';

  @override
  String get auth_registration_field_username => 'Username';

  @override
  String get auth_registration_field_confirm_password => 'Confirm Password';

  @override
  String get auth_registration_validation_full_name_required =>
      'Please enter your full name';

  @override
  String get auth_registration_validation_username_required =>
      'Please enter username';

  @override
  String get auth_registration_validation_username_format =>
      'Username can only contain letters and numbers, case insensitive';

  @override
  String get auth_registration_validation_confirm_password_required =>
      'Please confirm password';

  @override
  String get auth_registration_validation_password_mismatch =>
      'Passwords do not match';

  @override
  String get auth_set_credential_title => 'Set Login Credentials';

  @override
  String get auth_set_credential_description =>
      'Please set username and password to complete registration';

  @override
  String get auth_set_credential_success_message =>
      'Login credentials set successfully.';

  @override
  String auth_set_credential_error_generic(String error) {
    return 'An error occurred: $error';
  }

  @override
  String get auth_verification_check_mail => 'Check your mail';

  @override
  String auth_verification_enter_code(String email) {
    return 'Please enter 4 digit code sent to your mail $email.';
  }

  @override
  String get auth_verification_enter_code_label => 'Enter verification code';

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
  String get validation_email_invalid => 'Please enter valid email address';

  @override
  String get validation_password_required => 'Password is required';

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
  String get practice_skill_selection_welcome_title => 'Welcome to Practice!';

  @override
  String get practice_skill_selection_welcome_description =>
      'To get started, check out today\'s learning recommendations. The system will suggest the most suitable skills for you to practice.';

  @override
  String get practice_skill_selection_welcome_cta =>
      'View Today\'s Learning Plan';

  @override
  String get practice_skill_selection_welcome_tip_title => 'Tip';

  @override
  String get practice_skill_selection_welcome_tip_description =>
      'Starting with the most basic skills will help you build a solid foundation. The system will automatically suggest suitable skills based on your progress.';

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
  String get learning_plan_today_title => 'Today\'s Learning Plan';

  @override
  String get learning_plan_progress_overview_title => 'Progress Overview';

  @override
  String get learning_plan_week_progress_title => 'Week Progress';

  @override
  String get learning_plan_stat_total_skills => 'Total Skills';

  @override
  String get learning_plan_stat_mastered_skills => 'Mastered Skills';

  @override
  String learning_plan_week_streak(int days) {
    return '$days days streak';
  }

  @override
  String learning_plan_week_exercises_done(int count) {
    return '$count exercises done';
  }

  @override
  String get learning_plan_focus_on_skills => 'Focus on:';

  @override
  String get learning_plan_empty_title => 'No learning plan today';

  @override
  String get learning_plan_empty_description =>
      'Start learning to see your plan!';

  @override
  String get learning_plan_error_load_failed => 'Cannot load learning plan';

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

  @override
  String get onboarding_welcome_title => 'Welcome to Tutor!';

  @override
  String get onboarding_welcome_subtitle =>
      'Personalized AI Math Tutor for you';

  @override
  String get onboarding_welcome_trial_badge =>
      'Free 7-day trial - Full features';

  @override
  String get onboarding_welcome_button_try_now => 'Try Now';

  @override
  String get onboarding_welcome_button_learn_more => 'Learn More';

  @override
  String get onboarding_welcome_already_have_account =>
      'Already have an account? ';

  @override
  String get onboarding_welcome_login_link => 'Login';

  @override
  String get onboarding_select_grade_title => 'Select Grade';

  @override
  String get onboarding_select_grade_header => 'What grade are you in?';

  @override
  String get onboarding_select_grade_button_retry => 'Retry';

  @override
  String get onboarding_grade_6_title => 'Grade 6';

  @override
  String get onboarding_grade_6_description => 'Grade 6 Math Program';

  @override
  String get onboarding_grade_7_title => 'Grade 7';

  @override
  String get onboarding_grade_7_description => 'Grade 7 Math Program';

  @override
  String get onboarding_select_goal_title => 'Learning Goals';

  @override
  String get onboarding_select_goal_header => 'What are your learning goals?';

  @override
  String get onboarding_select_goal_button_start => 'Start Learning';

  @override
  String get onboarding_select_goal_button_retry => 'Retry';

  @override
  String get onboarding_select_goal_semantics_selected => 'Selected';

  @override
  String get onboarding_select_goal_semantics_not_selected => 'Not selected';

  @override
  String get onboarding_goal_follow_curriculum_title => 'Follow Curriculum';

  @override
  String get onboarding_goal_follow_curriculum_description =>
      'Learn at the right pace';

  @override
  String get onboarding_goal_strengthen_weakness_title =>
      'Strengthen Weak Areas';

  @override
  String get onboarding_goal_strengthen_weakness_description =>
      'Focus on areas you\'re not confident in';

  @override
  String get onboarding_goal_exam_preparation_title => 'Exam Preparation';

  @override
  String get onboarding_goal_exam_preparation_description =>
      'Prepare for upcoming exams';

  @override
  String get onboarding_trial_start_title => 'Start Trial';

  @override
  String get onboarding_trial_start_header => 'Start your free trial!';

  @override
  String get onboarding_trial_start_description =>
      'You have 7 days to experience all Tutor features';

  @override
  String get onboarding_trial_start_button => 'Start';

  @override
  String get onboarding_trial_start_button_retry => 'Retry';

  @override
  String get onboarding_trial_start_already_have_account =>
      'Already have an account? ';

  @override
  String get onboarding_trial_start_login_link => 'Login';

  @override
  String get onboarding_trial_feature_unlimited_math =>
      'Unlimited Math problems (3-5 times/day)';

  @override
  String get onboarding_trial_feature_daily_plan => 'Daily learning plan';

  @override
  String get onboarding_trial_feature_personalized_practice =>
      'Personalized practice';

  @override
  String get onboarding_trial_feature_mini_test =>
      'Mini test to check knowledge';

  @override
  String get onboarding_trial_info_title => 'Trial Information';

  @override
  String get onboarding_trial_info_duration_label => 'Duration:';

  @override
  String get onboarding_trial_info_duration_value => '7 days';

  @override
  String get onboarding_trial_info_start_label => 'Start:';

  @override
  String get onboarding_trial_info_end_label => 'End:';

  @override
  String get onboarding_trial_info_note =>
      'Learning data will be saved when you link with parent';

  @override
  String get onboarding_trial_status_title => 'Trial Status';

  @override
  String onboarding_trial_status_days_remaining(int days) {
    return '$days days remaining';
  }

  @override
  String get onboarding_trial_status_start_label => 'Start:';

  @override
  String get onboarding_trial_status_end_label => 'End:';

  @override
  String onboarding_trial_status_progress_label(int used, int total) {
    return 'Used: $used/$total days';
  }

  @override
  String get onboarding_trial_status_stats_title => 'Usage Statistics';

  @override
  String get onboarding_trial_status_stats_solves_today => 'Solves today:';

  @override
  String get onboarding_trial_status_stats_total_exercises =>
      'Total exercises done:';

  @override
  String get onboarding_trial_status_stats_skills_learned => 'Skills learned:';

  @override
  String get onboarding_trial_status_features_title => 'You have access to:';

  @override
  String get onboarding_trial_status_feature_unlimited_math =>
      'Math problems (3-5 times/day)';

  @override
  String get onboarding_trial_status_feature_daily_plan =>
      'Daily learning plan';

  @override
  String get onboarding_trial_status_feature_personalized_practice =>
      'Personalized practice';

  @override
  String get onboarding_trial_status_feature_mini_test => 'Mini test';

  @override
  String onboarding_trial_status_warning_message(int days) {
    return '$days days left. Link with parent to continue learning!';
  }

  @override
  String get onboarding_trial_status_button_link_parent => 'Link with Parent';

  @override
  String get onboarding_trial_status_button_continue_learning =>
      'Continue Learning';

  @override
  String get onboarding_trial_status_button_retry => 'Retry';

  @override
  String get onboarding_trial_status_error_expired => 'Trial expired';

  @override
  String get onboarding_trial_status_error_not_found => 'Trial not found';

  @override
  String get onboarding_trial_status_error_generic => 'An error occurred';

  @override
  String get onboarding_trial_expiry_title => 'Link Parent';

  @override
  String get onboarding_trial_expiry_header => 'Trial period has ended!';

  @override
  String get onboarding_trial_expiry_description =>
      'You\'ve completed 7 days of trial. To continue learning, you need to link with parent account';

  @override
  String get onboarding_trial_expiry_achievement_title =>
      'You\'ve accomplished:';

  @override
  String get onboarding_trial_expiry_achievement_exercises => 'exercises';

  @override
  String get onboarding_trial_expiry_achievement_skills => 'skills learned';

  @override
  String get onboarding_trial_expiry_achievement_streak => 'days streak';

  @override
  String get onboarding_trial_expiry_note =>
      'Your learning data will be preserved when linked';

  @override
  String get onboarding_trial_expiry_phone_label => 'Enter parent phone number';

  @override
  String get onboarding_trial_expiry_phone_hint => '0912345678';

  @override
  String get onboarding_trial_expiry_phone_helper => 'Example: 0912345678';

  @override
  String get onboarding_trial_expiry_phone_validation_required =>
      'Please enter parent phone number';

  @override
  String get onboarding_trial_expiry_phone_validation_format =>
      'Invalid phone number. Please enter Vietnamese phone number (10 digits).';

  @override
  String get onboarding_trial_expiry_button_send_otp => 'Send OTP';

  @override
  String get onboarding_trial_expiry_footer_note =>
      'OTP code will be sent to parent\'s phone number';

  @override
  String get onboarding_trial_expiry_alternative_link => 'Or receive link code';

  @override
  String get onboarding_trial_expiry_error_rate_limit =>
      '⚠️ You\'ve sent more than 3 times today. Please try again tomorrow.';

  @override
  String get onboarding_trial_expiry_error_trial_not_found =>
      'Trial not found. Please try again.';

  @override
  String get onboarding_otp_verification_title => 'Enter OTP Code';

  @override
  String onboarding_otp_verification_description(String phone) {
    return 'OTP code has been sent to $phone. Please ask parent for the code.';
  }

  @override
  String onboarding_otp_verification_input_label(int index) {
    return 'OTP input box $index';
  }

  @override
  String onboarding_otp_verification_timer_label(String time) {
    return 'Time remaining: $time';
  }

  @override
  String get onboarding_otp_verification_timer_expired =>
      'OTP code has expired. Please resend code.';

  @override
  String onboarding_otp_verification_timer_remaining(String time) {
    return 'Remaining: $time';
  }

  @override
  String get onboarding_otp_verification_button_confirm => 'Confirm';

  @override
  String get onboarding_otp_verification_button_resend => 'Resend OTP Code';

  @override
  String onboarding_otp_verification_button_resend_cooldown(int seconds) {
    return 'Resend OTP Code (in $seconds seconds)';
  }

  @override
  String get onboarding_otp_verification_success_resend => 'OTP code resent';

  @override
  String onboarding_otp_verification_error_cooldown(int seconds) {
    return 'Please wait $seconds seconds before requesting OTP again.';
  }

  @override
  String get onboarding_linking_success_title => 'Linking Successful!';

  @override
  String get onboarding_linking_success_description =>
      'Your account has been linked with parent. Learning data from 7-day trial has been preserved.';

  @override
  String get onboarding_linking_success_data_saved_title => '✅ Data saved:';

  @override
  String get onboarding_linking_success_data_exercises => 'exercises';

  @override
  String get onboarding_linking_success_data_skills => 'skills';

  @override
  String get onboarding_linking_success_data_days => 'days';

  @override
  String get onboarding_linking_success_parent_info_title =>
      'Login information for parent:';

  @override
  String get onboarding_linking_success_parent_username_label => 'Username:';

  @override
  String get onboarding_linking_success_parent_password_label => 'Password:';

  @override
  String get onboarding_linking_success_parent_password_note =>
      'Temporary password, please change after login';

  @override
  String get onboarding_linking_success_parent_dashboard_label =>
      'Access dashboard:';

  @override
  String get onboarding_linking_success_button_complete => 'Complete';

  @override
  String onboarding_linking_success_copy_success(String label) {
    return 'Copied $label';
  }

  @override
  String get onboarding_otp_error_phone_invalid =>
      'Invalid phone number. Please enter Vietnamese phone number (10 digits).';

  @override
  String get onboarding_otp_error_send_failed =>
      'Cannot send OTP code. Please try again.';

  @override
  String get onboarding_otp_error_rate_limit =>
      'You\'ve sent too many requests. Maximum 3 times per day. Please try again tomorrow.';

  @override
  String get onboarding_otp_error_trial_not_found =>
      'Trial not found. Please start trial first.';

  @override
  String get onboarding_otp_error_missing_parameter =>
      'Missing required information. Please try again.';

  @override
  String get onboarding_otp_error_verify_invalid =>
      'OTP code must have 6 digits.';

  @override
  String get onboarding_otp_error_verify_failed =>
      'OTP code is incorrect. Please try again.';

  @override
  String onboarding_otp_error_resend_cooldown(int seconds) {
    return 'Please wait $seconds seconds before requesting OTP again.';
  }

  @override
  String get profile_title => 'Profile';

  @override
  String get profile_menu_personal_info => 'Personal Information';

  @override
  String get profile_menu_trial_status => 'Trial Status';

  @override
  String get profile_menu_trial_status_warning => 'Less than 2 days remaining';

  @override
  String get profile_menu_settings => 'Settings';

  @override
  String get profile_menu_logout => 'Logout';

  @override
  String get core_widget_error_retry_default => 'Retry';

  @override
  String get core_widget_empty_action_default => 'Start';

  @override
  String get practice_session_resume_title => 'Continue Practice';

  @override
  String get practice_session_current_mastery => 'Current Mastery:';

  @override
  String practice_session_progress_done(int completed, int total) {
    return 'Done: $completed/$total questions';
  }

  @override
  String practice_session_started_at(String date) {
    return 'Started: $date';
  }

  @override
  String practice_session_last_activity(String date) {
    return 'Last activity: $date';
  }

  @override
  String practice_session_continue_from_question(int questionNumber) {
    return 'Continue from question $questionNumber';
  }

  @override
  String get practice_session_restart_from_beginning =>
      'Restart from beginning';

  @override
  String get practice_session_discard_session => 'Discard session';

  @override
  String get practice_session_restart_dialog_title => 'Restart';

  @override
  String get practice_session_restart_dialog_message =>
      'Are you sure you want to restart from the beginning? Current progress will be lost.';

  @override
  String get practice_session_restart_dialog_button => 'Restart';

  @override
  String get practice_session_discard_dialog_title => 'Discard Session';

  @override
  String get practice_session_discard_dialog_message =>
      'Are you sure you want to discard this session? Progress will be lost.';

  @override
  String get practice_session_discard_dialog_button => 'Discard';

  @override
  String get practice_session_error_invalid_id => 'Invalid session ID';

  @override
  String get practice_session_error_not_found => 'Session not found';

  @override
  String get practice_session_error_load_failed =>
      'Cannot load session information';

  @override
  String get practice_session_error_cancel_failed =>
      'Cannot cancel session. Please try again.';

  @override
  String get practice_session_error_expired_message =>
      'Session has expired or does not exist. Start a new session?';

  @override
  String get practice_session_error_expired =>
      'Session has expired or does not exist.';

  @override
  String get practice_session_complete_title => 'Complete';

  @override
  String get practice_session_complete_message => 'Session completed!';

  @override
  String practice_session_complete_mastery_increase(
    int previous,
    int current,
    int change,
  ) {
    return 'Mastery increased: $previous% → $current% (+$change%)';
  }

  @override
  String get practice_session_complete_improvement_message =>
      'You\'ve improved a lot!';

  @override
  String get practice_session_complete_progress_saved =>
      'Progress has been saved. You can continue later!';

  @override
  String practice_session_complete_stat_questions_done(int total) {
    return '$total/$total questions done';
  }

  @override
  String practice_session_complete_stat_correct(int count) {
    return 'Correct: $count questions';
  }

  @override
  String practice_session_complete_stat_incorrect(int count) {
    return 'Incorrect: $count questions';
  }

  @override
  String practice_session_complete_stat_accuracy(int accuracy) {
    return 'Accuracy: $accuracy%';
  }

  @override
  String get practice_session_skill_status_mastered => 'Mastered';

  @override
  String get practice_session_skill_status_improving => 'Improving';

  @override
  String get practice_session_skill_status_unstable => 'Unstable';

  @override
  String get practice_session_skill_status_weak => 'Weak';

  @override
  String get practice_session_recommendation_ready_mini_test =>
      '🎯 Ready for Mini Test!';

  @override
  String get practice_session_recommendation_do_mini_test =>
      'You\'ve done enough! Take the Mini Test to check your knowledge';

  @override
  String practice_session_recommendation_more_practice(int remaining) {
    return 'Do $remaining more questions to reach 70%';
  }

  @override
  String get practice_session_complete_action_mini_test => 'Take Mini Test';

  @override
  String get practice_session_complete_action_more_practice => 'More Practice';

  @override
  String get practice_session_complete_action_review => 'Review Answers';

  @override
  String get practice_session_complete_action_home => 'Back to Home';

  @override
  String get practice_result_title => 'Result';

  @override
  String get practice_result_correct => 'Correct!';

  @override
  String get practice_result_incorrect => 'Incorrect';

  @override
  String get practice_result_encouragement_correct => 'Great!';

  @override
  String get practice_result_encouragement_incorrect =>
      'That\'s okay, you\'ve learned something!';

  @override
  String practice_result_correct_answer(String answer) {
    return 'Correct answer: $answer';
  }

  @override
  String practice_result_explanation_label(String explanation) {
    return 'Explanation: $explanation';
  }

  @override
  String practice_result_progress_done(int current, int total) {
    return 'Done: $current/$total questions';
  }

  @override
  String practice_result_progress_percentage(String percentage) {
    return 'Progress: $percentage%';
  }

  @override
  String get practice_result_difficulty_increase_notification =>
      '🎉 Difficulty will increase in the next question!';

  @override
  String get practice_result_difficulty_decrease_notification =>
      '💡 Difficulty will decrease to help you understand better';

  @override
  String get practice_result_warning_check_steps =>
      '⚠️ Note: Please check your solution steps again';

  @override
  String get practice_result_action_next_question => 'Next Question';

  @override
  String get practice_result_action_pause => 'Pause';

  @override
  String get practice_result_action_review_explanation => 'Review Explanation';

  @override
  String get practice_result_explanation_dialog_title => 'Explanation';

  @override
  String practice_result_explanation_dialog_answer_label(String answer) {
    return 'Answer: $answer';
  }

  @override
  String get practice_result_explanation_generic =>
      'Please review the solution steps in the explanation section.';
}
