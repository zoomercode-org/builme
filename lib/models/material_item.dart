class MaterialItem {
  final String id;
  final String name;
  final String projectName;
  final int totalQuantity;
  final int received;
  final int used;
  final String unit; // Bags, Tons, Nos, Cu.ft
  final String status; // Available, Low Stock, Reorder Soon
  final int lowStockThreshold;

  MaterialItem({
    required this.id,
    required this.name,
    required this.projectName,
    required this.totalQuantity,
    required this.received,
    required this.used,
    required this.unit,
    required this.status,
    required this.lowStockThreshold,
  });

  int get remaining => received - used;
}
