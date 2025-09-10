import 'package:injectable/injectable.dart';
import '../../domain/entities/recently_viewed_drawing.dart';
import '../../domain/repositories/recently_viewed_repository.dart';
import '../datasources/recently_viewed_remote_datasource.dart';
import '../models/recently_viewed_drawing_model.dart';

@Injectable(as: RecentlyViewedRepository)
class RecentlyViewedRepositoryImpl implements RecentlyViewedRepository {
  final RecentlyViewedRemoteDataSource _remoteDataSource;

  RecentlyViewedRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<RecentlyViewedDrawing>> getRecentlyViewedDrawings({
    required String userId,
    required String projectId,
  }) async {
    final models = await _remoteDataSource.getRecentlyViewedDrawings(
      userId: userId,
      projectId: projectId,
    );

    return models.map((model) => model as RecentlyViewedDrawing).toList();
  }

  @override
  Future<void> addToRecentlyViewed({
    required String userId,
    required String projectId,
    required RecentlyViewedDrawing drawing,
  }) async {
    final model = RecentlyViewedDrawingModel.fromEntity(drawing);

    await _remoteDataSource.addToRecentlyViewed(
      userId: userId,
      projectId: projectId,
      drawing: model,
    );
  }

  @override
  Stream<List<RecentlyViewedDrawing>> watchRecentlyViewedDrawings({
    required String userId,
    required String projectId,
  }) {
    return _remoteDataSource
        .watchRecentlyViewedDrawings(
          userId: userId,
          projectId: projectId,
        )
        .map((models) =>
            models.map((model) => model as RecentlyViewedDrawing).toList());
  }
}
