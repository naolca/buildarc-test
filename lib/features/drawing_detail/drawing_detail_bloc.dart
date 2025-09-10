import 'package:ardennes/libraries/core_ui/canvas/sketch.dart';
import 'package:ardennes/libraries/drawing/image_provider.dart';
import 'package:ardennes/models/drawings/drawing_detail.dart';
import 'package:ardennes/features/recently_viewed/bloc/recently_viewed_bloc.dart';
import 'package:ardennes/features/recently_viewed/events/recently_viewed_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'drawing_detail_event.dart';
import 'drawing_detail_state.dart';

@injectable
class DrawingDetailBloc extends Bloc<DrawingDetailEvent, DrawingDetailState> {
  final UIImageProvider uiImageProvider;
  final RecentlyViewedBloc recentlyViewedBloc;
  String? currentDrawingDocumentId;

  DrawingDetailBloc({
    required this.uiImageProvider,
    required this.recentlyViewedBloc,
  }) : super(DrawingDetailState().init()) {
    on<LoadSheet>(_loadSheet);
    on<AddAnnotation>(_addAnnotation);
    on<DeleteAnnotation>(_deleteAnnotation);
    on<UpdateAnnotation>(_updateAnnotation);
  }

  void _loadSheet(LoadSheet event, Emitter<DrawingDetailState> emit) async {
    emit(DrawingDetailStateLoading());

    final Query<DrawingDetail> drawingDetailQuery = FirebaseFirestore.instance
        .collection('drawings')
        .where('project', isEqualTo: event.projectId)
        .where('number', isEqualTo: event.number)
        .where('collection', isEqualTo: event.collection)
        .withConverter(
          fromFirestore: DrawingDetail.fromFirestore,
          toFirestore: DrawingDetail.toFirestore,
        );

    try {
      final drawingDetailSnapshot = await drawingDetailQuery.get();
      final drawingDetail = drawingDetailSnapshot.docs.firstOrNull?.data();
      if (drawingDetail != null) {
        currentDrawingDocumentId = drawingDetailSnapshot.docs.firstOrNull?.id;
        final image = await uiImageProvider.getImage(
          drawingDetail.versions[event.versionId]!.files["hd_image"]!,
        );

        // Track drawing view for recently viewed functionality
        _trackDrawingView(
          projectId: event.projectId,
          drawingTitle: event.number,
          drawingCollection: event.collection,
          drawingThumbnailUrl:
              drawingDetail.versions[event.versionId]!.files["hd_image"]!,
        );

        if (currentDrawingDocumentId != null) {
          final annotationsQuery = FirebaseFirestore.instance
              .collection('drawings')
              .doc(currentDrawingDocumentId)
              .collection('annotations')
              .withConverter(
                fromFirestore: Sketch.fromFirestore,
                toFirestore: Sketch.toFirestore,
              );

          // How to use Bloc with streams and concurrency
          // Or, how to migrate your blocs and cubits to Bloc >=7.2.0
          // https://verygood.ventures/blog/how-to-use-bloc-with-streams-and-concurrency
          await emit.forEach(
            annotationsQuery.snapshots(),
            onData: (annotationsSnapshot) {
              final List<Sketch> annotations =
                  annotationsSnapshot.docs.map((doc) => doc.data()).toList();

              annotations.sort((a, b) => a.updateTime.compareTo(b.updateTime));
              return DrawingDetailStateLoaded(
                drawingDetail: drawingDetail,
                image: image,
                annotations: Sketches(annotations, DateTime.now()),
              );
            },
          );
        }
      } else {
        emit(DrawingDetailStateError(errorMessage: 'No drawing found'));
      }
    } catch (e) {
      emit(DrawingDetailStateError(errorMessage: e.toString()));
    }
  }

  void _addAnnotation(
      AddAnnotation event, Emitter<DrawingDetailState> emit) async {
    final annotation = event.annotation;
    final annotationMap = Sketch.toFirestoreOptimized(annotation, null);

    final documentId = currentDrawingDocumentId;
    if (documentId == null) {
      emit(DrawingDetailStateError(errorMessage: 'No drawing found'));
    } else {
      await FirebaseFirestore.instance
          .collection('drawings')
          .doc(documentId)
          .collection('annotations')
          .add(annotationMap);
    }
  }

  void _deleteAnnotation(
      DeleteAnnotation event, Emitter<DrawingDetailState> emit) async {
    final documentId = currentDrawingDocumentId;
    if (documentId == null) {
      emit(DrawingDetailStateError(errorMessage: 'No drawing found'));
    } else {
      await FirebaseFirestore.instance
          .collection('drawings')
          .doc(documentId)
          .collection('annotations')
          .doc(event.annotationId)
          .delete();
    }
  }

  void _updateAnnotation(
      UpdateAnnotation event, Emitter<DrawingDetailState> emit) async {
    final annotation = event.annotation;
    final annotationMap = Sketch.toFirestoreOptimized(annotation, null);

    final documentId = currentDrawingDocumentId;
    if (documentId == null) {
      emit(DrawingDetailStateError(errorMessage: 'No drawing found'));
    } else {
      await FirebaseFirestore.instance
          .collection('drawings')
          .doc(documentId)
          .collection('annotations')
          .doc(event.annotation.documentId)
          .update(annotationMap);
    }
  }

  void _trackDrawingView({
    required String projectId,
    required String drawingTitle,
    required String drawingCollection,
    required String drawingThumbnailUrl,
  }) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      recentlyViewedBloc.add(TrackDrawingViewEvent(
        userId: user.uid,
        projectId: projectId,
        drawingTitle: drawingTitle,
        drawingCollection: drawingCollection,
        drawingThumbnailUrl: drawingThumbnailUrl,
      ));
    }
  }
}
