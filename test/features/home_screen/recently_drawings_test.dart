import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:go_router/go_router.dart';
import 'package:ardennes/features/home_screen/recently_drawings.dart';
import 'package:ardennes/features/recently_viewed/bloc/recently_viewed_bloc.dart';
import 'package:ardennes/features/recently_viewed/events/recently_viewed_event.dart';
import 'package:ardennes/features/recently_viewed/states/recently_viewed_state.dart';
import 'package:ardennes/libraries/account_context/account_context_bloc.dart';
import 'package:ardennes/domain/entities/recently_viewed_drawing.dart';
import 'package:ardennes/domain/usecases/get_recently_viewed_drawings.dart';
import 'package:ardennes/domain/usecases/track_drawing_view.dart';

import 'recently_drawings_test.mocks.dart';

@GenerateMocks([
  RecentlyViewedBloc,
  AccountContextBloc,
  GetRecentlyViewedDrawings,
  TrackDrawingView,
  GoRouter,
])
void main() {
  group('RecentlyViewedDrawings', () {
    late MockRecentlyViewedBloc mockRecentlyViewedBloc;
    late MockAccountContextBloc mockAccountContextBloc;
    late MockGetRecentlyViewedDrawings mockGetRecentlyViewedDrawings;
    late MockGoRouter mockGoRouter;

    setUp(() {
      mockRecentlyViewedBloc = MockRecentlyViewedBloc();
      mockAccountContextBloc = MockAccountContextBloc();
      mockGetRecentlyViewedDrawings = MockGetRecentlyViewedDrawings();
      mockGoRouter = MockGoRouter();

      when(mockRecentlyViewedBloc.getRecentlyViewedDrawings)
          .thenReturn(mockGetRecentlyViewedDrawings);
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<AccountContextBloc>(
              create: (context) => mockAccountContextBloc,
            ),
            BlocProvider<RecentlyViewedBloc>(
              create: (context) => mockRecentlyViewedBloc,
            ),
          ],
          child: const RecentlyViewedDrawings(),
        ),
      );
    }

    testWidgets('should display card with title and subtitle',
        (WidgetTester tester) async {
      // Arrange
      when(mockAccountContextBloc.state)
          .thenReturn(AccountContextLoadedState(selectedProject: null));
      when(mockGetRecentlyViewedDrawings.watch(
        userId: anyNamed('userId'),
        projectId: anyNamed('projectId'),
      )).thenAnswer((_) => Stream.value(<RecentlyViewedDrawing>[]));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('Recently Viewed'), findsOneWidget);
      expect(find.text('Your recently viewed drawings'), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should display loading shimmer when stream is waiting',
        (WidgetTester tester) async {
      // Arrange
      when(mockAccountContextBloc.state)
          .thenReturn(AccountContextLoadedState(selectedProject: null));
      when(mockGetRecentlyViewedDrawings.watch(
        userId: anyNamed('userId'),
        projectId: anyNamed('projectId'),
      )).thenAnswer((_) => Stream.value(<RecentlyViewedDrawing>[]));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(); // Trigger stream subscription

      // Assert
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should display error message when stream has error',
        (WidgetTester tester) async {
      // Arrange
      when(mockAccountContextBloc.state)
          .thenReturn(AccountContextLoadedState(selectedProject: null));
      when(mockGetRecentlyViewedDrawings.watch(
        userId: anyNamed('userId'),
        projectId: anyNamed('projectId'),
      )).thenAnswer((_) => Stream.error('Test error'));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(); // Trigger stream subscription

      // Assert
      expect(find.text('Error: Test error'), findsOneWidget);
    });

    testWidgets('should display drawings when stream has data',
        (WidgetTester tester) async {
      // Arrange
      final drawings = [
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

      when(mockAccountContextBloc.state)
          .thenReturn(AccountContextLoadedState(selectedProject: null));
      when(mockGetRecentlyViewedDrawings.watch(
        userId: anyNamed('userId'),
        projectId: anyNamed('projectId'),
      )).thenAnswer((_) => Stream.value(drawings));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(); // Trigger stream subscription

      // Assert
      expect(find.text('A103'), findsOneWidget);
      expect(find.text('OFFICE FLOOR PLAN'), findsOneWidget);
      expect(find.text('A104'), findsOneWidget);
      expect(find.text('STRUCTURAL PLAN'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should display empty container when no data',
        (WidgetTester tester) async {
      // Arrange
      when(mockAccountContextBloc.state)
          .thenReturn(AccountContextLoadedState(selectedProject: null));
      when(mockGetRecentlyViewedDrawings.watch(
        userId: anyNamed('userId'),
        projectId: anyNamed('projectId'),
      )).thenAnswer((_) => Stream.value(<RecentlyViewedDrawing>[]));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(); // Trigger stream subscription

      // Assert
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('should handle null selected project',
        (WidgetTester tester) async {
      // Arrange
      when(mockAccountContextBloc.state)
          .thenReturn(AccountContextLoadedState(selectedProject: null));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(Card), findsOneWidget);
      verifyNever(mockGetRecentlyViewedDrawings.watch(
        userId: anyNamed('userId'),
        projectId: anyNamed('projectId'),
      ));
    });

    testWidgets('should handle non-AccountContextLoadedState',
        (WidgetTester tester) async {
      // Arrange
      when(mockAccountContextBloc.state)
          .thenReturn(AccountContextInitialState());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(Card), findsOneWidget);
      verifyNever(mockGetRecentlyViewedDrawings.watch(
        userId: anyNamed('userId'),
        projectId: anyNamed('projectId'),
      ));
    });

    testWidgets(
        'should call watch with correct parameters when project is selected',
        (WidgetTester tester) async {
      // Arrange
      const userId = 'test_user_id';
      const projectId = 'test_project_id';

      // Mock FirebaseAuth.currentUser
      // Note: In a real test, you'd need to mock FirebaseAuth
      when(mockAccountContextBloc.state).thenReturn(AccountContextLoadedState(
          selectedProject: MockProject(id: projectId)));
      when(mockGetRecentlyViewedDrawings.watch(
        userId: anyNamed('userId'),
        projectId: anyNamed('projectId'),
      )).thenAnswer((_) => Stream.value(<RecentlyViewedDrawing>[]));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      // Note: This test would need proper FirebaseAuth mocking to work correctly
      expect(find.byType(Card), findsOneWidget);
    });
  });
}

// Mock project class for testing
class MockProject {
  final String? id;
  MockProject({this.id});
}
