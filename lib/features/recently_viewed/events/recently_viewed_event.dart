abstract class RecentlyViewedEvent {}

class LoadRecentlyViewedEvent extends RecentlyViewedEvent {
  final String userId;
  final String projectId;

  LoadRecentlyViewedEvent({
    required this.userId,
    required this.projectId,
  });
}

class TrackDrawingViewEvent extends RecentlyViewedEvent {
  final String userId;
  final String projectId;
  final String drawingTitle;
  final String drawingCollection;
  final String drawingThumbnailUrl;

  TrackDrawingViewEvent({
    required this.userId,
    required this.projectId,
    required this.drawingTitle,
    required this.drawingCollection,
    required this.drawingThumbnailUrl,
  });
}

class RefreshRecentlyViewedEvent extends RecentlyViewedEvent {
  final String userId;
  final String projectId;

  RefreshRecentlyViewedEvent({
    required this.userId,
    required this.projectId,
  });
}
