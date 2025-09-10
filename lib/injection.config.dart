// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:ardennes/features/drawing_detail/drawing_detail_bloc.dart'
    as _i8;
import 'package:ardennes/features/drawings_catalog/drawings_catalog_bloc.dart'
    as _i6;
import 'package:ardennes/features/recently_viewed/bloc/recently_viewed_bloc.dart'
    as _i10;
import 'package:ardennes/domain/usecases/get_recently_viewed_drawings.dart'
    as _i11;
import 'package:ardennes/domain/usecases/track_drawing_view.dart' as _i12;
import 'package:ardennes/domain/repositories/recently_viewed_repository.dart'
    as _i13;
import 'package:ardennes/data/repositories/recently_viewed_repository_impl.dart'
    as _i14;
import 'package:ardennes/data/datasources/recently_viewed_remote_datasource.dart'
    as _i15;
import 'package:cloud_firestore/cloud_firestore.dart' as _i16;
import 'package:ardennes/injection.dart' as _i9;
import 'package:ardennes/libraries/account_context/bloc.dart' as _i3;
import 'package:ardennes/libraries/drawing/drawing_catalog_loader.dart' as _i4;
import 'package:ardennes/libraries/drawing/image_provider.dart' as _i7;
import 'package:ardennes/models/projects/project_metadata.dart' as _i5;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.factory<_i3.AccountContextBloc>(() => registerModule.accountContextBloc);
    gh.factoryParam<_i4.DrawingCatalogService, _i5.ProjectMetadata?, dynamic>((
      savedSelectedProject,
      _,
    ) =>
        _i4.DrawingCatalogService(savedSelectedProject: savedSelectedProject));
    gh.factory<_i6.DrawingsCatalogBloc>(
        () => registerModule.drawingsCatalogBloc);
    gh.factory<_i7.UIImageProvider>(() => _i7.UIImageProvider());
    gh.factory<_i16.FirebaseFirestore>(() => _i16.FirebaseFirestore.instance);
    gh.factory<_i15.RecentlyViewedRemoteDataSource>(() =>
        _i15.RecentlyViewedRemoteDataSourceImpl(gh<_i16.FirebaseFirestore>()));
    gh.factory<_i13.RecentlyViewedRepository>(() =>
        _i14.RecentlyViewedRepositoryImpl(
            gh<_i15.RecentlyViewedRemoteDataSource>()));
    gh.factory<_i11.GetRecentlyViewedDrawings>(() =>
        _i11.GetRecentlyViewedDrawings(gh<_i13.RecentlyViewedRepository>()));
    gh.factory<_i12.TrackDrawingView>(
        () => _i12.TrackDrawingView(gh<_i13.RecentlyViewedRepository>()));
    gh.factory<_i10.RecentlyViewedBloc>(() => _i10.RecentlyViewedBloc(
          getRecentlyViewedDrawings: gh<_i11.GetRecentlyViewedDrawings>(),
          trackDrawingView: gh<_i12.TrackDrawingView>(),
        ));
    gh.factory<_i8.DrawingDetailBloc>(() => _i8.DrawingDetailBloc(
          uiImageProvider: gh<_i7.UIImageProvider>(),
          recentlyViewedBloc: gh<_i10.RecentlyViewedBloc>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i9.RegisterModule {}
