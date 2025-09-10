import 'package:flutter_test/flutter_test.dart';
import 'package:ardennes/domain/entities/recently_viewed_drawing.dart';
import 'package:ardennes/data/models/recently_viewed_drawing_model.dart';

void main() {
  group('RecentlyViewedDrawingModel', () {
    test('should create model with correct properties', () {
      // Arrange
      const title = 'A103';
      const subtitle = 'OFFICE FLOOR PLAN';
      const drawingThumbnailUrl = 'drawing_images/test.jpg';

      // Act
      final model = RecentlyViewedDrawingModel(
        title: title,
        subtitle: subtitle,
        drawingThumbnailUrl: drawingThumbnailUrl,
      );

      // Assert
      expect(model.title, equals(title));
      expect(model.subtitle, equals(subtitle));
      expect(model.drawingThumbnailUrl, equals(drawingThumbnailUrl));
    });

    test('should create model from JSON', () {
      // Arrange
      final json = {
        'title': 'A103',
        'subtitle': 'OFFICE FLOOR PLAN',
        'drawingThumbnailUrl': 'drawing_images/test.jpg',
      };

      // Act
      final model = RecentlyViewedDrawingModel.fromJson(json);

      // Assert
      expect(model.title, equals('A103'));
      expect(model.subtitle, equals('OFFICE FLOOR PLAN'));
      expect(model.drawingThumbnailUrl, equals('drawing_images/test.jpg'));
    });

    test('should convert model to JSON', () {
      // Arrange
      const model = RecentlyViewedDrawingModel(
        title: 'A103',
        subtitle: 'OFFICE FLOOR PLAN',
        drawingThumbnailUrl: 'drawing_images/test.jpg',
      );

      // Act
      final json = model.toJson();

      // Assert
      expect(json, equals({
        'title': 'A103',
        'subtitle': 'OFFICE FLOOR PLAN',
        'drawingThumbnailUrl': 'drawing_images/test.jpg',
      }));
    });

    test('should create model from entity', () {
      // Arrange
      final entity = RecentlyViewedDrawing(
        title: 'A103',
        subtitle: 'OFFICE FLOOR PLAN',
        drawingThumbnailUrl: 'drawing_images/test.jpg',
      );

      // Act
      final model = RecentlyViewedDrawingModel.fromEntity(entity);

      // Assert
      expect(model.title, equals(entity.title));
      expect(model.subtitle, equals(entity.subtitle));
      expect(model.drawingThumbnailUrl, equals(entity.drawingThumbnailUrl));
    });

    test('should be equal when properties are the same', () {
      // Arrange
      const model1 = RecentlyViewedDrawingModel(
        title: 'A103',
        subtitle: 'OFFICE FLOOR PLAN',
        drawingThumbnailUrl: 'drawing_images/test.jpg',
      );

      const model2 = RecentlyViewedDrawingModel(
        title: 'A103',
        subtitle: 'OFFICE FLOOR PLAN',
        drawingThumbnailUrl: 'drawing_images/test.jpg',
      );

      // Act & Assert
      expect(model1, equals(model2));
      expect(model1.hashCode, equals(model2.hashCode));
    });

    test('should not be equal when properties are different', () {
      // Arrange
      const model1 = RecentlyViewedDrawingModel(
        title: 'A103',
        subtitle: 'OFFICE FLOOR PLAN',
        drawingThumbnailUrl: 'drawing_images/test1.jpg',
      );

      const model2 = RecentlyViewedDrawingModel(
        title: 'A104',
        subtitle: 'STRUCTURAL PLAN',
        drawingThumbnailUrl: 'drawing_images/test2.jpg',
      );

      // Act & Assert
      expect(model1, isNot(equals(model2)));
      expect(model1.hashCode, isNot(equals(model2.hashCode)));
    });

    test('should handle null values in JSON gracefully', () {
      // Arrange
      final json = {
        'title': null,
        'subtitle': 'OFFICE FLOOR PLAN',
        'drawingThumbnailUrl': 'drawing_images/test.jpg',
      };

      // Act & Assert
      expect(
        () => RecentlyViewedDrawingModel.fromJson(json),
        throwsA(isA<TypeError>()),
      );
    });

    test('should handle missing keys in JSON gracefully', () {
      // Arrange
      final json = {
        'title': 'A103',
        // Missing subtitle and drawingThumbnailUrl
      };

      // Act & Assert
      expect(
        () => RecentlyViewedDrawingModel.fromJson(json),
        throwsA(isA<TypeError>()),
      );
    });
  });
}
