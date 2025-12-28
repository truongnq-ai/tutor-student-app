// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get language_vietnamese => 'Tiếng Việt';

  @override
  String get language_english => 'English';

  @override
  String get navigation_home => 'Trang chủ';

  @override
  String get navigation_profile => 'Hồ sơ';

  @override
  String get auth_login_title => 'Đăng nhập';

  @override
  String get auth_login_button => 'Đăng nhập';

  @override
  String get auth_login_remember_me => 'Ghi nhớ đăng nhập';

  @override
  String get auth_login_forgot_password => 'Quên mật khẩu?';

  @override
  String get auth_signup_title => 'Đăng ký';

  @override
  String get auth_signup_button => 'Đăng ký';

  @override
  String get auth_signin_button => 'Đăng nhập';

  @override
  String get auth_forgot_password_title => 'Quên mật khẩu';

  @override
  String get auth_forgot_password_description =>
      'Nhập email đã đăng ký và chúng tôi sẽ gửi hướng dẫn đặt lại mật khẩu.';

  @override
  String get auth_forgot_password_button => 'Gửi';

  @override
  String get auth_forgot_password_back_to_login => 'Quay lại đăng nhập';

  @override
  String get auth_forgot_password_enter_associated_email =>
      'Nhập email đã đăng ký';

  @override
  String get auth_reset_password_title => 'Đặt lại mật khẩu';

  @override
  String get auth_reset_password_create_new => 'Tạo mật khẩu mới';

  @override
  String get auth_reset_password_new_password => 'Mật khẩu mới';

  @override
  String get auth_reset_password_confirm_password => 'Xác nhận mật khẩu';

  @override
  String get auth_reset_password_hint =>
      'Mật khẩu mới phải khác với các mật khẩu đã sử dụng trước đó.';

  @override
  String get auth_reset_password_button => 'Đặt lại mật khẩu';

  @override
  String get auth_reset_password_success =>
      'Mật khẩu đã được thay đổi thành công';

  @override
  String get auth_reset_password_success_message =>
      'Mật khẩu của bạn đã được thay đổi thành công.';

  @override
  String get auth_account_dont_have => 'Chưa có tài khoản? ';

  @override
  String get auth_account_already_have => 'Đã có tài khoản? ';

  @override
  String get auth_entry_title => 'Chọn cách đăng nhập';

  @override
  String get auth_entry_divider_or => 'Hoặc';

  @override
  String get auth_entry_manual_button => 'Đăng nhập / Đăng ký thủ công';

  @override
  String get auth_entry_no_account => 'Bạn chưa có tài khoản? ';

  @override
  String get auth_entry_manual_signup => 'Đăng ký thủ công';

  @override
  String get auth_login_error_invalid_credentials =>
      'Tên đăng nhập hoặc mật khẩu không đúng. Vui lòng thử lại.';

  @override
  String get auth_oauth_error_student_not_found =>
      'Không tìm thấy thông tin học sinh';

  @override
  String get auth_registration_success_message =>
      'Đăng ký thành công. Bắt đầu dùng thử miễn phí!';

  @override
  String get auth_registration_field_full_name => 'Họ và tên';

  @override
  String get auth_registration_field_username => 'Tên đăng nhập';

  @override
  String get auth_registration_field_confirm_password => 'Xác nhận mật khẩu';

  @override
  String get auth_registration_validation_full_name_required =>
      'Vui lòng nhập họ và tên';

  @override
  String get auth_registration_validation_username_required =>
      'Vui lòng nhập tên đăng nhập';

  @override
  String get auth_registration_validation_username_format =>
      'Tên đăng nhập chỉ được dùng chữ và số, không phân biệt hoa/thường';

  @override
  String get auth_registration_validation_confirm_password_required =>
      'Vui lòng xác nhận mật khẩu';

  @override
  String get auth_registration_validation_password_mismatch =>
      'Mật khẩu không khớp';

  @override
  String get auth_set_credential_title => 'Đặt thông tin đăng nhập';

  @override
  String get auth_set_credential_description =>
      'Vui lòng đặt tên đăng nhập và mật khẩu để hoàn tất đăng ký';

  @override
  String get auth_set_credential_success_message =>
      'Đặt thông tin đăng nhập thành công.';

  @override
  String auth_set_credential_error_generic(String error) {
    return 'Có lỗi xảy ra: $error';
  }

  @override
  String get auth_verification_check_mail => 'Kiểm tra email';

  @override
  String auth_verification_enter_code(String email) {
    return 'Vui lòng nhập mã 4 chữ số đã gửi đến email $email.';
  }

  @override
  String get auth_verification_enter_code_label => 'Nhập mã xác minh';

  @override
  String get auth_verification_didnt_get_code => 'Không nhận được mã? ';

  @override
  String get auth_verification_resend => 'Nhấn để gửi lại';

  @override
  String get auth_verification_did_not_receive =>
      'Không nhận được email? Kiểm tra thư mục spam. hoặc ';

  @override
  String get auth_verification_try_another_email => 'thử email khác';

  @override
  String get common_field_email => 'Email';

  @override
  String get common_field_email_address => 'Địa chỉ email';

  @override
  String get common_field_password => 'Mật khẩu';

  @override
  String get common_field_first_name => 'Họ';

  @override
  String get common_field_last_name => 'Tên';

  @override
  String get common_button_continue => 'Tiếp tục';

  @override
  String get common_button_ok => 'OK';

  @override
  String get common_button_cancel => 'Huỷ';

  @override
  String get common_button_close => 'Đóng';

  @override
  String get common_button_back => 'Quay lại';

  @override
  String get common_button_get_started => 'Bắt đầu';

  @override
  String get common_button_logout => 'Đăng xuất';

  @override
  String get common_button_start_learning => 'Bắt đầu học';

  @override
  String get common_button_load_more => 'Tải thêm';

  @override
  String get validation_required => 'Trường này là bắt buộc';

  @override
  String get validation_email_required => 'Email là bắt buộc';

  @override
  String get validation_email_invalid => 'Vui lòng nhập địa chỉ email hợp lệ';

  @override
  String get validation_password_required => 'Mật khẩu là bắt buộc';

  @override
  String validation_length_min(int min) {
    return 'Trường này phải có ít nhất $min ký tự';
  }

  @override
  String validation_length_max(int max) {
    return 'Trường này phải có tối đa $max ký tự';
  }

  @override
  String validation_password_min_length(String minLength) {
    return 'Mật khẩu phải có ít nhất $minLength ký tự';
  }

  @override
  String get validation_password_number =>
      'Mật khẩu phải chứa ít nhất một chữ số';

  @override
  String get validation_password_lowercase =>
      'Mật khẩu phải chứa ít nhất một chữ thường';

  @override
  String get validation_password_uppercase =>
      'Mật khẩu phải chứa ít nhất một chữ hoa';

  @override
  String get validation_password_special_char =>
      'Mật khẩu phải chứa ít nhất một ký tự đặc biệt';

  @override
  String get error_network_connection =>
      'Không thể kết nối. Vui lòng kiểm tra internet.';

  @override
  String get error_network_timeout => 'Kết nối quá lâu. Vui lòng thử lại.';

  @override
  String get error_network_generic =>
      'Vui lòng kiểm tra kết nối internet và thử lại.';

  @override
  String get error_auth_unauthorized =>
      'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';

  @override
  String get error_system_internal => 'Lỗi hệ thống. Vui lòng thử lại sau.';

  @override
  String get error_resource_not_found => 'Không tìm thấy.';

  @override
  String get error_generic => 'Có lỗi xảy ra';

  @override
  String get practice_question_title => 'Câu hỏi';

  @override
  String practice_question_counter(int current, int total) {
    return 'Câu $current/$total';
  }

  @override
  String practice_question_progress(int current, int total) {
    return '$current/$total bài đã làm';
  }

  @override
  String get practice_question_select_answer => 'Chọn đáp án:';

  @override
  String get practice_question_enter_answer => 'Nhập đáp án:';

  @override
  String get practice_question_answer_hint => 'Nhập đáp án của bạn';

  @override
  String get practice_question_check => 'Kiểm tra';

  @override
  String get practice_question_hint => '💡 Gợi ý';

  @override
  String practice_question_skill_label(String skillName) {
    return 'Kỹ năng: $skillName';
  }

  @override
  String get practice_question_not_found => 'Không tìm thấy câu hỏi';

  @override
  String get practice_question_load_error => 'Không thể tải câu hỏi';

  @override
  String get practice_skill_selection_title => 'Chọn kỹ năng để luyện tập';

  @override
  String get practice_skill_selection_description =>
      'Bạn có thể chọn một trong các kỹ năng sau để cải thiện';

  @override
  String get practice_skill_selection_info =>
      'Chọn một kỹ năng để bắt đầu luyện tập. Hệ thống sẽ tạo bài tập phù hợp với trình độ của bạn.';

  @override
  String get practice_skill_selection_no_weak_skills =>
      'Không có skill yếu. Tuyệt vời!';

  @override
  String get practice_skill_selection_load_error =>
      'Không thể tải danh sách kỹ năng';

  @override
  String get practice_skill_selection_back_to_home => 'Về trang chủ';

  @override
  String get practice_skill_selection_welcome_title =>
      'Chào mừng bạn đến với Luyện tập!';

  @override
  String get practice_skill_selection_welcome_description =>
      'Để bắt đầu, hãy xem gợi ý học tập hôm nay của bạn. Hệ thống sẽ đề xuất kỹ năng phù hợp nhất để bạn luyện tập.';

  @override
  String get practice_skill_selection_welcome_cta =>
      'Xem gợi ý học tập hôm nay';

  @override
  String get practice_skill_selection_welcome_tip_title => 'Mẹo nhỏ';

  @override
  String get practice_skill_selection_welcome_tip_description =>
      'Bắt đầu với kỹ năng cơ bản nhất sẽ giúp bạn xây dựng nền tảng vững chắc. Hệ thống sẽ tự động gợi ý kỹ năng phù hợp dựa trên tiến độ của bạn.';

  @override
  String get practice_skill_status_weak => 'Yếu';

  @override
  String get practice_skill_status_unstable => 'Chưa vững';

  @override
  String get practice_history_title => 'Lịch sử luyện tập';

  @override
  String get practice_history_empty_title => 'Bạn chưa có bài luyện tập nào';

  @override
  String get practice_history_empty_description =>
      'Hãy bắt đầu học để xem lịch sử ở đây';

  @override
  String get practice_history_load_error => 'Không thể tải lịch sử';

  @override
  String practice_card_exercises(int count) {
    return '$count bài';
  }

  @override
  String practice_card_correct(int count) {
    return 'Đúng: $count';
  }

  @override
  String practice_card_incorrect(int count) {
    return 'Sai: $count';
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
    return 'Thời gian: $duration';
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
    return 'Thời gian: ${seconds}s';
  }

  @override
  String difficulty_label(String level) {
    return 'Độ khó: $level';
  }

  @override
  String get difficulty_easy => 'Dễ';

  @override
  String get difficulty_medium => 'Trung bình';

  @override
  String get difficulty_hard => 'Khó';

  @override
  String get difficulty_very_hard => 'Rất khó';

  @override
  String get difficulty_fair => 'Khá';

  @override
  String get learning_today_title => 'Học hôm nay';

  @override
  String learning_difficulty_label(String level) {
    return 'Độ khó: $level';
  }

  @override
  String learning_skill_estimated_time(int minutes) {
    return '~$minutes phút';
  }

  @override
  String get learning_plan_today_title => 'Lộ trình hôm nay';

  @override
  String get learning_plan_progress_overview_title => 'Tiến độ tổng quan';

  @override
  String get learning_plan_week_progress_title => 'Tiến độ tuần';

  @override
  String get learning_plan_stat_total_skills => 'Tổng kỹ năng';

  @override
  String get learning_plan_stat_mastered_skills => 'Đã thành thạo';

  @override
  String learning_plan_week_streak(int days) {
    return '$days ngày liên tiếp';
  }

  @override
  String learning_plan_week_exercises_done(int count) {
    return '$count bài đã làm';
  }

  @override
  String get learning_plan_empty_title => 'Chưa có lộ trình hôm nay';

  @override
  String get learning_plan_empty_description =>
      'Hãy bắt đầu học để xem lộ trình của bạn!';

  @override
  String get learning_plan_error_load_failed =>
      'Không thể tải lộ trình học tập';

  @override
  String get onboarding_learn_flutter_title => 'Học Flutter';

  @override
  String get onboarding_learn_flutter_subtitle => 'Xây dựng ứng dụng tuyệt vời';

  @override
  String get onboarding_learn_flutter_description =>
      'Học Flutter và xây dựng ứng dụng đẹp, nhanh cho nhiều nền tảng.';

  @override
  String get onboarding_join_community_title => 'Tham gia cộng đồng';

  @override
  String get onboarding_join_community_subtitle => 'Kết nối với nhà phát triển';

  @override
  String get onboarding_join_community_description =>
      'Tham gia cộng đồng nhà phát triển và chia sẻ kiến thức của bạn.';

  @override
  String get onboarding_build_deploy_title => 'Xây dựng & Triển khai';

  @override
  String get onboarding_build_deploy_subtitle => 'Phát hành ứng dụng';

  @override
  String get onboarding_build_deploy_description =>
      'Xây dựng và triển khai ứng dụng của bạn lên production một cách dễ dàng.';

  @override
  String get onboarding_welcome_title => 'Chào mừng đến với Tutor!';

  @override
  String get onboarding_welcome_subtitle =>
      'Gia sư Toán AI cá nhân hoá cho bạn';

  @override
  String get onboarding_welcome_trial_badge =>
      'Dùng thử miễn phí 7 ngày - Đầy đủ tính năng';

  @override
  String get onboarding_welcome_button_try_now => 'Dùng thử ngay';

  @override
  String get onboarding_welcome_button_learn_more => 'Tìm hiểu thêm';

  @override
  String get onboarding_welcome_already_have_account => 'Đã có tài khoản? ';

  @override
  String get onboarding_welcome_login_link => 'Đăng nhập';

  @override
  String get onboarding_select_grade_title => 'Chọn lớp học';

  @override
  String get onboarding_select_grade_header => 'Bạn đang học lớp mấy?';

  @override
  String get onboarding_select_grade_button_retry => 'Thử lại';

  @override
  String get onboarding_grade_6_title => 'Lớp 6';

  @override
  String get onboarding_grade_6_description => 'Chương trình Toán lớp 6';

  @override
  String get onboarding_grade_7_title => 'Lớp 7';

  @override
  String get onboarding_grade_7_description => 'Chương trình Toán lớp 7';

  @override
  String get onboarding_select_goal_title => 'Mục tiêu học tập';

  @override
  String get onboarding_select_goal_header => 'Mục tiêu học tập của bạn là gì?';

  @override
  String get onboarding_select_goal_button_start => 'Bắt đầu học';

  @override
  String get onboarding_select_goal_button_retry => 'Thử lại';

  @override
  String get onboarding_select_goal_semantics_selected => 'Đã chọn';

  @override
  String get onboarding_select_goal_semantics_not_selected => 'Chưa chọn';

  @override
  String get onboarding_goal_follow_curriculum_title => 'Học theo chương';

  @override
  String get onboarding_goal_follow_curriculum_description =>
      'Học đúng tiến độ chương trình';

  @override
  String get onboarding_goal_strengthen_weakness_title =>
      'Củng cố kiến thức còn yếu';

  @override
  String get onboarding_goal_strengthen_weakness_description =>
      'Tập trung vào phần bạn chưa vững';

  @override
  String get onboarding_goal_exam_preparation_title =>
      'Ôn tập cho bài kiểm tra';

  @override
  String get onboarding_goal_exam_preparation_description =>
      'Chuẩn bị cho kỳ thi sắp tới';

  @override
  String get onboarding_trial_start_title => 'Bắt đầu dùng thử';

  @override
  String get onboarding_trial_start_header => 'Bắt đầu dùng thử miễn phí!';

  @override
  String get onboarding_trial_start_description =>
      'Bạn có 7 ngày để trải nghiệm đầy đủ tính năng của Tutor';

  @override
  String get onboarding_trial_start_button => 'Bắt đầu';

  @override
  String get onboarding_trial_start_button_retry => 'Thử lại';

  @override
  String get onboarding_trial_start_already_have_account => 'Đã có tài khoản? ';

  @override
  String get onboarding_trial_start_login_link => 'Đăng nhập';

  @override
  String get onboarding_trial_feature_unlimited_math =>
      'Giải bài Toán không giới hạn (3-5 lượt/ngày)';

  @override
  String get onboarding_trial_feature_daily_plan => 'Lộ trình học hằng ngày';

  @override
  String get onboarding_trial_feature_personalized_practice =>
      'Luyện tập cá nhân hoá';

  @override
  String get onboarding_trial_feature_mini_test =>
      'Mini test kiểm tra kiến thức';

  @override
  String get onboarding_trial_info_title => 'Thông tin dùng thử';

  @override
  String get onboarding_trial_info_duration_label => 'Thời gian:';

  @override
  String get onboarding_trial_info_duration_value => '7 ngày';

  @override
  String get onboarding_trial_info_start_label => 'Bắt đầu:';

  @override
  String get onboarding_trial_info_end_label => 'Kết thúc:';

  @override
  String get onboarding_trial_info_note =>
      'Dữ liệu học tập sẽ được lưu lại khi bạn liên kết với phụ huynh';

  @override
  String get onboarding_trial_status_title => 'Trạng thái dùng thử';

  @override
  String onboarding_trial_status_days_remaining(int days) {
    return '$days ngày còn lại';
  }

  @override
  String get onboarding_trial_status_start_label => 'Bắt đầu:';

  @override
  String get onboarding_trial_status_end_label => 'Kết thúc:';

  @override
  String onboarding_trial_status_progress_label(int used, int total) {
    return 'Đã dùng: $used/$total ngày';
  }

  @override
  String get onboarding_trial_status_stats_title => 'Thống kê sử dụng';

  @override
  String get onboarding_trial_status_stats_solves_today =>
      'Số lượt giải bài hôm nay:';

  @override
  String get onboarding_trial_status_stats_total_exercises =>
      'Tổng bài đã làm:';

  @override
  String get onboarding_trial_status_stats_skills_learned => 'Số skill đã học:';

  @override
  String get onboarding_trial_status_features_title =>
      'Bạn đang có quyền truy cập:';

  @override
  String get onboarding_trial_status_feature_unlimited_math =>
      'Giải bài Toán (3-5 lượt/ngày)';

  @override
  String get onboarding_trial_status_feature_daily_plan =>
      'Lộ trình học hằng ngày';

  @override
  String get onboarding_trial_status_feature_personalized_practice =>
      'Luyện tập cá nhân hoá';

  @override
  String get onboarding_trial_status_feature_mini_test => 'Mini test';

  @override
  String onboarding_trial_status_warning_message(int days) {
    return 'Còn $days ngày. Hãy liên kết với phụ huynh để tiếp tục học!';
  }

  @override
  String get onboarding_trial_status_button_link_parent =>
      'Liên kết với phụ huynh';

  @override
  String get onboarding_trial_status_button_continue_learning => 'Tiếp tục học';

  @override
  String get onboarding_trial_status_button_retry => 'Thử lại';

  @override
  String get onboarding_trial_status_error_expired => 'Trial đã hết hạn';

  @override
  String get onboarding_trial_status_error_not_found => 'Không tìm thấy trial';

  @override
  String get onboarding_trial_status_error_generic => 'Có lỗi xảy ra';

  @override
  String get onboarding_trial_expiry_title => 'Liên kết phụ huynh';

  @override
  String get onboarding_trial_expiry_header =>
      'Thời gian dùng thử đã kết thúc!';

  @override
  String get onboarding_trial_expiry_description =>
      'Bạn đã hoàn thành 7 ngày dùng thử. Để tiếp tục học, bạn cần liên kết với tài khoản phụ huynh';

  @override
  String get onboarding_trial_expiry_achievement_title => 'Bạn đã làm được:';

  @override
  String get onboarding_trial_expiry_achievement_exercises => 'bài tập';

  @override
  String get onboarding_trial_expiry_achievement_skills => 'skill đã học';

  @override
  String get onboarding_trial_expiry_achievement_streak => 'ngày liên tiếp';

  @override
  String get onboarding_trial_expiry_note =>
      'Dữ liệu học tập của bạn sẽ được giữ lại khi liên kết';

  @override
  String get onboarding_trial_expiry_phone_label =>
      'Nhập số điện thoại phụ huynh';

  @override
  String get onboarding_trial_expiry_phone_hint => '0912345678';

  @override
  String get onboarding_trial_expiry_phone_helper => 'Ví dụ: 0912345678';

  @override
  String get onboarding_trial_expiry_phone_validation_required =>
      'Vui lòng nhập số điện thoại phụ huynh';

  @override
  String get onboarding_trial_expiry_phone_validation_format =>
      'Số điện thoại không hợp lệ. Vui lòng nhập số điện thoại Việt Nam (10 số).';

  @override
  String get onboarding_trial_expiry_button_send_otp => 'Gửi mã OTP';

  @override
  String get onboarding_trial_expiry_footer_note =>
      'Mã OTP sẽ được gửi đến số điện thoại của phụ huynh';

  @override
  String get onboarding_trial_expiry_alternative_link =>
      'Hoặc nhận mã liên kết';

  @override
  String get onboarding_trial_expiry_error_rate_limit =>
      '⚠️ Bạn đã gửi quá 3 lần hôm nay. Vui lòng thử lại vào ngày mai.';

  @override
  String get onboarding_trial_expiry_error_trial_not_found =>
      'Không tìm thấy trial. Vui lòng thử lại.';

  @override
  String get onboarding_otp_verification_title => 'Nhập mã OTP';

  @override
  String onboarding_otp_verification_description(String phone) {
    return 'Mã OTP đã được gửi đến số điện thoại $phone. Vui lòng hỏi phụ huynh lấy mã.';
  }

  @override
  String onboarding_otp_verification_input_label(int index) {
    return 'Ô nhập mã OTP số $index';
  }

  @override
  String onboarding_otp_verification_timer_label(String time) {
    return 'Thời gian còn lại: $time';
  }

  @override
  String get onboarding_otp_verification_timer_expired =>
      'Mã OTP đã hết hạn. Vui lòng gửi lại mã.';

  @override
  String onboarding_otp_verification_timer_remaining(String time) {
    return 'Còn lại: $time';
  }

  @override
  String get onboarding_otp_verification_button_confirm => 'Xác nhận';

  @override
  String get onboarding_otp_verification_button_resend => 'Gửi lại mã OTP';

  @override
  String onboarding_otp_verification_button_resend_cooldown(int seconds) {
    return 'Gửi lại mã OTP (còn $seconds giây)';
  }

  @override
  String get onboarding_otp_verification_success_resend => 'Đã gửi lại mã OTP';

  @override
  String onboarding_otp_verification_error_cooldown(int seconds) {
    return 'Vui lòng đợi $seconds giây trước khi yêu cầu lại OTP.';
  }

  @override
  String get onboarding_linking_success_title => 'Liên kết thành công!';

  @override
  String get onboarding_linking_success_description =>
      'Tài khoản của bạn đã được liên kết với phụ huynh. Dữ liệu học tập trong 7 ngày dùng thử đã được giữ lại.';

  @override
  String get onboarding_linking_success_data_saved_title =>
      '✅ Dữ liệu đã được lưu:';

  @override
  String get onboarding_linking_success_data_exercises => 'bài tập';

  @override
  String get onboarding_linking_success_data_skills => 'skill';

  @override
  String get onboarding_linking_success_data_days => 'ngày';

  @override
  String get onboarding_linking_success_parent_info_title =>
      'Thông tin đăng nhập cho phụ huynh:';

  @override
  String get onboarding_linking_success_parent_username_label =>
      'Tên đăng nhập:';

  @override
  String get onboarding_linking_success_parent_password_label => 'Mật khẩu:';

  @override
  String get onboarding_linking_success_parent_password_note =>
      'Mật khẩu tạm thời, vui lòng đổi sau khi đăng nhập';

  @override
  String get onboarding_linking_success_parent_dashboard_label =>
      'Truy cập dashboard:';

  @override
  String get onboarding_linking_success_button_complete => 'Hoàn tất';

  @override
  String onboarding_linking_success_copy_success(String label) {
    return 'Đã sao chép $label';
  }

  @override
  String get onboarding_otp_error_phone_invalid =>
      'Số điện thoại không hợp lệ. Vui lòng nhập số điện thoại Việt Nam (10 số).';

  @override
  String get onboarding_otp_error_send_failed =>
      'Không thể gửi mã OTP. Vui lòng thử lại.';

  @override
  String get onboarding_otp_error_rate_limit =>
      'Bạn đã gửi quá nhiều yêu cầu. Tối đa 3 lần mỗi ngày. Vui lòng thử lại vào ngày mai.';

  @override
  String get onboarding_otp_error_trial_not_found =>
      'Không tìm thấy trial. Vui lòng bắt đầu trial trước.';

  @override
  String get onboarding_otp_error_missing_parameter =>
      'Thiếu thông tin cần thiết. Vui lòng thử lại.';

  @override
  String get onboarding_otp_error_verify_invalid => 'Mã OTP phải có 6 chữ số.';

  @override
  String get onboarding_otp_error_verify_failed =>
      'Mã OTP không đúng. Vui lòng thử lại.';

  @override
  String onboarding_otp_error_resend_cooldown(int seconds) {
    return 'Vui lòng đợi $seconds giây trước khi yêu cầu lại OTP.';
  }

  @override
  String get profile_title => 'Hồ sơ';

  @override
  String get profile_menu_personal_info => 'Thông tin cá nhân';

  @override
  String get profile_menu_trial_status => 'Trạng thái dùng thử';

  @override
  String get profile_menu_trial_status_warning => 'Còn ít hơn 2 ngày';

  @override
  String get profile_menu_settings => 'Cài đặt';

  @override
  String get profile_menu_logout => 'Đăng xuất';

  @override
  String get core_widget_error_retry_default => 'Thử lại';

  @override
  String get core_widget_empty_action_default => 'Bắt đầu';

  @override
  String get practice_session_resume_title => 'Tiếp tục luyện tập';

  @override
  String get practice_session_current_mastery => 'Mastery hiện tại:';

  @override
  String practice_session_progress_done(int completed, int total) {
    return 'Đã làm: $completed/$total bài';
  }

  @override
  String practice_session_started_at(String date) {
    return 'Bắt đầu: $date';
  }

  @override
  String practice_session_last_activity(String date) {
    return 'Lần cuối: $date';
  }

  @override
  String practice_session_continue_from_question(int questionNumber) {
    return 'Tiếp tục từ câu $questionNumber';
  }

  @override
  String get practice_session_restart_from_beginning => 'Bắt đầu lại từ đầu';

  @override
  String get practice_session_discard_session => 'Bỏ session này';

  @override
  String get practice_session_restart_dialog_title => 'Bắt đầu lại';

  @override
  String get practice_session_restart_dialog_message =>
      'Bạn có chắc muốn bắt đầu lại từ đầu? Tiến độ hiện tại sẽ bị mất.';

  @override
  String get practice_session_restart_dialog_button => 'Bắt đầu lại';

  @override
  String get practice_session_discard_dialog_title => 'Bỏ session';

  @override
  String get practice_session_discard_dialog_message =>
      'Bạn có chắc muốn bỏ session này? Tiến độ sẽ bị mất.';

  @override
  String get practice_session_discard_dialog_button => 'Bỏ session';

  @override
  String get practice_session_error_invalid_id => 'Session ID không hợp lệ';

  @override
  String get practice_session_error_not_found => 'Không tìm thấy session';

  @override
  String get practice_session_error_load_failed =>
      'Không thể tải thông tin session';

  @override
  String get practice_session_error_cancel_failed =>
      'Không thể hủy session. Vui lòng thử lại.';

  @override
  String get practice_session_error_expired_message =>
      'Session đã hết hạn hoặc không tồn tại. Bắt đầu session mới?';

  @override
  String get practice_session_error_expired =>
      'Session đã hết hạn hoặc không tồn tại.';

  @override
  String get practice_session_complete_title => 'Hoàn thành';

  @override
  String get practice_session_complete_message => 'Hoàn thành session!';

  @override
  String practice_session_complete_mastery_increase(
    int previous,
    int current,
    int change,
  ) {
    return 'Mastery tăng: $previous% → $current% (+$change%)';
  }

  @override
  String get practice_session_complete_improvement_message =>
      'Bạn đã cải thiện rất nhiều!';

  @override
  String get practice_session_complete_progress_saved =>
      'Tiến độ đã được lưu. Bạn có thể tiếp tục sau!';

  @override
  String practice_session_complete_stat_questions_done(int total) {
    return '$total/$total câu đã làm';
  }

  @override
  String practice_session_complete_stat_correct(int count) {
    return 'Đúng: $count câu';
  }

  @override
  String practice_session_complete_stat_incorrect(int count) {
    return 'Sai: $count câu';
  }

  @override
  String practice_session_complete_stat_accuracy(int accuracy) {
    return 'Tỉ lệ: $accuracy%';
  }

  @override
  String get practice_session_skill_status_mastered => 'Thành thạo';

  @override
  String get practice_session_skill_status_improving => 'Đang cải thiện';

  @override
  String get practice_session_skill_status_unstable => 'Chưa vững';

  @override
  String get practice_session_skill_status_weak => 'Yếu';

  @override
  String get practice_session_recommendation_ready_mini_test =>
      '🎯 Sẵn sàng cho Mini Test!';

  @override
  String get practice_session_recommendation_do_mini_test =>
      'Bạn đã làm đủ bài! Hãy làm Mini Test để kiểm tra kiến thức';

  @override
  String practice_session_recommendation_more_practice(int remaining) {
    return 'Làm thêm $remaining bài để đạt 70%';
  }

  @override
  String get practice_session_complete_action_mini_test => 'Làm Mini Test';

  @override
  String get practice_session_complete_action_more_practice => 'Làm thêm bài';

  @override
  String get practice_session_complete_action_review => 'Xem lại bài làm';

  @override
  String get practice_session_complete_action_home => 'Về trang chủ';

  @override
  String get practice_result_title => 'Kết quả';

  @override
  String get practice_result_correct => 'Chính xác!';

  @override
  String get practice_result_incorrect => 'Chưa đúng';

  @override
  String get practice_result_encouragement_correct => 'Tuyệt vời!';

  @override
  String get practice_result_encouragement_incorrect =>
      'Không sao, bạn đã học được điều gì đó!';

  @override
  String practice_result_correct_answer(String answer) {
    return 'Đáp án đúng: $answer';
  }

  @override
  String practice_result_explanation_label(String explanation) {
    return 'Giải thích: $explanation';
  }

  @override
  String practice_result_progress_done(int current, int total) {
    return 'Đã làm: $current/$total bài';
  }

  @override
  String practice_result_progress_percentage(String percentage) {
    return 'Tiến độ: $percentage%';
  }

  @override
  String get practice_result_difficulty_increase_notification =>
      '🎉 Độ khó sẽ tăng ở câu tiếp theo!';

  @override
  String get practice_result_difficulty_decrease_notification =>
      '💡 Độ khó sẽ giảm để bạn dễ hiểu hơn';

  @override
  String get practice_result_warning_check_steps =>
      '⚠️ Lưu ý: Hãy kiểm tra lại các bước giải của bạn';

  @override
  String get practice_result_action_next_question => 'Câu tiếp theo';

  @override
  String get practice_result_action_pause => 'Tạm dừng';

  @override
  String get practice_result_action_review_explanation => 'Xem lại giải thích';

  @override
  String get practice_result_explanation_dialog_title => 'Giải thích';

  @override
  String practice_result_explanation_dialog_answer_label(String answer) {
    return 'Đáp án: $answer';
  }

  @override
  String get practice_result_explanation_generic =>
      'Hãy xem lại các bước giải trong phần giải thích.';
}
