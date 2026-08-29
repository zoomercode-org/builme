class DocumentItem {
  final String id;
  final String fileName;
  final String category; // Project Plans, Drawings, Contracts, Bills, Reports, Other
  final String projectName;
  final String uploadedBy;
  final String date;
  final String fileSize;
  final String fileType; // PDF, DWG, XLSX, DOCX

  DocumentItem({
    required this.id,
    required this.fileName,
    required this.category,
    required this.projectName,
    required this.uploadedBy,
    required this.date,
    required this.fileSize,
    required this.fileType,
  });
}
