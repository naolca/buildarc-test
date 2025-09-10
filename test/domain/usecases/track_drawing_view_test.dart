import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:ardennes/domain/entities/recently_viewed_drawing.dart';
import 'package:ardennes/domain/repositories/recently_viewed_repository.dart';
import 'package:ardennes/domain/usecases/track_drawing_view.dart';

import 'track_drawing_view_test.mocks.dart';

@GenerateMocks([RecentlyViewedRepository])
void main() {
  group('TrackDrawingView', () {
    late TrackDrawingView useCase;
    late MockRecentlyViewedRepository mockRepository;

    setUp(() {
      mockRepository = MockRecentlyViewedRepository();
      useCase = TrackDrawingView(mockRepository);
    });

    test('should call repository with correct parameters', () async {
      // Arrange
      const userId = 'test_user_id';
      const projectId = 'test_project_id';
      const drawingTitle = 'A103';
      const drawingCollection = 'OFFICE FLOOR PLAN';
      const drawingThumbnailUrl = 'drawing_images/test.jpg';

      when(mockRepository.addToRecentlyViewed(
        userId: anyNamed('userId'),
        projectId: anyNamed('projectId'),
        drawing: anyNamed('drawing'),
      )).thenAnswer((_) async {});

      // Act
      await useCase.call(
        userId: userId,
        projectId: projectId,
        drawingTitle: drawingTitle,
        drawingCollection: drawingCollection,
        drawingThumbnailUrl: drawingThumbnailUrl,
      );

      // Assert
      verify(mockRepository.addToRecentlyViewed(
        userId: userId,
        projectId: projectId,
        drawing: argThat(
          isA<RecentlyViewedDrawing>()
              .having((d) => d.title, 'title', drawingTitle)
              .having((d) => d.subtitle, 'subtitle', drawingCollection)
              .having((d) => d.drawingThumbnailUrl, 'drawingThumbnailUrl', drawingThumbnailUrl),
        ),
      )).called(1);
    });

    test('should create RecentlyViewedDrawing with correct properties', () async {
      // Arrange
      const userId = 'test_user_id';
      const projectId = 'test_project_id';
      const drawingTitle = 'A104';
      const drawingCollection = 'STRUCTURAL PLAN';
      const drawingThumbnailUrl = 'drawing_images/test2.jpg';

      RecentlyViewedDrawing? capturedDrawing;
      when(mockRepository.addToRecentlyViewed(
        userId: anyNamed('userId'),
        projectId: anyNamed('projectId'),
        drawing: anyNamed('drawing'),
      )).thenAnswer((invocation) async {
        capturedDrawing = invocation.namedArguments[#drawing] as RecentlyViewedDrawing;
      });

      // Act
      await useCase.call(
        userId: userId,
        projectId: projectId,
        drawingTitle: drawingTitle,
        drawingCollection: drawingCollection,
        drawingThumbnailUrl: drawingThumbnailUrl,
      );

      // Assert
      expect(capturedDrawing, isNotNull);
      expect(capturedDrawing!.title, equals(drawingTitle));
      expect(capturedDrawing!.subtitle, equals(drawingCollection));
      expect(capturedDrawing!.drawingThumbnailUrl, equals(drawingThumbnailUrl));
    });

    test('should propagate repository exceptions', () async {
      // Arrange
      const userId = 'test_user_id';
      const projectId = 'test_project_id';
      const drawingTitle = 'A103';
      const drawingCollection = 'OFFICE FLOOR PLAN';
      const drawingThumbnailUrl = 'drawing_images/test.jpg';

      when(mockRepository.addToRecentlyViewed(
        userId: anyNamed('userId'),
        projectId: anyNamed('projectId'),
        drawing: anyNamed('drawing'),
      )).thenThrow(Exception('Repository error'));

      // Act & Assert
      expect(
        () => useCase.call(
          userId: userId,
          projectId: projectId,
          drawingTitle: drawingTitle,
          drawingCollection: drawingCollection,
          drawingThumbnailUrl: drawingThumbnailUrl,
        ),
        throwsException,
      );
    });
  });
}
