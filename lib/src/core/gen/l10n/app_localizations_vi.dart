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
  String get auth_reset_password_title => 'Đặt lại mật khẩu';

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
  String get auth_verification_check_mail => 'Kiểm tra email';

  @override
  String auth_verification_enter_code(String email) {
    return 'Vui lòng nhập mã 4 chữ số đã gửi đến email $email.';
  }

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
  String get validation_password_required => 'Mật khẩu là bắt buộc';

  @override
  String get validation_email_invalid => 'Vui lòng nhập địa chỉ email hợp lệ';

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
  String get auth_reset_password_create_new => 'Tạo mật khẩu mới';

  @override
  String get auth_verification_enter_code_label => 'Nhập mã xác minh';

  @override
  String get auth_forgot_password_enter_associated_email =>
      'Nhập email đã đăng ký';

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
}
