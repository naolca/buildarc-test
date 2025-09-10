import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ardennes/data/models/home_screen_data_model.dart';
import 'package:ardennes/data/models/recently_viewed_drawing_model.dart';

void main() {
  group('HomeScreenDataModel', () {
    test('should create model with correct properties', () {
      // Arrange
      final drawings = [
        RecentlyViewedDrawingModel(
          title: 'A103',
          subtitle: 'OFFICE FLOOR PLAN',
          drawingThumbnailUrl: 'drawing_images/test1.jpg',
        ),
        RecentlyViewedDrawingModel(
          title: 'A104',
          subtitle: 'STRUCTURAL PLAN',
          drawingThumbnailUrl: 'drawing_images/test2.jpg',
        ),
      ];

      // Act
      final model = HomeScreenDataModel(drawings: drawings);

      // Assert
      expect(model.drawings, equals(drawings));
      expect(model.drawings.length, equals(2));
    });

    test('should create model with empty drawings list', () {
      // Arrange
      const drawings = <RecentlyViewedDrawingModel>[];

      // Act
      final model = HomeScreenDataModel(drawings: drawings);

      // Assert
      expect(model.drawings, equals(drawings));
      expect(model.drawings, isEmpty);
    });

    group('fromFirestore', () {
      test('should create model from Firestore document with drawings', () {
        // Arrange
        final mockSnapshot = MockDocumentSnapshot();
        final data = {
          'drawings': [
            {
              'title': 'A103',
              'subtitle': 'OFFICE FLOOR PLAN',
              'drawingThumbnailUrl': 'drawing_images/test1.jpg',
            },
            {
              'title': 'A104',
              'subtitle': 'STRUCTURAL PLAN',
              'drawingThumbnailUrl': 'drawing_images/test2.jpg',
            },
          ],
        };
        when(mockSnapshot.data()).thenReturn(data);

        // Act
        final model = HomeScreenDataModel.fromFirestore(mockSnapshot, null);

        // Assert
        expect(model.drawings.length, equals(2));
        expect(model.drawings[0].title, equals('A103'));
        expect(model.drawings[0].subtitle, equals('OFFICE FLOOR PLAN'));
        expect(model.drawings[0].drawingThumbnailUrl, equals('drawing_images/test1.jpg'));
        expect(model.drawings[1].title, equals('A104'));
        expect(model.drawings[1].subtitle, equals('STRUCTURAL PLAN'));
        expect(model.drawings[1].drawingThumbnailUrl, equals('drawing_images/test2.jpg'));
      });

      test('should create model with empty drawings when drawings is null', () {
        // Arrange
        final mockSnapshot = MockDocumentSnapshot();
        final data = <String, dynamic>{};
        when(mockSnapshot.data()).thenReturn(data);

        // Act
        final model = HomeScreenDataModel.fromFirestore(mockSnapshot, null);

        // Assert
        expect(model.drawings, isEmpty);
      });

      test('should create model with empty drawings when drawings is not iterable', () {
        // Arrange
        final mockSnapshot = MockDocumentSnapshot();
        final data = {'drawings': 'not_an_array'};
        when(mockSnapshot.data()).thenReturn(data);

        // Act
        final model = HomeScreenDataModel.fromFirestore(mockSnapshot, null);

        // Assert
        expect(model.drawings, isEmpty);
      });

      test('should create model with empty drawings when data is null', () {
        // Arrange
        final mockSnapshot = MockDocumentSnapshot();
        when(mockSnapshot.data()).thenReturn(null);

        // Act
        final model = HomeScreenDataModel.fromFirestore(mockSnapshot, null);

        // Assert
        expect(model.drawings, isEmpty);
      });
    });

    group('toFirestore', () {
      test('should convert model to Firestore data', () {
        // Arrange
        final drawings = [
          RecentlyViewedDrawingModel(
            title: 'A103',
            subtitle: 'OFFICE FLOOR PLAN',
            drawingThumbnailUrl: 'drawing_images/test1.jpg',
          ),
          RecentlyViewedDrawingModel(
            title: 'A104',
            subtitle: 'STRUCTURAL PLAN',
            drawingThumbnailUrl: 'drawing_images/test2.jpg',
          ),
        ];
        final model = HomeScreenDataModel(drawings: drawings);

        // Act
        final firestoreData = HomeScreenDataModel.toFirestore(model, null);

        // Assert
        expect(firestoreData, isA<Map<String, Object?>>());
        expect(firestoreData['drawings'], isA<List>());
        expect((firestoreData['drawings'] as List).length, equals(2));
        
        final drawingsData = firestoreData['drawings'] as List;
        expect(drawingsData[0], equals({
          'title': 'A103',
          'subtitle': 'OFFICE FLOOR PLAN',
          'drawingThumbnailUrl': 'drawing_images/test1.jpg',
        }));
        expect(drawingsData[1], equals({
          'title': 'A104',
          'subtitle': 'STRUCTURAL PLAN',
          'drawingThumbnailUrl': 'drawing_images/test2.jpg',
        }));
      });

      test('should throw ArgumentError when object is not HomeScreenDataModel', () {
        // Arrange
        const invalidObject = 'not_a_home_screen_data_model';

        // Act & Assert
        expect(
          () => HomeScreenDataModel.toFirestore(invalidObject, null),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should convert empty model to Firestore data', () {
        // Arrange
        const drawings = <RecentlyViewedDrawingModel>[];
        const model = HomeScreenDataModel(drawings: drawings);

        // Act
        final firestoreData = HomeScreenDataModel.toFirestore(model, null);

        // Assert
        expect(firestoreData, isA<Map<String, Object?>>());
        expect(firestoreData['drawings'], isA<List>());
        expect((firestoreData['drawings'] as List), isEmpty);
      });
    });
  });
}

// Mock class for DocumentSnapshot
class MockDocumentSnapshot extends Mock implements DocumentSnapshot<Map<String, dynamic>> {}
