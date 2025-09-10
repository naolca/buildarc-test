import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/usecases/get_recently_viewed_drawings.dart';
import '../../../domain/usecases/track_drawing_view.dart';
import '../events/recently_viewed_event.dart';
import '../states/recently_viewed_state.dart';

@injectable
class RecentlyViewedBloc
    extends Bloc<RecentlyViewedEvent, RecentlyViewedState> {
  final GetRecentlyViewedDrawings getRecentlyViewedDrawings;
  final TrackDrawingView _trackDrawingView;

  RecentlyViewedBloc({
    required GetRecentlyViewedDrawings getRecentlyViewedDrawings,
    required TrackDrawingView trackDrawingView,
  })  : getRecentlyViewedDrawings = getRecentlyViewedDrawings,
        _trackDrawingView = trackDrawingView,
        super(RecentlyViewedInitial()) {
    on<LoadRecentlyViewedEvent>(_onLoadRecentlyViewed);
    on<TrackDrawingViewEvent>(_onTrackDrawingView);
    on<RefreshRecentlyViewedEvent>(_onRefreshRecentlyViewed);
  }

  Future<void> _onLoadRecentlyViewed(
    LoadRecentlyViewedEvent event,
    Emitter<RecentlyViewedState> emit,
  ) async {
    emit(RecentlyViewedLoading());

    try {
      final drawings = await getRecentlyViewedDrawings(
        userId: event.userId,
        projectId: event.projectId,
      );
      emit(RecentlyViewedLoaded(drawings: drawings));
    } catch (e) {
      emit(RecentlyViewedError(message: e.toString()));
    }
  }

  Future<void> _onTrackDrawingView(
    TrackDrawingViewEvent event,
    Emitter<RecentlyViewedState> emit,
  ) async {
    try {
      await _trackDrawingView(
        userId: event.userId,
        projectId: event.projectId,
        drawingTitle: event.drawingTitle,
        drawingCollection: event.drawingCollection,
        drawingThumbnailUrl: event.drawingThumbnailUrl,
      );
      // The RecentlyViewedDrawings widget will automatically update via the stream
      // No need to manually refresh here as the stream will emit the new data
    } catch (e) {
      // Don't emit error state for tracking failures as it's not critical
    }
  }

  Future<void> _onRefreshRecentlyViewed(
    RefreshRecentlyViewedEvent event,
    Emitter<RecentlyViewedState> emit,
  ) async {
    try {
      final drawings = await getRecentlyViewedDrawings(
        userId: event.userId,
        projectId: event.projectId,
      );
      emit(RecentlyViewedLoaded(drawings: drawings));
    } catch (e) {
      emit(RecentlyViewedError(message: e.toString()));
    }
  }
}
