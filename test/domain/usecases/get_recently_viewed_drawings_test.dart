import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:ardennes/domain/entities/recently_viewed_drawing.dart';
import 'package:ardennes/domain/repositories/recently_viewed_repository.dart';
import 'package:ardennes/domain/usecases/get_recently_viewed_drawings.dart';

import 'get_recently_viewed_drawings_test.mocks.dart';

@GenerateMocks([RecentlyViewedRepository])
void main() {
  group('GetRecentlyViewedDrawings', () {
    late GetRecentlyViewedDrawings useCase;
    late MockRecentlyViewedRepository mockRepository;

    setUp(() {
      mockRepository = MockRecentlyViewedRepository();
      useCase = GetRecentlyViewedDrawings(mockRepository);
    });

    group('call method', () {
      test('should return drawings from repository', () async {
        // Arrange
        const userId = 'test_user_id';
        const projectId = 'test_project_id';
        final expectedDrawings = [
          RecentlyViewedDrawing(
            title: 'A103',
            subtitle: 'OFFICE FLOOR PLAN',
            drawingThumbnailUrl: 'drawing_images/test1.jpg',
          ),
          RecentlyViewedDrawing(
            title: 'A104',
            subtitle: 'STRUCTURAL PLAN',
            drawingThumbnailUrl: 'drawing_images/test2.jpg',
          ),
        ];

        when(mockRepository.getRecentlyViewedDrawings(
          userId: anyNamed('userId'),
          projectId: anyNamed('projectId'),
        )).thenAnswer((_) async => expectedDrawings);

        // Act
        final result = await useCase.call(
          userId: userId,
          projectId: projectId,
        );

        // Assert
        expect(result, equals(expectedDrawings));
        verify(mockRepository.getRecentlyViewedDrawings(
          userId: userId,
          projectId: projectId,
        )).called(1);
      });

      test('should return empty list when repository returns empty list', () async {
        // Arrange
        const userId = 'test_user_id';
        const projectId = 'test_project_id';
        const expectedDrawings = <RecentlyViewedDrawing>[];

        when(mockRepository.getRecentlyViewedDrawings(
          userId: anyNamed('userId'),
          projectId: anyNamed('projectId'),
        )).thenAnswer((_) async => expectedDrawings);

        // Act
        final result = await useCase.call(
          userId: userId,
          projectId: projectId,
        );

        // Assert
        expect(result, equals(expectedDrawings));
        expect(result, isEmpty);
      });

      test('should propagate repository exceptions', () async {
        // Arrange
        const userId = 'test_user_id';
        const projectId = 'test_project_id';

        when(mockRepository.getRecentlyViewedDrawings(
          userId: anyNamed('userId'),
          projectId: anyNamed('projectId'),
        )).thenThrow(Exception('Repository error'));

        // Act & Assert
        expect(
          () => useCase.call(
            userId: userId,
            projectId: projectId,
          ),
          throwsException,
        );
      });
    });

    group('watch method', () {
      test('should return stream from repository', () {
        // Arrange
        const userId = 'test_user_id';
        const projectId = 'test_project_id';
        final expectedStream = Stream.value([
          RecentlyViewedDrawing(
            title: 'A103',
            subtitle: 'OFFICE FLOOR PLAN',
            drawingThumbnailUrl: 'drawing_images/test1.jpg',
          ),
        ]);

        when(mockRepository.watchRecentlyViewedDrawings(
          userId: anyNamed('userId'),
          projectId: anyNamed('projectId'),
        )).thenAnswer((_) => expectedStream);

        // Act
        final result = useCase.watch(
          userId: userId,
          projectId: projectId,
        );

        // Assert
        expect(result, equals(expectedStream));
        verify(mockRepository.watchRecentlyViewedDrawings(
          userId: userId,
          projectId: projectId,
        )).called(1);
      });

      test('should return stream that emits data', () async {
        // Arrange
        const userId = 'test_user_id';
        const projectId = 'test_project_id';
        final expectedDrawings = [
          RecentlyViewedDrawing(
            title: 'A103',
            subtitle: 'OFFICE FLOOR PLAN',
            drawingThumbnailUrl: 'drawing_images/test1.jpg',
          ),
        ];

        when(mockRepository.watchRecentlyViewedDrawings(
          userId: anyNamed('userId'),
          projectId: anyNamed('projectId'),
        )).thenAnswer((_) => Stream.value(expectedDrawings));

        // Act
        final stream = useCase.watch(
          userId: userId,
          projectId: projectId,
        );

        // Assert
        final result = await stream.first;
        expect(result, equals(expectedDrawings));
      });
    });
  });
}
