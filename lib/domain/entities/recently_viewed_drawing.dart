class RecentlyViewedDrawing {
  final String title;
  final String subtitle;
  final String drawingThumbnailUrl;

  const RecentlyViewedDrawing({
    required this.title,
    required this.subtitle,
    required this.drawingThumbnailUrl,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RecentlyViewedDrawing &&
        other.title == title &&
        other.subtitle == subtitle;
  }

  @override
  int get hashCode => title.hashCode ^ subtitle.hashCode;

  @override
  String toString() {
    return 'RecentlyViewedDrawing(title: $title, subtitle: $subtitle, drawingThumbnailUrl: $drawingThumbnailUrl)';
  }
}
