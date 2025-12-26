import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../data/services/cache/cache_service.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../riverpod/image_upload_provider.dart';
import '../riverpod/tutor_provider.dart';
import '../utils/grade_helper.dart';

class CameraCapturePage extends ConsumerStatefulWidget {
  const CameraCapturePage({super.key});

  @override
  ConsumerState<CameraCapturePage> createState() => _CameraCapturePageState();
}

class _CameraCapturePageState extends ConsumerState<CameraCapturePage> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  XFile? _capturedImage;
  bool _isInitializing = true;
  bool _hasPermission = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        setState(() {
          _errorMessage = 'Không tìm thấy camera';
          _isInitializing = false;
        });
        return;
      }

      _cameraController = CameraController(
        _cameras![0],
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      setState(() {
        _hasPermission = true;
        _isInitializing = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Cần quyền truy cập camera. Vui lòng cấp quyền trong Settings.';
        _isInitializing = false;
        _hasPermission = false;
      });
    }
  }

  Future<void> _captureImage() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final image = await _cameraController!.takePicture();
      setState(() {
        _capturedImage = image;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi chụp ảnh: ${e.toString()}'),
          ),
        );
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _capturedImage = image;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi chọn ảnh: ${e.toString()}'),
          ),
        );
      }
    }
  }

  Future<void> _confirmAndUpload() async {
    if (_capturedImage == null) return;

    // Get grade first
    final grade = GradeHelper.getGrade(ref);
    if (grade == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn lớp học trước khi giải bài.'),
        ),
      );
      return;
    }

      // Get trial ID from cache
      final cacheService = ref.read(cacheServiceProvider);
      final trialId = cacheService.get<String>(CacheKey.trialId);

    // Show loading
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LoadingIndicator(),
                  Gap(16),
                  Text('Đang nhận dạng đề bài...'),
                ],
              ),
            ),
          ),
        ),
      );
    }

    try {
      // Upload image
      final uploadSuccess = await ref
          .read(imageUploadProvider.notifier)
          .uploadImage(
            filePath: _capturedImage!.path,
            category: 'tutor',
          );

      if (!uploadSuccess) {
        if (mounted) {
          Navigator.of(context).pop(); // Close loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Không thể tải ảnh lên. Vui lòng thử lại.'),
            ),
          );
        }
        return;
      }

      final uploadState = ref.read(imageUploadProvider);
      final imageUrl = uploadState.value?.imageUrl;

      if (imageUrl == null) {
        if (mounted) {
          Navigator.of(context).pop(); // Close loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Không thể lấy URL ảnh. Vui lòng thử lại.'),
            ),
          );
        }
        return;
      }

      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
      }

      // Solve problem to get OCR result
      final solveSuccess = await ref
          .read(solveProblemProvider.notifier)
          .solveFromImage(
            imageUrl: imageUrl,
            grade: grade,
            trialId: trialId,
          );

      if (solveSuccess) {
        // Get the solved problem text (OCR result)
        final solveState = ref.read(solveProblemProvider);
        final solution = solveState.valueOrNull;
        final ocrText = solution?.problemText ?? '';
        
        // For now, we'll always show OCR confirmation if we have text
        // In the future, we can check confidence from AI Service
        // For now, simulate confidence based on whether we got text
        final confidence = ocrText.isNotEmpty ? 0.90 : 0.70;

        if (mounted) {
          if (ocrText.isNotEmpty && confidence < 0.90) {
            // Navigate to OCR confirmation screen if confidence is low
            context.push(
              '${Routes.tutorOcrConfirmation}?imageUrl=${Uri.encodeComponent(imageUrl)}&ocrText=${Uri.encodeComponent(ocrText)}&confidence=$confidence',
            );
          } else {
            // Navigate directly to solution if confidence is high or we have solution
            context.push(Routes.tutorSolution);
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Không thể nhận dạng đề bài. Vui lòng chụp lại rõ hơn.'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${e.toString()}'),
          ),
        );
      }
    }
  }

  void _retakePhoto() {
    setState(() {
      _capturedImage = null;
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(
          child: LoadingIndicator(),
        ),
      );
    }

    if (_errorMessage != null && !_hasPermission) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(context.padding.p24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.camera_alt_outlined,
                  size: 64,
                  color: Colors.white,
                ),
                Gap(context.spacing.s16),
                Text(
                  _errorMessage!,
                  style: context.textStyle.bodyLarge.copyWith(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                Gap(context.spacing.s24),
                ElevatedButton(
                  onPressed: () {
                    // Try to open settings or retry
                    _initializeCamera();
                  },
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Chụp ảnh đề bài',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          // Camera preview or image preview
          if (_capturedImage == null && _cameraController != null)
            _buildCameraPreview()
          else if (_capturedImage != null)
            _buildImagePreview(),

          // Instructions overlay
          if (_capturedImage == null)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: EdgeInsets.all(context.padding.p12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Semantics(
                  label: 'Hướng dẫn: Đặt đề bài trong khung',
                  child: Text(
                    'Đặt đề bài trong khung',
                    style: context.textStyle.bodyMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

          // Action buttons
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(context.padding.p16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_capturedImage != null) ...[
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _retakePhoto,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Chụp lại'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white),
                                minimumSize: const Size(0, 56),
                              ),
                            ),
                          ),
                          Gap(context.spacing.s12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _confirmAndUpload,
                              icon: const Icon(Icons.check),
                              label: const Text('Xác nhận'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2196F3),
                                foregroundColor: Colors.white,
                                minimumSize: const Size(0, 56),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Gallery button
                          IconButton(
                            onPressed: _pickImageFromGallery,
                            icon: const Icon(Icons.photo_library, color: Colors.white),
                            iconSize: 32,
                            tooltip: 'Chọn từ thư viện',
                          ),
                          // Capture button
                          GestureDetector(
                            onTap: _captureImage,
                            child: Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: const Color(0xFF2196F3),
                                  width: 4,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 36,
                                color: Color(0xFF2196F3),
                              ),
                            ),
                          ),
                          // Placeholder for symmetry
                          const SizedBox(width: 32),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Center(
        child: LoadingIndicator(),
      );
    }

    return Stack(
      children: [
        SizedBox.expand(
          child: CameraPreview(_cameraController!),
        ),
        // Overlay guide frame
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withOpacity(0.8),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    return Center(
      child: Semantics(
        label: 'Ảnh đề bài đã chụp',
        child: Image.file(
          File(_capturedImage!.path),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

