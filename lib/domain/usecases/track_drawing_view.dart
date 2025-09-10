import 'package:injectable/injectable.dart';
import '../entities/recently_viewed_drawing.dart';
import '../repositories/recently_viewed_repository.dart';

@injectable
class TrackDrawingView {
  final RecentlyViewedRepository _repository;

  TrackDrawingView(this._repository);

  Future<void> call({
    required String userId,
    required String projectId,
    required String drawingTitle,
    required String drawingCollection,
    required String drawingThumbnailUrl,
  }) async {
    final drawing = RecentlyViewedDrawing(
      title: drawingTitle,
      subtitle: drawingCollection,
      drawingThumbnailUrl: drawingThumbnailUrl,
    );

    await _repository.addToRecentlyViewed(
      userId: userId,
      projectId: projectId,
      drawing: drawing,
    );
  }
}
