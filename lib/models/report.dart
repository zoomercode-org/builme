class ReportCard {
  final String id;
  final String title;
  final String description;
  final String category; // Project, Cost, Attendance, Material, Daily Progress
  final String lastGenerated;
  final String iconType;

  ReportCard({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.lastGenerated,
    required this.iconType,
  });
}
