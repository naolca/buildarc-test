import 'package:flutter_test/flutter_test.dart';
import 'package:ardennes/features/recently_viewed/states/recently_viewed_state.dart';
import 'package:ardennes/domain/entities/recently_viewed_drawing.dart';

void main() {
  group('RecentlyViewedState', () {
    group('RecentlyViewedInitial', () {
      test('should create RecentlyViewedInitial state', () {
        // Act
        const state = RecentlyViewedInitial();

        // Assert
        expect(state, isA<RecentlyViewedState>());
      });

      test('should be equal to another RecentlyViewedInitial', () {
        // Arrange
        const state1 = RecentlyViewedInitial();
        const state2 = RecentlyViewedInitial();

        // Act & Assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });
    });

    group('RecentlyViewedLoading', () {
      test('should create RecentlyViewedLoading state', () {
        // Act
        const state = RecentlyViewedLoading();

        // Assert
        expect(state, isA<RecentlyViewedState>());
      });

      test('should be equal to another RecentlyViewedLoading', () {
        // Arrange
        const state1 = RecentlyViewedLoading();
        const state2 = RecentlyViewedLoading();

        // Act & Assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });
    });

    group('RecentlyViewedLoaded', () {
      test('should create RecentlyViewedLoaded state with drawings', () {
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

        // Act
        final state = RecentlyViewedLoaded(drawings: drawings);

        // Assert
        expect(state, isA<RecentlyViewedState>());
        expect(state.drawings, equals(drawings));
        expect(state.drawings.length, equals(2));
      });

      test('should create RecentlyViewedLoaded state with empty drawings', () {
        // Arrange
        const drawings = <RecentlyViewedDrawing>[];

        // Act
        const state = RecentlyViewedLoaded(drawings: drawings);

        // Assert
        expect(state, isA<RecentlyViewedState>());
        expect(state.drawings, equals(drawings));
        expect(state.drawings, isEmpty);
      });

      test('should be equal when drawings are the same', () {
        // Arrange
        final drawings = [
          RecentlyViewedDrawing(
            title: 'A103',
            subtitle: 'OFFICE FLOOR PLAN',
            drawingThumbnailUrl: 'drawing_images/test1.jpg',
          ),
        ];

        final state1 = RecentlyViewedLoaded(drawings: drawings);
        final state2 = RecentlyViewedLoaded(drawings: drawings);

        // Act & Assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('should not be equal when drawings are different', () {
        // Arrange
        final drawings1 = [
          RecentlyViewedDrawing(
            title: 'A103',
            subtitle: 'OFFICE FLOOR PLAN',
            drawingThumbnailUrl: 'drawing_images/test1.jpg',
          ),
        ];

        final drawings2 = [
          RecentlyViewedDrawing(
            title: 'A104',
            subtitle: 'STRUCTURAL PLAN',
            drawingThumbnailUrl: 'drawing_images/test2.jpg',
          ),
        ];

        final state1 = RecentlyViewedLoaded(drawings: drawings1);
        final state2 = RecentlyViewedLoaded(drawings: drawings2);

        // Act & Assert
        expect(state1, isNot(equals(state2)));
        expect(state1.hashCode, isNot(equals(state2.hashCode)));
      });
    });

    group('RecentlyViewedError', () {
      test('should create RecentlyViewedError state with message', () {
        // Arrange
        const message = 'Test error message';

        // Act
        const state = RecentlyViewedError(message: message);

        // Assert
        expect(state, isA<RecentlyViewedState>());
        expect(state.message, equals(message));
      });

      test('should be equal when messages are the same', () {
        // Arrange
        const message = 'Test error message';

        const state1 = RecentlyViewedError(message: message);
        const state2 = RecentlyViewedError(message: message);

        // Act & Assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('should not be equal when messages are different', () {
        // Arrange
        const state1 = RecentlyViewedError(message: 'Error 1');
        const state2 = RecentlyViewedError(message: 'Error 2');

        // Act & Assert
        expect(state1, isNot(equals(state2)));
        expect(state1.hashCode, isNot(equals(state2.hashCode)));
      });
    });

    group('State equality', () {
      test('should not be equal when different state types', () {
        // Arrange
        const initialState = RecentlyViewedInitial();
        const loadingState = RecentlyViewedLoading();
        const loadedState = RecentlyViewedLoaded(drawings: []);
        const errorState = RecentlyViewedError(message: 'Error');

        // Act & Assert
        expect(initialState, isNot(equals(loadingState)));
        expect(initialState, isNot(equals(loadedState)));
        expect(initialState, isNot(equals(errorState)));
        expect(loadingState, isNot(equals(loadedState)));
        expect(loadingState, isNot(equals(errorState)));
        expect(loadedState, isNot(equals(errorState)));
      });
    });
  });
}
