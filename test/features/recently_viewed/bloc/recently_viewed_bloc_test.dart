import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:ardennes/features/recently_viewed/bloc/recently_viewed_bloc.dart';
import 'package:ardennes/features/recently_viewed/events/recently_viewed_event.dart';
import 'package:ardennes/features/recently_viewed/states/recently_viewed_state.dart';
import 'package:ardennes/domain/usecases/get_recently_viewed_drawings.dart';
import 'package:ardennes/domain/usecases/track_drawing_view.dart';
import 'package:ardennes/domain/entities/recently_viewed_drawing.dart';

import 'recently_viewed_bloc_test.mocks.dart';

@GenerateMocks([GetRecentlyViewedDrawings, TrackDrawingView])
void main() {
  group('RecentlyViewedBloc', () {
    late RecentlyViewedBloc bloc;
    late MockGetRecentlyViewedDrawings mockGetRecentlyViewedDrawings;
    late MockTrackDrawingView mockTrackDrawingView;

    setUp(() {
      mockGetRecentlyViewedDrawings = MockGetRecentlyViewedDrawings();
      mockTrackDrawingView = MockTrackDrawingView();
      bloc = RecentlyViewedBloc(
        getRecentlyViewedDrawings: mockGetRecentlyViewedDrawings,
        trackDrawingView: mockTrackDrawingView,
      );
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state should be RecentlyViewedInitial', () {
      // Assert
      expect(bloc.state, equals(RecentlyViewedInitial()));
    });

    group('LoadRecentlyViewedEvent', () {
      const userId = 'test_user_id';
      const projectId = 'test_project_id';

      blocTest<RecentlyViewedBloc, RecentlyViewedState>(
        'should emit [RecentlyViewedLoading, RecentlyViewedLoaded] when load is successful',
        build: () {
          final drawings = [
            RecentlyViewedDrawing(
              title: 'A103',
              subtitle: 'OFFICE FLOOR PLAN',
              drawingThumbnailUrl: 'drawing_images/test1.jpg',
            ),
          ];
          when(mockGetRecentlyViewedDrawings(
            userId: anyNamed('userId'),
            projectId: anyNamed('projectId'),
          )).thenAnswer((_) async => drawings);
          return bloc;
        },
        act: (bloc) => bloc.add(LoadRecentlyViewedEvent(
          userId: userId,
          projectId: projectId,
        )),
        expect: () => [
          RecentlyViewedLoading(),
          RecentlyViewedLoaded(drawings: [
            RecentlyViewedDrawing(
              title: 'A103',
              subtitle: 'OFFICE FLOOR PLAN',
              drawingThumbnailUrl: 'drawing_images/test1.jpg',
            ),
          ]),
        ],
        verify: (_) {
          verify(mockGetRecentlyViewedDrawings(
            userId: userId,
            projectId: projectId,
          )).called(1);
        },
      );

      blocTest<RecentlyViewedBloc, RecentlyViewedState>(
        'should emit [RecentlyViewedLoading, RecentlyViewedError] when load fails',
        build: () {
          when(mockGetRecentlyViewedDrawings(
            userId: anyNamed('userId'),
            projectId: anyNamed('projectId'),
          )).thenThrow(Exception('Load error'));
          return bloc;
        },
        act: (bloc) => bloc.add(LoadRecentlyViewedEvent(
          userId: userId,
          projectId: projectId,
        )),
        expect: () => [
          RecentlyViewedLoading(),
          RecentlyViewedError(message: 'Exception: Load error'),
        ],
        verify: (_) {
          verify(mockGetRecentlyViewedDrawings(
            userId: userId,
            projectId: projectId,
          )).called(1);
        },
      );

      blocTest<RecentlyViewedBloc, RecentlyViewedState>(
        'should emit [RecentlyViewedLoading, RecentlyViewedLoaded] with empty list when no drawings found',
        build: () {
          when(mockGetRecentlyViewedDrawings(
            userId: anyNamed('userId'),
            projectId: anyNamed('projectId'),
          )).thenAnswer((_) async => []);
          return bloc;
        },
        act: (bloc) => bloc.add(LoadRecentlyViewedEvent(
          userId: userId,
          projectId: projectId,
        )),
        expect: () => [
          RecentlyViewedLoading(),
          RecentlyViewedLoaded(drawings: []),
        ],
        verify: (_) {
          verify(mockGetRecentlyViewedDrawings(
            userId: userId,
            projectId: projectId,
          )).called(1);
        },
      );
    });

    group('TrackDrawingViewEvent', () {
      const userId = 'test_user_id';
      const projectId = 'test_project_id';
      const drawingTitle = 'A103';
      const drawingCollection = 'OFFICE FLOOR PLAN';
      const drawingThumbnailUrl = 'drawing_images/test.jpg';

      blocTest<RecentlyViewedBloc, RecentlyViewedState>(
        'should track drawing view successfully',
        build: () {
          when(mockTrackDrawingView(
            userId: anyNamed('userId'),
            projectId: anyNamed('projectId'),
            drawingTitle: anyNamed('drawingTitle'),
            drawingCollection: anyNamed('drawingCollection'),
            drawingThumbnailUrl: anyNamed('drawingThumbnailUrl'),
          )).thenAnswer((_) async {});
          return bloc;
        },
        act: (bloc) => bloc.add(TrackDrawingViewEvent(
          userId: userId,
          projectId: projectId,
          drawingTitle: drawingTitle,
          drawingCollection: drawingCollection,
          drawingThumbnailUrl: drawingThumbnailUrl,
        )),
        expect: () => [],
        verify: (_) {
          verify(mockTrackDrawingView(
            userId: userId,
            projectId: projectId,
            drawingTitle: drawingTitle,
            drawingCollection: drawingCollection,
            drawingThumbnailUrl: drawingThumbnailUrl,
          )).called(1);
        },
      );

      blocTest<RecentlyViewedBloc, RecentlyViewedState>(
        'should handle tracking errors gracefully',
        build: () {
          when(mockTrackDrawingView(
            userId: anyNamed('userId'),
            projectId: anyNamed('projectId'),
            drawingTitle: anyNamed('drawingTitle'),
            drawingCollection: anyNamed('drawingCollection'),
            drawingThumbnailUrl: anyNamed('drawingThumbnailUrl'),
          )).thenThrow(Exception('Tracking error'));
          return bloc;
        },
        act: (bloc) => bloc.add(TrackDrawingViewEvent(
          userId: userId,
          projectId: projectId,
          drawingTitle: drawingTitle,
          drawingCollection: drawingCollection,
          drawingThumbnailUrl: drawingThumbnailUrl,
        )),
        expect: () => [],
        verify: (_) {
          verify(mockTrackDrawingView(
            userId: userId,
            projectId: projectId,
            drawingTitle: drawingTitle,
            drawingCollection: drawingCollection,
            drawingThumbnailUrl: drawingThumbnailUrl,
          )).called(1);
        },
      );
    });

    group('RefreshRecentlyViewedEvent', () {
      const userId = 'test_user_id';
      const projectId = 'test_project_id';

      blocTest<RecentlyViewedBloc, RecentlyViewedState>(
        'should emit [RecentlyViewedLoaded] when refresh is successful',
        build: () {
          final drawings = [
            RecentlyViewedDrawing(
              title: 'A103',
              subtitle: 'OFFICE FLOOR PLAN',
              drawingThumbnailUrl: 'drawing_images/test1.jpg',
            ),
          ];
          when(mockGetRecentlyViewedDrawings(
            userId: anyNamed('userId'),
            projectId: anyNamed('projectId'),
          )).thenAnswer((_) async => drawings);
          return bloc;
        },
        act: (bloc) => bloc.add(RefreshRecentlyViewedEvent(
          userId: userId,
          projectId: projectId,
        )),
        expect: () => [
          RecentlyViewedLoaded(drawings: [
            RecentlyViewedDrawing(
              title: 'A103',
              subtitle: 'OFFICE FLOOR PLAN',
              drawingThumbnailUrl: 'drawing_images/test1.jpg',
            ),
          ]),
        ],
        verify: (_) {
          verify(mockGetRecentlyViewedDrawings(
            userId: userId,
            projectId: projectId,
          )).called(1);
        },
      );

      blocTest<RecentlyViewedBloc, RecentlyViewedState>(
        'should emit [RecentlyViewedError] when refresh fails',
        build: () {
          when(mockGetRecentlyViewedDrawings(
            userId: anyNamed('userId'),
            projectId: anyNamed('projectId'),
          )).thenThrow(Exception('Refresh error'));
          return bloc;
        },
        act: (bloc) => bloc.add(RefreshRecentlyViewedEvent(
          userId: userId,
          projectId: projectId,
        )),
        expect: () => [
          RecentlyViewedError(message: 'Exception: Refresh error'),
        ],
        verify: (_) {
          verify(mockGetRecentlyViewedDrawings(
            userId: userId,
            projectId: projectId,
          )).called(1);
        },
      );
    });

    group('getRecentlyViewedDrawings property', () {
      test('should expose getRecentlyViewedDrawings use case', () {
        // Assert
        expect(bloc.getRecentlyViewedDrawings,
            equals(mockGetRecentlyViewedDrawings));
      });
    });
  });
}
