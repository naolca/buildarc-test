import '../entities/recently_viewed_drawing.dart';

abstract class RecentlyViewedRepository {
  /// Get recently viewed drawings for a specific user and project
  Future<List<RecentlyViewedDrawing>> getRecentlyViewedDrawings({
    required String userId,
    required String projectId,
  });

  /// Add a drawing to recently viewed list
  /// If the drawing already exists, it will be moved to the front
  Future<void> addToRecentlyViewed({
    required String userId,
    required String projectId,
    required RecentlyViewedDrawing drawing,
  });

  /// Stream of recently viewed drawings for real-time updates
  Stream<List<RecentlyViewedDrawing>> watchRecentlyViewedDrawings({
    required String userId,
    required String projectId,
  });
}
