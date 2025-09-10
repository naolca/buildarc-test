import 'package:ardennes/domain/entities/recently_viewed_drawing.dart';
import 'package:ardennes/features/recently_viewed/bloc/recently_viewed_bloc.dart';
import 'package:ardennes/libraries/account_context/bloc.dart';
import 'package:ardennes/libraries/account_context/state.dart';
import 'package:ardennes/libraries/core_ui/image_downloading/image_firebase.dart';
import 'package:ardennes/libraries/core_ui/shimmer/bar_shimmer.dart';
import 'package:ardennes/libraries/extensions/scoped.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RecentlyViewedDrawings extends StatelessWidget {
  const RecentlyViewedDrawings({Key? key}) : super(key: key);

  Stream<List<RecentlyViewedDrawing>> _getRecentlyViewedStream(
      BuildContext context) {
    final accountState = context.watch<AccountContextBloc>().state;
    if (accountState is AccountContextLoadedState) {
      final selectedProject = accountState.selectedProject;
      if (selectedProject != null) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null && selectedProject.id != null) {
          print(
              '🔄 RecentlyViewedDrawings: Setting up stream for user ${user.uid} in project ${selectedProject.id}');
          // Use the repository directly to get the stream
          final recentlyViewedBloc = context.read<RecentlyViewedBloc>();
          return recentlyViewedBloc.getRecentlyViewedDrawings.watch(
            userId: user.uid,
            projectId: selectedProject.id!,
          );
        }
      }
    }
    print('❌ RecentlyViewedDrawings: No user or project available for stream');
    return Stream.value(<RecentlyViewedDrawing>[]);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 1,
        child: Column(children: [
          ListTile(
            leading: Text("Recently viewed sheets",
                style: Theme.of(context).textTheme.titleLarge),
            trailing: TextButton(
              onPressed: () {},
              child:
                  Text("See all", style: Theme.of(context).textTheme.bodyLarge),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(height: 0),
          ),
          SizedBox(
              height: 240,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: StreamBuilder<List<RecentlyViewedDrawing>>(
                      stream: _getRecentlyViewedStream(context),
                      builder: (context, snapshot) {
                        print(
                            '📊 StreamBuilder: Connection state: ${snapshot.connectionState}, Has data: ${snapshot.hasData}, Has error: ${snapshot.hasError}');
                        if (snapshot.hasData) {
                          print(
                              '📊 StreamBuilder: Data length: ${snapshot.data!.length}');
                        }
                        if (snapshot.hasError) {
                          print('❌ StreamBuilder: Error: ${snapshot.error}');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const BarShimmer(
                            baseColor: Colors.grey,
                            highlightColor: Colors.white,
                            height: 20.0,
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          final drawings = snapshot.data!;
                          return ListView.separated(
                            padding: const EdgeInsets.only(
                                top: 16.0, bottom: 16.0, right: 16.0),
                            scrollDirection: Axis.horizontal,
                            itemCount: drawings.length,
                            itemBuilder: (BuildContext context, int index) =>
                                drawings[index].let((drawing) {
                              return _RecentlyViewedDrawingTile(
                                  title: drawing.title,
                                  subtitle: drawing.subtitle,
                                  drawingThumbnailUrl:
                                      drawing.drawingThumbnailUrl);
                            }),
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const SizedBox(width: 16.0),
                          );
                        } else {
                          return Container();
                        }
                      })))
        ]));
  }
}

class _RecentlyViewedDrawingTile extends StatelessWidget {
  const _RecentlyViewedDrawingTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.drawingThumbnailUrl,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String drawingThumbnailUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          context.go(
            Uri(
              path: '/drawings/sheet',
              queryParameters: {
                'number': title,
                'collection': subtitle,
                'versionId': "0",
              },
            ).toString(),
          );
        },
        child: Container(
          width: 135,
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.0,
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Column(children: [
                Expanded(
                  flex: 4,
                  // child: Image.asset(drawingThumbnailUrl),
                  child: ImageFromFirebase(imageUrl: drawingThumbnailUrl),
                ),
                const Divider(),
                Expanded(
                    flex: 2,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            subtitle,
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ])),
              ])),
        ));
  }
}
