import '../../domain/entities/recently_viewed_drawing.dart';

class RecentlyViewedDrawingModel extends RecentlyViewedDrawing {
  const RecentlyViewedDrawingModel({
    required super.title,
    required super.subtitle,
    required super.drawingThumbnailUrl,
  });

  factory RecentlyViewedDrawingModel.fromJson(Map<String, dynamic> json) {
    return RecentlyViewedDrawingModel(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      drawingThumbnailUrl: json['drawingThumbnailUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'drawingThumbnailUrl': drawingThumbnailUrl,
    };
  }

  factory RecentlyViewedDrawingModel.fromEntity(RecentlyViewedDrawing entity) {
    return RecentlyViewedDrawingModel(
      title: entity.title,
      subtitle: entity.subtitle,
      drawingThumbnailUrl: entity.drawingThumbnailUrl,
    );
  }
}
