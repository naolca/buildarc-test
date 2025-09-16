import 'package:injectable/injectable.dart';
import '../entities/recently_viewed_drawing.dart';
import '../repositories/recently_viewed_repository.dart';

@injectable
class GetRecentlyViewedDrawings {
  final RecentlyViewedRepository _repository;

  GetRecentlyViewedDrawings(this._repository);

  Future<List<RecentlyViewedDrawing>> call({
    required String userId,
    required String projectId,
  }) async {
    return await _repository.getRecentlyViewedDrawings(
      userId: userId,
      projectId: projectId,
    );
  }

  Stream<List<RecentlyViewedDrawing>> watch({
    required String userId,
    required String projectId,
  }) {
    return _repository.watchRecentlyViewedDrawings(
      userId: userId,
      projectId: projectId,
    );
  }
}
