import '../../../domain/entities/recently_viewed_drawing.dart';

abstract class RecentlyViewedState {}

class RecentlyViewedInitial extends RecentlyViewedState {}

class RecentlyViewedLoading extends RecentlyViewedState {}

class RecentlyViewedLoaded extends RecentlyViewedState {
  final List<RecentlyViewedDrawing> drawings;

  RecentlyViewedLoaded({required this.drawings});
}

class RecentlyViewedError extends RecentlyViewedState {
  final String message;

  RecentlyViewedError({required this.message});
}
