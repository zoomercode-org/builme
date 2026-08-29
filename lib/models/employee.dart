class Employee {
  final String id;
  final String name;
  final String role; // Site Worker, Engineer, Supervisor, Admin, Safety
  final String projectName;
  final String phone;
  final String avatarUrl;
  final String status; // Active, On Leave, Inactive
  final String attendanceToday; // Present, Absent, Late
  final String checkInTime;
  final String checkOutTime;
  final bool isVerified;
  final List<String> skills;

  Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.projectName,
    required this.phone,
    required this.avatarUrl,
    required this.status,
    required this.attendanceToday,
    required this.checkInTime,
    required this.checkOutTime,
    required this.isVerified,
    required this.skills,
  });
}
