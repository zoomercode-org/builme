class ProjectMilestone {
  final String id;
  final String title;
  final double progress; // 0.0 to 1.0
  final String plannedStart;
  final String plannedEnd;
  final String status; // Completed, In Progress, Not Started, Delayed
  final String assignee;

  ProjectMilestone({
    required this.id,
    required this.title,
    required this.progress,
    required this.plannedStart,
    required this.plannedEnd,
    required this.status,
    required this.assignee,
  });
}

class DailySiteUpdate {
  final String id;
  final String date;
  final double progressPercent;
  final String workCompleted;
  final String workPlanned;
  final int workersPresent;
  final String materialsReceived;
  final String issues;
  final String notes;
  final List<String> siteImageUrls;
  final String uploadedBy;

  DailySiteUpdate({
    required this.id,
    required this.date,
    required this.progressPercent,
    required this.workCompleted,
    required this.workPlanned,
    required this.workersPresent,
    required this.materialsReceived,
    required this.issues,
    required this.notes,
    required this.siteImageUrls,
    required this.uploadedBy,
  });
}

class Project {
  final String id;
  final String name;
  final String code;
  final String client;
  final String location;
  final String manager;
  final String imageUrl;
  final double progress; // 0.0 to 1.0
  final double budgetCr; // in Crores
  final double spentCr; // in Crores
  final String startDate;
  final String completionDate;
  final String status; // On Track, Delayed, Completed, At Risk
  final String projectType;
  final String description;
  final List<ProjectMilestone> milestones;
  final List<DailySiteUpdate> dailyUpdates;

  Project({
    required this.id,
    required this.name,
    required this.code,
    required this.client,
    required this.location,
    required this.manager,
    required this.imageUrl,
    required this.progress,
    required this.budgetCr,
    required this.spentCr,
    required this.startDate,
    required this.completionDate,
    required this.status,
    required this.projectType,
    required this.description,
    required this.milestones,
    required this.dailyUpdates,
  });

  double get remainingCr => budgetCr - spentCr;

  Project copyWith({
    String? id,
    String? name,
    String? code,
    String? client,
    String? location,
    String? manager,
    String? imageUrl,
    double? progress,
    double? budgetCr,
    double? spentCr,
    String? startDate,
    String? completionDate,
    String? status,
    String? projectType,
    String? description,
    List<ProjectMilestone>? milestones,
    List<DailySiteUpdate>? dailyUpdates,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      client: client ?? this.client,
      location: location ?? this.location,
      manager: manager ?? this.manager,
      imageUrl: imageUrl ?? this.imageUrl,
      progress: progress ?? this.progress,
      budgetCr: budgetCr ?? this.budgetCr,
      spentCr: spentCr ?? this.spentCr,
      startDate: startDate ?? this.startDate,
      completionDate: completionDate ?? this.completionDate,
      status: status ?? this.status,
      projectType: projectType ?? this.projectType,
      description: description ?? this.description,
      milestones: milestones ?? this.milestones,
      dailyUpdates: dailyUpdates ?? this.dailyUpdates,
    );
  }
}
