import 'package:ardennes/features/recently_viewed/bloc/recently_viewed_bloc.dart';
import 'package:ardennes/features/recently_viewed/events/recently_viewed_event.dart';
import 'package:ardennes/libraries/account_context/bloc.dart';
import 'package:ardennes/libraries/account_context/state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'recently_drawings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return _HomeScreenContent();
  }
}

class _HomeScreenContent extends StatefulWidget {
  @override
  State<_HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<_HomeScreenContent> {
  String? _lastProjectId;
  String? _lastUserId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This gets called when the widget is rebuilt, including when returning from other screens
    _loadRecentlyViewed();
  }

  void _loadRecentlyViewed() {
    final accountState = context.read<AccountContextBloc>().state;
    if (accountState is AccountContextLoadedState) {
      final selectedProject = accountState.selectedProject;
      if (selectedProject != null) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null && selectedProject.id != null) {
          print(
              '🔄 HomeScreen: Loading recently viewed for user ${user.uid} in project ${selectedProject.id}');
          context.read<RecentlyViewedBloc>().add(LoadRecentlyViewedEvent(
                userId: user.uid,
                projectId: selectedProject.id!,
              ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountState = context.watch<AccountContextBloc>().state;
    final recentlyViewedState = context.watch<RecentlyViewedBloc>().state;

    if (accountState is AccountContextLoadedState) {
      final selectedProject = accountState.selectedProject;
      if (selectedProject != null) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null && selectedProject.id != null) {
          // Check if we need to load recently viewed for a different project/user
          if (_lastProjectId != selectedProject.id || _lastUserId != user.uid) {
            print(
                '🏠 HomeScreen: Loading recently viewed for user ${user.uid} in project ${selectedProject.id}');
            _lastProjectId = selectedProject.id;
            _lastUserId = user.uid;

            // Load recently viewed data
            context.read<RecentlyViewedBloc>().add(LoadRecentlyViewedEvent(
                  userId: user.uid,
                  projectId: selectedProject.id!,
                ));
          }
        } else {
          print(
              '❌ HomeScreen: No user or project ID available - User: ${user?.uid}, Project ID: ${selectedProject.id}');
        }
      }
    }

    return ListView(padding: const EdgeInsets.all(16), children: [
      Text("Welcome, ${FirebaseAuth.instance.currentUser?.displayName ?? ""}",
          style: Theme.of(context).textTheme.titleLarge),
      Text("Here's what's happening on your projects today.",
          style: Theme.of(context).textTheme.titleSmall),
      const SizedBox(height: 16),
      Card(
        elevation: 1,
        child: ListTile(
            leading: const Icon(Icons.sticky_note_2),
            title: const Text('Add Sheets'),
            onTap: () => context.go('/drawing-publish/file-upload')),
      ),
      const RecentlyViewedDrawings(),
    ]);
  }
}
