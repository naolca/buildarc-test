import 'package:flutter_test/flutter_test.dart';
import 'package:ardennes/domain/entities/recently_viewed_drawing.dart';

void main() {
  group('RecentlyViewedDrawing', () {
    test('should create a RecentlyViewedDrawing with correct properties', () {
      // Arrange
      const title = 'A103';
      const subtitle = 'OFFICE FLOOR PLAN';
      const drawingThumbnailUrl = 'drawing_images/test.jpg';

      // Act
      final drawing = RecentlyViewedDrawing(
        title: title,
        subtitle: subtitle,
        drawingThumbnailUrl: drawingThumbnailUrl,
      );

      // Assert
      expect(drawing.title, equals(title));
      expect(drawing.subtitle, equals(subtitle));
      expect(drawing.drawingThumbnailUrl, equals(drawingThumbnailUrl));
    });

    test('should be equal when all properties are the same', () {
      // Arrange
      const title = 'A103';
      const subtitle = 'OFFICE FLOOR PLAN';
      const drawingThumbnailUrl = 'drawing_images/test.jpg';

      final drawing1 = RecentlyViewedDrawing(
        title: title,
        subtitle: subtitle,
        drawingThumbnailUrl: drawingThumbnailUrl,
      );

      final drawing2 = RecentlyViewedDrawing(
        title: title,
        subtitle: subtitle,
        drawingThumbnailUrl: drawingThumbnailUrl,
      );

      // Act & Assert
      expect(drawing1, equals(drawing2));
      expect(drawing1.hashCode, equals(drawing2.hashCode));
    });

    test('should not be equal when properties are different', () {
      // Arrange
      final drawing1 = RecentlyViewedDrawing(
        title: 'A103',
        subtitle: 'OFFICE FLOOR PLAN',
        drawingThumbnailUrl: 'drawing_images/test1.jpg',
      );

      final drawing2 = RecentlyViewedDrawing(
        title: 'A104',
        subtitle: 'OFFICE FLOOR PLAN',
        drawingThumbnailUrl: 'drawing_images/test2.jpg',
      );

      // Act & Assert
      expect(drawing1, isNot(equals(drawing2)));
      expect(drawing1.hashCode, isNot(equals(drawing2.hashCode)));
    });

    test('should not be equal when title is different', () {
      // Arrange
      final drawing1 = RecentlyViewedDrawing(
        title: 'A103',
        subtitle: 'OFFICE FLOOR PLAN',
        drawingThumbnailUrl: 'drawing_images/test.jpg',
      );

      final drawing2 = RecentlyViewedDrawing(
        title: 'A104',
        subtitle: 'OFFICE FLOOR PLAN',
        drawingThumbnailUrl: 'drawing_images/test.jpg',
      );

      // Act & Assert
      expect(drawing1, isNot(equals(drawing2)));
    });

    test('should not be equal when subtitle is different', () {
      // Arrange
      final drawing1 = RecentlyViewedDrawing(
        title: 'A103',
        subtitle: 'OFFICE FLOOR PLAN',
        drawingThumbnailUrl: 'drawing_images/test.jpg',
      );

      final drawing2 = RecentlyViewedDrawing(
        title: 'A103',
        subtitle: 'STRUCTURAL PLAN',
        drawingThumbnailUrl: 'drawing_images/test.jpg',
      );

      // Act & Assert
      expect(drawing1, isNot(equals(drawing2)));
    });

    test('should not be equal when drawingThumbnailUrl is different', () {
      // Arrange
      final drawing1 = RecentlyViewedDrawing(
        title: 'A103',
        subtitle: 'OFFICE FLOOR PLAN',
        drawingThumbnailUrl: 'drawing_images/test1.jpg',
      );

      final drawing2 = RecentlyViewedDrawing(
        title: 'A103',
        subtitle: 'OFFICE FLOOR PLAN',
        drawingThumbnailUrl: 'drawing_images/test2.jpg',
      );

      // Act & Assert
      expect(drawing1, isNot(equals(drawing2)));
    });
  });
}
