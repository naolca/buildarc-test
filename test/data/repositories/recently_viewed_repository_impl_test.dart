import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:ardennes/data/repositories/recently_viewed_repository_impl.dart';
import 'package:ardennes/data/datasources/recently_viewed_remote_datasource.dart';
import 'package:ardennes/data/models/recently_viewed_drawing_model.dart';
import 'package:ardennes/domain/entities/recently_viewed_drawing.dart';

import 'recently_viewed_repository_impl_test.mocks.dart';

@GenerateMocks([RecentlyViewedRemoteDataSource])
void main() {
  group('RecentlyViewedRepositoryImpl', () {
    late RecentlyViewedRepositoryImpl repository;
    late MockRecentlyViewedRemoteDataSource mockDataSource;

    setUp(() {
      mockDataSource = MockRecentlyViewedRemoteDataSource();
      repository = RecentlyViewedRepositoryImpl(mockDataSource);
    });

    group('getRecentlyViewedDrawings', () {
      test('should return drawings from data source', () async {
        // Arrange
        const userId = 'test_user_id';
        const projectId = 'test_project_id';
        final dataSourceDrawings = [
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

        when(mockDataSource.getRecentlyViewedDrawings(
          userId: anyNamed('userId'),
          projectId: anyNamed('projectId'),
        )).thenAnswer((_) async => dataSourceDrawings);

        // Act
        final result = await repository.getRecentlyViewedDrawings(
          userId: userId,
          projectId: projectId,
        );

        // Assert
        expect(result, isA<List<RecentlyViewedDrawing>>());
        expect(result.length, equals(2));
        expect(result[0].title, equals('A103'));
        expect(result[0].subtitle, equals('OFFICE FLOOR PLAN'));
        expect(
            result[0].drawingThumbnailUrl, equals('drawing_images/test1.jpg'));
        expect(result[1].title, equals('A104'));
        expect(result[1].subtitle, equals('STRUCTURAL PLAN'));
        expect(
            result[1].drawingThumbnailUrl, equals('drawing_images/test2.jpg'));

        verify(mockDataSource.getRecentlyViewedDrawings(
          userId: userId,
          projectId: projectId,
        )).called(1);
      });

      test('should return empty list when data source returns empty list',
          () async {
        // Arrange
        const userId = 'test_user_id';
        const projectId = 'test_project_id';
        const dataSourceDrawings = <RecentlyViewedDrawingModel>[];

        when(mockDataSource.getRecentlyViewedDrawings(
          userId: anyNamed('userId'),
          projectId: anyNamed('projectId'),
        )).thenAnswer((_) async => dataSourceDrawings);

        // Act
        final result = await repository.getRecentlyViewedDrawings(
          userId: userId,
          projectId: projectId,
        );

        // Assert
        expect(result, isEmpty);
        verify(mockDataSource.getRecentlyViewedDrawings(
          userId: userId,
          projectId: projectId,
        )).called(1);
      });

      test('should propagate data source exceptions', () async {
        // Arrange
        const userId = 'test_user_id';
        const projectId = 'test_project_id';

        when(mockDataSource.getRecentlyViewedDrawings(
          userId: anyNamed('userId'),
          projectId: anyNamed('projectId'),
        )).thenThrow(Exception('Data source error'));

        // Act & Assert
        expect(
          () => repository.getRecentlyViewedDrawings(
            userId: userId,
            projectId: projectId,
          ),
          throwsException,
        );
      });
    });

    group('addToRecentlyViewed', () {
      test('should convert entity to model and call data source', () async {
        // Arrange
        const userId = 'test_user_id';
        const projectId = 'test_project_id';
        final drawing = RecentlyViewedDrawing(
          title: 'A103',
          subtitle: 'OFFICE FLOOR PLAN',
          drawingThumbnailUrl: 'drawing_images/test.jpg',
        );

        when(mockDataSource.addToRecentlyViewed(
          userId: anyNamed('userId'),
          projectId: anyNamed('projectId'),
          drawing: anyNamed('drawing'),
        )).thenAnswer((_) async {});

        // Act
        await repository.addToRecentlyViewed(
          userId: userId,
          projectId: projectId,
          drawing: drawing,
        );

        // Assert
        verify(mockDataSource.addToRecentlyViewed(
          userId: userId,
          projectId: projectId,
          drawing: argThat(
            isA<RecentlyViewedDrawingModel>()
                .having((d) => d.title, 'title', 'A103')
                .having((d) => d.subtitle, 'subtitle', 'OFFICE FLOOR PLAN')
                .having((d) => d.drawingThumbnailUrl, 'drawingThumbnailUrl',
                    'drawing_images/test.jpg'),
          ),
        )).called(1);
      });

      test('should propagate data source exceptions', () async {
        // Arrange
        const userId = 'test_user_id';
        const projectId = 'test_project_id';
        final drawing = RecentlyViewedDrawing(
          title: 'A103',
          subtitle: 'OFFICE FLOOR PLAN',
          drawingThumbnailUrl: 'drawing_images/test.jpg',
        );

        when(mockDataSource.addToRecentlyViewed(
          userId: anyNamed('userId'),
          projectId: anyNamed('projectId'),
          drawing: anyNamed('drawing'),
        )).thenThrow(Exception('Data source error'));

        // Act & Assert
        expect(
          () => repository.addToRecentlyViewed(
            userId: userId,
            projectId: projectId,
            drawing: drawing,
          ),
          throwsException,
        );
      });
    });

    group('watchRecentlyViewedDrawings', () {
      test(
          'should return stream from data source and convert models to entities',
          () async {
        // Arrange
        const userId = 'test_user_id';
        const projectId = 'test_project_id';
        final dataSourceDrawings = [
          RecentlyViewedDrawingModel(
            title: 'A103',
            subtitle: 'OFFICE FLOOR PLAN',
            drawingThumbnailUrl: 'drawing_images/test1.jpg',
          ),
        ];

        when(mockDataSource.watchRecentlyViewedDrawings(
          userId: anyNamed('userId'),
          projectId: anyNamed('projectId'),
        )).thenAnswer((_) => Stream.value(dataSourceDrawings));

        // Act
        final stream = repository.watchRecentlyViewedDrawings(
          userId: userId,
          projectId: projectId,
        );
        final result = await stream.first;

        // Assert
        expect(stream, isA<Stream<List<RecentlyViewedDrawing>>>());
        expect(result, isA<List<RecentlyViewedDrawing>>());
        expect(result.length, equals(1));
        expect(result[0].title, equals('A103'));
        expect(result[0].subtitle, equals('OFFICE FLOOR PLAN'));
        expect(
            result[0].drawingThumbnailUrl, equals('drawing_images/test1.jpg'));

        verify(mockDataSource.watchRecentlyViewedDrawings(
          userId: userId,
          projectId: projectId,
        )).called(1);
      });

      test('should handle empty stream from data source', () async {
        // Arrange
        const userId = 'test_user_id';
        const projectId = 'test_project_id';
        const dataSourceDrawings = <RecentlyViewedDrawingModel>[];

        when(mockDataSource.watchRecentlyViewedDrawings(
          userId: anyNamed('userId'),
          projectId: anyNamed('projectId'),
        )).thenAnswer((_) => Stream.value(dataSourceDrawings));

        // Act
        final stream = repository.watchRecentlyViewedDrawings(
          userId: userId,
          projectId: projectId,
        );
        final result = await stream.first;

        // Assert
        expect(result, isEmpty);
        verify(mockDataSource.watchRecentlyViewedDrawings(
          userId: userId,
          projectId: projectId,
        )).called(1);
      });

      test('should handle stream errors from data source', () async {
        // Arrange
        const userId = 'test_user_id';
        const projectId = 'test_project_id';

        when(mockDataSource.watchRecentlyViewedDrawings(
          userId: anyNamed('userId'),
          projectId: anyNamed('projectId'),
        )).thenAnswer((_) => Stream.error(Exception('Data source error')));

        // Act
        final stream = repository.watchRecentlyViewedDrawings(
          userId: userId,
          projectId: projectId,
        );

        // Assert
        expect(stream.first, throwsException);
        verify(mockDataSource.watchRecentlyViewedDrawings(
          userId: userId,
          projectId: projectId,
        )).called(1);
      });
    });
  });
}
