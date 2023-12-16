import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'image_repository.dart';
import 'image_model.dart';

class ImageNotifier extends StateNotifier<List<ImageModel>> {
  ImageNotifier() : super([]);

  Future<void> fetchImages() async {
    final repository = ImageRepository();
    state = await repository.fetchImages();
  }
}

final imageProvider =
    StateNotifierProvider<ImageNotifier, List<ImageModel>>((ref) {
  return ImageNotifier();
});
