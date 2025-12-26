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
import '../widgets/math_symbols_toolbar.dart';

class TextInputPage extends ConsumerStatefulWidget {
  const TextInputPage({super.key});

  @override
  ConsumerState<TextInputPage> createState() => _TextInputPageState();
}

class _TextInputPageState extends ConsumerState<TextInputPage> {
  final TextEditingController _problemTextController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isLoading = false;

  @override
  void dispose() {
    _problemTextController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _solveProblem() async {
    final problemText = _problemTextController.text.trim();
    if (problemText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập đề bài'),
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

  void _insertSymbol(String symbol) {
    final text = _problemTextController.text;
    final selection = _problemTextController.selection;
    final newText = text.replaceRange(
      selection.start,
      selection.end,
      symbol,
    );
    _problemTextController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: selection.start + symbol.length,
      ),
    );
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const HeadingSmallText('Nhập đề bài'),
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
                  // Instructions
                  Container(
                    padding: EdgeInsets.all(context.padding.p16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF2196F3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Color(0xFF2196F3),
                        ),
                        Gap(context.spacing.s12),
                        Expanded(
                          child: Text(
                            'Nhập đề bài Toán của bạn. Bạn có thể sử dụng các ký hiệu toán học bên dưới.',
                            style: context.textStyle.bodyMedium.copyWith(
                              color: const Color(0xFF1976D2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(context.spacing.s24),

                  // Example problems
                  Text(
                    'Ví dụ:',
                    style: context.textStyle.headingSmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Gap(context.spacing.s12),
                  _buildExampleProblem(
                    context,
                    'Tính: 2/3 + 1/4',
                    () {
                      _problemTextController.text = 'Tính: 2/3 + 1/4';
                    },
                  ),
                  Gap(context.spacing.s8),
                  _buildExampleProblem(
                    context,
                    'Giải phương trình: x + 5 = 10',
                    () {
                      _problemTextController.text = 'Giải phương trình: x + 5 = 10';
                    },
                  ),
                  Gap(context.spacing.s8),
                  _buildExampleProblem(
                    context,
                    'Tìm x: 2x - 3 = 7',
                    () {
                      _problemTextController.text = 'Tìm x: 2x - 3 = 7';
                    },
                  ),
                  Gap(context.spacing.s24),

                  // Text input field
                  Text(
                    'Đề bài:',
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
                      controller: _problemTextController,
                      focusNode: _focusNode,
                      maxLines: 8,
                      minLines: 4,
                      style: context.textStyle.bodyLarge.copyWith(
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Nhập đề bài Toán của bạn...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(context.padding.p16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Math symbols toolbar
          MathSymbolsToolbar(
            onSymbolTap: _insertSymbol,
          ),

          // Solve button
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
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _solveProblem,
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
                  label: Text(_isLoading ? 'Đang giải...' : 'Giải bài'),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleProblem(
    BuildContext context,
    String example,
    VoidCallback onTap,
  ) {
    return Semantics(
      label: 'Ví dụ: $example',
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(context.padding.p12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFE0E0E0),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.lightbulb_outline,
                color: Color(0xFFFF9800),
                size: 20,
              ),
              Gap(context.spacing.s8),
              Expanded(
                child: Text(
                  example,
                  style: context.textStyle.bodyMedium,
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Color(0xFF757575),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

