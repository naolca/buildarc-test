import 'package:cloud_firestore/cloud_firestore.dart';
import 'recently_viewed_drawing_model.dart';

class HomeScreenDataModel {
  final List<RecentlyViewedDrawingModel> drawings;

  const HomeScreenDataModel({
    required this.drawings,
  });

  factory HomeScreenDataModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return HomeScreenDataModel(
      drawings: data?['drawings'] is Iterable
          ? List.from(data?['drawings'])
              .map((drawingMap) => RecentlyViewedDrawingModel.fromJson(
                    drawingMap as Map<String, dynamic>,
                  ))
              .toList()
          : [],
    );
  }

  static Map<String, Object?> toFirestore(
    Object? homeScreenData,
    SetOptions? options,
  ) {
    if (homeScreenData is HomeScreenDataModel) {
      return {
        "drawings": homeScreenData.drawings
            .map((drawing) => drawing.toJson())
            .toList(),
      };
    } else {
      throw ArgumentError(
        "homeScreenData is not an instance of HomeScreenDataModel",
      );
    }
  }
}
