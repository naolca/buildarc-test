import 'package:ardennes/features/drawings_catalog/drawings_catalog_bloc.dart';
import 'package:ardennes/features/recently_viewed/bloc/recently_viewed_bloc.dart';
import 'package:ardennes/features/drawing_detail/drawing_detail_bloc.dart';
import 'package:ardennes/libraries/account_context/bloc.dart';
import 'package:ardennes/libraries/drawing/drawing_catalog_loader.dart';
import 'package:ardennes/libraries/drawing/image_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();

abstract class Env {
  static const dev = 'dev';
  static const prod = 'prod';
}

@module
abstract class RegisterModule {
  @factoryMethod
  DrawingsCatalogBloc get drawingsCatalogBloc =>
      DrawingsCatalogBloc(getIt<DrawingCatalogService>());

  @factoryMethod
  AccountContextBloc get accountContextBloc => AccountContextBloc();

  @factoryMethod
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  @factoryMethod
  UIImageProvider get uiImageProvider => UIImageProvider();

  @factoryMethod
  DrawingDetailBloc get drawingDetailBloc => DrawingDetailBloc(
        uiImageProvider: getIt<UIImageProvider>(),
        recentlyViewedBloc: getIt<RecentlyViewedBloc>(),
      );
}
