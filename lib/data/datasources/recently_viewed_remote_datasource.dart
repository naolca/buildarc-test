import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../models/home_screen_data_model.dart';
import '../models/recently_viewed_drawing_model.dart';

abstract class RecentlyViewedRemoteDataSource {
  Future<List<RecentlyViewedDrawingModel>> getRecentlyViewedDrawings({
    required String userId,
    required String projectId,
  });

  Future<void> addToRecentlyViewed({
    required String userId,
    required String projectId,
    required RecentlyViewedDrawingModel drawing,
  });

  Stream<List<RecentlyViewedDrawingModel>> watchRecentlyViewedDrawings({
    required String userId,
    required String projectId,
  });
}

@Injectable(as: RecentlyViewedRemoteDataSource)
class RecentlyViewedRemoteDataSourceImpl
    implements RecentlyViewedRemoteDataSource {
  final FirebaseFirestore _firestore;

  RecentlyViewedRemoteDataSourceImpl(this._firestore);

  @override
  Future<List<RecentlyViewedDrawingModel>> getRecentlyViewedDrawings({
    required String userId,
    required String projectId,
  }) async {
    final query = await _firestore
        .collection('home_screens')
        .where('user_id', isEqualTo: userId)
        .where('project_id', isEqualTo: projectId)
        .withConverter(
          fromFirestore: HomeScreenDataModel.fromFirestore,
          toFirestore: HomeScreenDataModel.toFirestore,
        )
        .get(GetOptions(source: Source.server)); // Force server read

    if (query.docs.isEmpty) {
      return [];
    }

    return query.docs.first.data().drawings;
  }

  @override
  Future<void> addToRecentlyViewed({
    required String userId,
    required String projectId,
    required RecentlyViewedDrawingModel drawing,
  }) async {
    // First, find existing document outside transaction
    final query = await _firestore
        .collection('home_screens')
        .where('user_id', isEqualTo: userId)
        .where('project_id', isEqualTo: projectId)
        .limit(1)
        .get();

    List<RecentlyViewedDrawingModel> drawings = [];
    DocumentReference docRef;

    if (query.docs.isNotEmpty) {
      // Document exists, get the data
      final doc = query.docs.first;
      docRef = doc.reference;
      final data = doc.data() as Map<String, dynamic>?;
      if (data != null && data['drawings'] != null) {
        drawings = (data['drawings'] as List)
            .map((d) =>
                RecentlyViewedDrawingModel.fromJson(d as Map<String, dynamic>))
            .toList();
      }
    } else {
      // Document doesn't exist, create new one
      docRef = _firestore.collection('home_screens').doc();
    }

    await _firestore.runTransaction((transaction) async {
      // Get the latest data in transaction
      final doc = await transaction.get(docRef);

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null && data['drawings'] != null) {
          drawings = (data['drawings'] as List)
              .map((d) => RecentlyViewedDrawingModel.fromJson(
                  d as Map<String, dynamic>))
              .toList();
        }
      }

      // Remove existing drawing if it exists (to avoid duplicates)
      drawings.removeWhere(
          (d) => d.title == drawing.title && d.subtitle == drawing.subtitle);

      // Add new drawing at the beginning (most recent first)
      drawings.insert(0, drawing);

      // Keep only the last 10 drawings to prevent unlimited growth
      if (drawings.length > 10) {
        drawings = drawings.take(10).toList();
      }

      // Update or create the document
      final dataToSave = {
        'drawings': drawings.map((d) => d.toJson()).toList(),
        'user_id': userId,
        'project_id': projectId,
      };

      transaction.set(docRef, dataToSave);
    });

    // Clean up any duplicate documents that might exist
    await _cleanupDuplicateDocuments(userId, projectId);
  }

  Future<void> _cleanupDuplicateDocuments(
      String userId, String projectId) async {
    final allDocsQuery = await _firestore
        .collection('home_screens')
        .where('user_id', isEqualTo: userId)
        .where('project_id', isEqualTo: projectId)
        .get();

    if (allDocsQuery.docs.length > 1) {
      // Keep the first document (most recent) and delete the rest
      final docsToDelete = allDocsQuery.docs.skip(1).toList();

      for (final doc in docsToDelete) {
        await doc.reference.delete();
      }
    }
  }

  @override
  Stream<List<RecentlyViewedDrawingModel>> watchRecentlyViewedDrawings({
    required String userId,
    required String projectId,
  }) {
    return _firestore
        .collection('home_screens')
        .where('user_id', isEqualTo: userId)
        .where('project_id', isEqualTo: projectId)
        .withConverter(
          fromFirestore: HomeScreenDataModel.fromFirestore,
          toFirestore: HomeScreenDataModel.toFirestore,
        )
        .snapshots(includeMetadataChanges: true)
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return <RecentlyViewedDrawingModel>[];
      }

      return snapshot.docs.first.data().drawings;
    });
  }
}
