import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../data/services/cache/cache_service.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/tutor_provider.dart';
import '../utils/grade_helper.dart';

class OcrConfirmationPage extends ConsumerStatefulWidget {
  final String? imageUrl;
  final String? ocrText;
  final double? confidence;

  const OcrConfirmationPage({
    super.key,
    this.imageUrl,
    this.ocrText,
    this.confidence,
  });

  @override
  ConsumerState<OcrConfirmationPage> createState() => _OcrConfirmationPageState();
}

class _OcrConfirmationPageState extends ConsumerState<OcrConfirmationPage> {
  late TextEditingController _ocrTextController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _ocrTextController = TextEditingController(
      text: widget.ocrText ?? '',
    );
    _ocrTextController.addListener(() {
      // Text changes are handled by the controller
    });
  }

  @override
  void dispose() {
    _ocrTextController.dispose();
    super.dispose();
  }

  Future<void> _confirmAndSolve() async {
    final problemText = _ocrTextController.text.trim();
    if (problemText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập hoặc chỉnh sửa đề bài'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Get grade from cache or provider
      final grade = GradeHelper.getGrade(ref);
      if (grade == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vui lòng chọn lớp học trước khi giải bài.'),
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Get trial ID from cache
      final cacheService = ref.read(cacheServiceProvider);
      final trialId = cacheService.get<String>(CacheKey.trialId);

      // Solve problem
      final solveSuccess = await ref
          .read(solveProblemProvider.notifier)
          .solveFromText(
            problemText: problemText,
            grade: grade,
            trialId: trialId,
          );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (solveSuccess) {
          // Navigate to solution screen
          context.push(Routes.tutorSolution);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Không thể giải bài. Vui lòng kiểm tra lại đề bài.'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${e.toString()}'),
          ),
        );
      }
    }
  }

  Future<void> _retryOcr() async {
    // Navigate back to camera capture
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final confidence = widget.confidence ?? 0.0;
    final confidencePercent = (confidence * 100).toInt();
    final isLowConfidence = confidence < 0.9;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const HeadingSmallText('Xác nhận đề bài'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(context.padding.p16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image preview
                  if (widget.imageUrl != null) ...[
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          widget.imageUrl!,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 48,
                                color: Color(0xFFBDBDBD),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Gap(context.spacing.s16),
                  ],

                  // Confidence indicator
                  if (isLowConfidence)
                    Container(
                      padding: EdgeInsets.all(context.padding.p12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFFF9800),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: Color(0xFFFF9800),
                            size: 20,
                          ),
                          Gap(context.spacing.s8),
                          Expanded(
                            child: Text(
                              'Độ chính xác nhận dạng: $confidencePercent%. Vui lòng kiểm tra và chỉnh sửa nếu cần.',
                              style: context.textStyle.bodySmall.copyWith(
                                color: const Color(0xFFFF9800),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      padding: EdgeInsets.all(context.padding.p12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF4CAF50),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            color: Color(0xFF4CAF50),
                            size: 20,
                          ),
                          Gap(context.spacing.s8),
                          Expanded(
                            child: Text(
                              'Độ chính xác nhận dạng: $confidencePercent%',
                              style: context.textStyle.bodySmall.copyWith(
                                color: const Color(0xFF4CAF50),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Gap(context.spacing.s16),

                  // Instructions
                  Container(
                    padding: EdgeInsets.all(context.padding.p12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Color(0xFF2196F3),
                          size: 20,
                        ),
                        Gap(context.spacing.s8),
                        Expanded(
                          child: Text(
                            'Vui lòng kiểm tra và chỉnh sửa đề bài nếu cần thiết.',
                            style: context.textStyle.bodySmall.copyWith(
                              color: const Color(0xFF1976D2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(context.spacing.s16),

                  // OCR text input
                  Text(
                    'Đề bài đã nhận dạng:',
                    style: context.textStyle.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Gap(context.spacing.s8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _ocrTextController,
                      maxLines: 8,
                      minLines: 4,
                      style: context.textStyle.bodyLarge.copyWith(
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Đề bài sẽ hiển thị ở đây...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(context.padding.p16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: EdgeInsets.all(context.padding.p16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isLoading ? null : _retryOcr,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Chụp lại'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  Gap(context.spacing.s12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _confirmAndSolve,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.check),
                      label: Text(_isLoading ? 'Đang giải...' : 'Xác nhận và giải'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

