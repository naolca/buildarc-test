import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ardennes/data/datasources/recently_viewed_remote_datasource.dart';
import 'package:ardennes/data/models/recently_viewed_drawing_model.dart';

import 'recently_viewed_remote_datasource_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  Query,
  QuerySnapshot,
  DocumentSnapshot,
  DocumentReference,
  WriteBatch,
  Transaction,
])
void main() {
  group('RecentlyViewedRemoteDataSourceImpl', () {
    late RecentlyViewedRemoteDataSourceImpl dataSource;
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference mockCollection;
    late MockQuery mockQuery;
    late MockQuerySnapshot mockQuerySnapshot;
    late MockDocumentSnapshot mockDocumentSnapshot;
    late MockDocumentReference mockDocumentReference;
    late MockTransaction mockTransaction;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockCollection = MockCollectionReference();
      mockQuery = MockQuery();
      mockQuerySnapshot = MockQuerySnapshot();
      mockDocumentSnapshot = MockDocumentSnapshot();
      mockDocumentReference = MockDocumentReference();
      mockTransaction = MockTransaction();

      dataSource = RecentlyViewedRemoteDataSourceImpl(mockFirestore);

      // Setup common mocks
      when(mockFirestore.collection(any)).thenReturn(mockCollection);
      when(mockCollection.where(any, isEqualTo: any)).thenReturn(mockQuery);
      when(mockQuery.limit(any)).thenReturn(mockQuery);
      when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(mockQuery.snapshots())
          .thenAnswer((_) => Stream.value(mockQuerySnapshot));
      when(mockQuerySnapshot.docs).thenReturn([mockDocumentSnapshot]);
      when(mockDocumentSnapshot.exists).thenReturn(true);
      when(mockDocumentSnapshot.reference).thenReturn(mockDocumentReference);
      when(mockDocumentSnapshot.data()).thenReturn({
        'drawings': [
          {
            'title': 'A103',
            'subtitle': 'OFFICE FLOOR PLAN',
            'drawingThumbnailUrl': 'drawing_images/test1.jpg',
          }
        ],
        'user_id': 'test_user_id',
        'project_id': 'test_project_id',
      });
      when(mockCollection.doc()).thenReturn(mockDocumentReference);
      when(mockFirestore.runTransaction(any)).thenAnswer((invocation) async {
        final transactionCallback = invocation.positionalArguments[0]
            as Future<void> Function(Transaction);
        await transactionCallback(mockTransaction);
      });
      when(mockTransaction.get(any))
          .thenAnswer((_) async => mockDocumentSnapshot);
      when(mockTransaction.set(any, any)).thenReturn(null);
    });

    group('getRecentlyViewedDrawings', () {
      test('should return drawings when document exists', () async {
        // Arrange
        const userId = 'test_user_id';
        const projectId = 'test_project_id';

        // Act
        final result = await dataSource.getRecentlyViewedDrawings(
          userId: userId,
          projectId: projectId,
        );

        // Assert
        expect(result, isA<List<RecentlyViewedDrawingModel>>());
        expect(result.length, equals(1));
        expect(result.first.title, equals('A103'));
        expect(result.first.subtitle, equals('OFFICE FLOOR PLAN'));
        expect(result.first.drawingThumbnailUrl,
            equals('drawing_images/test1.jpg'));

        verify(mockFirestore.collection('home_screens')).called(1);
        verify(mockCollection.where('user_id', isEqualTo: userId)).called(1);
        verify(mockCollection.where('project_id', isEqualTo: projectId))
            .called(1);
      });

      test('should return empty list when no documents exist', () async {
        // Arrange
        const userId = 'test_user_id';
        const projectId = 'test_project_id';
        when(mockQuerySnapshot.docs).thenReturn([]);

        // Act
        final result = await dataSource.getRecentlyViewedDrawings(
          userId: userId,
          projectId: projectId,
        );

        // Assert
        expect(result, isEmpty);
      });

      test('should handle documents with no drawings field', () async {
        // Arrange
        const userId = 'test_user_id';
        const projectId = 'test_project_id';
        when(mockDocumentSnapshot.data()).thenReturn({
          'user_id': 'test_user_id',
          'project_id': 'test_project_id',
          // No drawings field
        });

        // Act
        final result = await dataSource.getRecentlyViewedDrawings(
          userId: userId,
          projectId: projectId,
        );

        // Assert
        expect(result, isEmpty);
      });
    });

    group('addToRecentlyViewed', () {
      test('should add drawing to existing document', () async {
        // Arrange
        const userId = 'test_user_id';
        const projectId = 'test_project_id';
        final drawing = RecentlyViewedDrawingModel(
          title: 'A104',
          subtitle: 'STRUCTURAL PLAN',
          drawingThumbnailUrl: 'drawing_images/test2.jpg',
        );

        // Act
        await dataSource.addToRecentlyViewed(
          userId: userId,
          projectId: projectId,
          drawing: drawing,
        );

        // Assert
        verify(mockFirestore.collection('home_screens'))
            .called(2); // Once for query, once for transaction
        verify(mockCollection.where('user_id', isEqualTo: userId)).called(2);
        verify(mockCollection.where('project_id', isEqualTo: projectId))
            .called(2);
        verify(mockFirestore.runTransaction(any)).called(1);
        verify(mockTransaction.set(any, any)).called(1);
      });

      test('should create new document when none exists', () async {
        // Arrange
        const userId = 'test_user_id';
        const projectId = 'test_project_id';
        final drawing = RecentlyViewedDrawingModel(
          title: 'A104',
          subtitle: 'STRUCTURAL PLAN',
          drawingThumbnailUrl: 'drawing_images/test2.jpg',
        );
        when(mockQuerySnapshot.docs).thenReturn([]);

        // Act
        await dataSource.addToRecentlyViewed(
          userId: userId,
          projectId: projectId,
          drawing: drawing,
        );

        // Assert
        verify(mockCollection.doc()).called(1);
        verify(mockFirestore.runTransaction(any)).called(1);
        verify(mockTransaction.set(any, any)).called(1);
      });

      test('should remove duplicates before adding new drawing', () async {
        // Arrange
        const userId = 'test_user_id';
        const projectId = 'test_project_id';
        final drawing = RecentlyViewedDrawingModel(
          title: 'A103', // Same title as existing
          subtitle: 'OFFICE FLOOR PLAN', // Same subtitle as existing
          drawingThumbnailUrl: 'drawing_images/test2.jpg',
        );

        // Act
        await dataSource.addToRecentlyViewed(
          userId: userId,
          projectId: projectId,
          drawing: drawing,
        );

        // Assert
        verify(mockFirestore.runTransaction(any)).called(1);
        verify(mockTransaction.set(any, any)).called(1);
      });

      test('should limit drawings to 10 items', () async {
        // Arrange
        const userId = 'test_user_id';
        const projectId = 'test_project_id';
        final drawing = RecentlyViewedDrawingModel(
          title: 'A104',
          subtitle: 'STRUCTURAL PLAN',
          drawingThumbnailUrl: 'drawing_images/test2.jpg',
        );

        // Create a document with 10 existing drawings
        final existingDrawings = List.generate(
            10,
            (index) => {
                  'title': 'A${100 + index}',
                  'subtitle': 'PLAN $index',
                  'drawingThumbnailUrl': 'drawing_images/test$index.jpg',
                });

        when(mockDocumentSnapshot.data()).thenReturn({
          'drawings': existingDrawings,
          'user_id': 'test_user_id',
          'project_id': 'test_project_id',
        });

        // Act
        await dataSource.addToRecentlyViewed(
          userId: userId,
          projectId: projectId,
          drawing: drawing,
        );

        // Assert
        verify(mockFirestore.runTransaction(any)).called(1);
        verify(mockTransaction.set(any, any)).called(1);
      });
    });

    group('watchRecentlyViewedDrawings', () {
      test('should return stream of drawings', () {
        // Arrange
        const userId = 'test_user_id';
        const projectId = 'test_project_id';

        // Act
        final stream = dataSource.watchRecentlyViewedDrawings(
          userId: userId,
          projectId: projectId,
        );

        // Assert
        expect(stream, isA<Stream<List<RecentlyViewedDrawingModel>>>());
        verify(mockFirestore.collection('home_screens')).called(1);
        verify(mockCollection.where('user_id', isEqualTo: userId)).called(1);
        verify(mockCollection.where('project_id', isEqualTo: projectId))
            .called(1);
        verify(mockQuery.snapshots()).called(1);
      });

      test('should return empty list when no documents exist', () async {
        // Arrange
        const userId = 'test_user_id';
        const projectId = 'test_project_id';
        when(mockQuerySnapshot.docs).thenReturn([]);

        // Act
        final stream = dataSource.watchRecentlyViewedDrawings(
          userId: userId,
          projectId: projectId,
        );
        final result = await stream.first;

        // Assert
        expect(result, isEmpty);
      });

      test('should emit drawings when documents exist', () async {
        // Arrange
        const userId = 'test_user_id';
        const projectId = 'test_project_id';

        // Act
        final stream = dataSource.watchRecentlyViewedDrawings(
          userId: userId,
          projectId: projectId,
        );
        final result = await stream.first;

        // Assert
        expect(result, isA<List<RecentlyViewedDrawingModel>>());
        expect(result.length, equals(1));
        expect(result.first.title, equals('A103'));
      });
    });
  });
}
