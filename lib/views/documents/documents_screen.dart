import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/status_badge.dart';
import '../sheets/upload_document_sheet.dart';
import '../../models/document_item.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  bool _isDrawerOpen = false;

  final List<DocumentItem> _documents = [
    DocumentItem(id: 'd1', fileName: 'Architectural_MasterPlan_v3.dwg', category: 'Drawings', projectName: 'Green Valley Residence', uploadedBy: 'Rahul Menon', date: '10 Jan 2025', fileSize: '42.5 MB', fileType: 'DWG'),
    DocumentItem(id: 'd2', fileName: 'Contractor_Agreement_Signed.pdf', category: 'Contracts', projectName: 'Green Valley Residence', uploadedBy: 'Admin', date: '12 Jan 2025', fileSize: '4.8 MB', fileType: 'PDF'),
    DocumentItem(id: 'd3', fileName: 'Structural_Load_Calculations.xlsx', category: 'Reports', projectName: 'City Mall Extension', uploadedBy: 'Arun Kumar', date: '02 Feb 2025', fileSize: '2.1 MB', fileType: 'XLSX'),
    DocumentItem(id: 'd4', fileName: 'Site_Safety_Protocol_v2.pdf', category: 'Safety', projectName: 'Ocean View Villa', uploadedBy: 'Sameer Khan', date: '15 Mar 2025', fileSize: '8.4 MB', fileType: 'PDF'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Documents & Blueprints', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                          const SizedBox(height: 4),
                          Text('Central repository for CAD drawings, contracts, site reports, and permits.', style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _isDrawerOpen = true),
                      icon: const Icon(Icons.cloud_upload_outlined, size: 18),
                      label: const Text('+ Upload Document'),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.cardBorder),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _documents.length,
                    separatorBuilder: (context, index) => const Divider(color: Color(0xFFF1F5F9), height: 1),
                    itemBuilder: (context, index) {
                      final doc = _documents[index];
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(minWidth: 700),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(8)),
                                  child: Icon(
                                    doc.fileName.endsWith('.dwg') ? Icons.architecture : (doc.fileName.endsWith('.pdf') ? Icons.picture_as_pdf : Icons.insert_drive_file_outlined),
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                SizedBox(
                                  width: 260,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(doc.fileName, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700)),
                                      Text('${doc.projectName} • ${doc.fileSize}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 120, child: StatusBadge(status: doc.category)),
                                SizedBox(width: 120, child: Text(doc.date, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted))),
                                SizedBox(width: 130, child: Text('By: ${doc.uploadedBy}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary))),
                                IconButton(
                                  icon: const Icon(Icons.download_outlined, color: AppColors.primary, size: 20),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Downloading ${doc.fileName}...')));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Slide-Over Drawer for "+ Upload Document"
          if (_isDrawerOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => _isDrawerOpen = false),
                child: Container(color: Colors.black.withValues(alpha: 0.3)),
              ),
            ),
          if (_isDrawerOpen)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: UploadDocumentSheet(
                onClose: () => setState(() => _isDrawerOpen = false),
                onDocumentUploaded: (newDoc) {
                  setState(() {
                    _documents.insert(0, newDoc);
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}
