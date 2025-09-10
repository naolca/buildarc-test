import 'package:flutter_test/flutter_test.dart';
import 'package:ardennes/features/recently_viewed/events/recently_viewed_event.dart';

void main() {
  group('RecentlyViewedEvent', () {
    group('LoadRecentlyViewedEvent', () {
      test('should create LoadRecentlyViewedEvent with correct properties', () {
        // Arrange
        const userId = 'test_user_id';
        const projectId = 'test_project_id';

        // Act
        final event = LoadRecentlyViewedEvent(
          userId: userId,
          projectId: projectId,
        );

        // Assert
        expect(event.userId, equals(userId));
        expect(event.projectId, equals(projectId));
      });

      test('should be equal when properties are the same', () {
        // Arrange
        const userId = 'test_user_id';
        const projectId = 'test_project_id';

        final event1 = LoadRecentlyViewedEvent(
          userId: userId,
          projectId: projectId,
        );

        final event2 = LoadRecentlyViewedEvent(
          userId: userId,
          projectId: projectId,
        );

        // Act & Assert
        expect(event1, equals(event2));
        expect(event1.hashCode, equals(event2.hashCode));
      });

      test('should not be equal when properties are different', () {
        // Arrange
        final event1 = LoadRecentlyViewedEvent(
          userId: 'user1',
          projectId: 'project1',
        );

        final event2 = LoadRecentlyViewedEvent(
          userId: 'user2',
          projectId: 'project2',
        );

        // Act & Assert
        expect(event1, isNot(equals(event2)));
        expect(event1.hashCode, isNot(equals(event2.hashCode)));
      });
    });

    group('TrackDrawingViewEvent', () {
      test('should create TrackDrawingViewEvent with correct properties', () {
        // Arrange
        const userId = 'test_user_id';
        const projectId = 'test_project_id';
        const drawingTitle = 'A103';
        const drawingCollection = 'OFFICE FLOOR PLAN';
        const drawingThumbnailUrl = 'drawing_images/test.jpg';

        // Act
        final event = TrackDrawingViewEvent(
          userId: userId,
          projectId: projectId,
          drawingTitle: drawingTitle,
          drawingCollection: drawingCollection,
          drawingThumbnailUrl: drawingThumbnailUrl,
        );

        // Assert
        expect(event.userId, equals(userId));
        expect(event.projectId, equals(projectId));
        expect(event.drawingTitle, equals(drawingTitle));
        expect(event.drawingCollection, equals(drawingCollection));
        expect(event.drawingThumbnailUrl, equals(drawingThumbnailUrl));
      });

      test('should be equal when properties are the same', () {
        // Arrange
        const userId = 'test_user_id';
        const projectId = 'test_project_id';
        const drawingTitle = 'A103';
        const drawingCollection = 'OFFICE FLOOR PLAN';
        const drawingThumbnailUrl = 'drawing_images/test.jpg';

        final event1 = TrackDrawingViewEvent(
          userId: userId,
          projectId: projectId,
          drawingTitle: drawingTitle,
          drawingCollection: drawingCollection,
          drawingThumbnailUrl: drawingThumbnailUrl,
        );

        final event2 = TrackDrawingViewEvent(
          userId: userId,
          projectId: projectId,
          drawingTitle: drawingTitle,
          drawingCollection: drawingCollection,
          drawingThumbnailUrl: drawingThumbnailUrl,
        );

        // Act & Assert
        expect(event1, equals(event2));
        expect(event1.hashCode, equals(event2.hashCode));
      });

      test('should not be equal when properties are different', () {
        // Arrange
        final event1 = TrackDrawingViewEvent(
          userId: 'user1',
          projectId: 'project1',
          drawingTitle: 'A103',
          drawingCollection: 'OFFICE FLOOR PLAN',
          drawingThumbnailUrl: 'drawing_images/test1.jpg',
        );

        final event2 = TrackDrawingViewEvent(
          userId: 'user2',
          projectId: 'project2',
          drawingTitle: 'A104',
          drawingCollection: 'STRUCTURAL PLAN',
          drawingThumbnailUrl: 'drawing_images/test2.jpg',
        );

        // Act & Assert
        expect(event1, isNot(equals(event2)));
        expect(event1.hashCode, isNot(equals(event2.hashCode)));
      });
    });

    group('RefreshRecentlyViewedEvent', () {
      test('should create RefreshRecentlyViewedEvent with correct properties',
          () {
        // Arrange
        const userId = 'test_user_id';
        const projectId = 'test_project_id';

        // Act
        final event = RefreshRecentlyViewedEvent(
          userId: userId,
          projectId: projectId,
        );

        // Assert
        expect(event.userId, equals(userId));
        expect(event.projectId, equals(projectId));
      });

      test('should be equal when properties are the same', () {
        // Arrange
        const userId = 'test_user_id';
        const projectId = 'test_project_id';

        final event1 = RefreshRecentlyViewedEvent(
          userId: userId,
          projectId: projectId,
        );

        final event2 = RefreshRecentlyViewedEvent(
          userId: userId,
          projectId: projectId,
        );

        // Act & Assert
        expect(event1, equals(event2));
        expect(event1.hashCode, equals(event2.hashCode));
      });

      test('should not be equal when properties are different', () {
        // Arrange
        final event1 = RefreshRecentlyViewedEvent(
          userId: 'user1',
          projectId: 'project1',
        );

        final event2 = RefreshRecentlyViewedEvent(
          userId: 'user2',
          projectId: 'project2',
        );

        // Act & Assert
        expect(event1, isNot(equals(event2)));
        expect(event1.hashCode, isNot(equals(event2.hashCode)));
      });
    });
  });
}
