import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/project.dart';
import '../core/mock/mock_data.dart';

class ProjectsState {
  final List<Project> projects;
  final String statusFilter; // All, Active, Completed, Delayed
  final String searchQuery;

  ProjectsState({
    required this.projects,
    required this.statusFilter,
    required this.searchQuery,
  });

  List<Project> get filteredProjects {
    return projects.where((p) {
      final matchesSearch = p.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          p.client.toLowerCase().contains(searchQuery.toLowerCase()) ||
          p.location.toLowerCase().contains(searchQuery.toLowerCase());

      if (!matchesSearch) return false;

      if (statusFilter == 'All') return true;
      if (statusFilter == 'Active') return p.status == 'On Track' || p.status == 'At Risk';
      if (statusFilter == 'Completed') return p.status == 'Completed';
      if (statusFilter == 'Delayed') return p.status == 'Delayed';

      return true;
    }).toList();
  }

  ProjectsState copyWith({
    List<Project>? projects,
    String? statusFilter,
    String? searchQuery,
  }) {
    return ProjectsState(
      projects: projects ?? this.projects,
      statusFilter: statusFilter ?? this.statusFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class ProjectsNotifier extends StateNotifier<ProjectsState> {
  ProjectsNotifier()
      : super(
          ProjectsState(
            projects: MockData.projects,
            statusFilter: 'All',
            searchQuery: '',
          ),
        );

  void setFilter(String filter) {
    state = state.copyWith(statusFilter: filter);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void addProject(Project newProject) {
    state = state.copyWith(projects: [newProject, ...state.projects]);
  }

  void addDailyUpdate(String projectId, DailySiteUpdate update) {
    final updatedProjects = state.projects.map((p) {
      if (p.id == projectId) {
        return p.copyWith(
          dailyUpdates: [update, ...p.dailyUpdates],
          progress: update.progressPercent / 100.0,
        );
      }
      return p;
    }).toList();

    state = state.copyWith(projects: updatedProjects);
  }
}

final projectsProvider = StateNotifierProvider<ProjectsNotifier, ProjectsState>((ref) {
  return ProjectsNotifier();
});

final selectedProjectIdProvider = StateProvider<String>((ref) => 'proj-1');

final selectedProjectProvider = Provider<Project>((ref) {
  final projects = ref.watch(projectsProvider).projects;
  final selectedId = ref.watch(selectedProjectIdProvider);
  return projects.firstWhere(
    (p) => p.id == selectedId,
    orElse: () => projects.first,
  );
});
