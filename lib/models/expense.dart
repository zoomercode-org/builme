class Expense {
  final String id;
  final String date;
  final String description;
  final String projectName;
  final String category; // Materials, Labor, Equipment, Transport, Permits, Utility
  final double amount;
  final String submittedBy;
  final String status; // Approved, Pending, Overbudget, Rejected

  Expense({
    required this.id,
    required this.date,
    required this.description,
    required this.projectName,
    required this.category,
    required this.amount,
    required this.submittedBy,
    required this.status,
  });
}
