import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/image_upload_entity.dart';

part 'image_upload_provider.g.dart';

@riverpod
class ImageUpload extends _$ImageUpload {
  @override
  Future<ImageUploadEntity?> build() async {
    return null;
  }

  Future<bool> uploadImage({
    required String filePath,
    required String category,
    String? metadata,
  }) async {
    if (state.isLoading) return false;

    state = const AsyncValue.loading();

    try {
      final response = await ref.read(imageUploadRepositoryProvider).uploadImage(
            filePath: filePath,
            category: category,
            metadata: metadata,
          );

      if (response.isSuccess && response.data != null) {
        state = AsyncValue.data(response.data);
        return true;
      } else {
        final errorMessage = response.getErrorMessage();
        state = AsyncValue.error(
          Exception(errorMessage),
          StackTrace.current,
        );
        return false;
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

