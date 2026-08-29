import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/mock/mock_data.dart';

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final docs = MockData.documents;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
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
                      Text('Documents Repository', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      Text('Central blueprint drawings, agreements, invoices, and site reports.', style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.upload_file_outlined, size: 18),
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
                itemCount: docs.length,
                separatorBuilder: (context, index) => const Divider(color: Color(0xFFF1F5F9), height: 1),
                itemBuilder: (context, index) {
                  final doc = docs[index];
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
                                doc.fileType == 'DWG' ? Icons.architecture : (doc.fileType == 'PDF' ? Icons.picture_as_pdf : Icons.description),
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 14),
                            SizedBox(
                              width: 250,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(doc.fileName, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700)),
                                  Text('${doc.projectName} • ${doc.category}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
                                ],
                              ),
                            ),
                            SizedBox(width: 140, child: Text('By: ${doc.uploadedBy}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary))),
                            SizedBox(width: 110, child: Text(doc.date, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted))),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                              child: Text('${doc.fileType} • ${doc.fileSize}', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600)),
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
    );
  }
}
