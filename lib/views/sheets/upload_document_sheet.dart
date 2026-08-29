import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../models/document_item.dart';
import '../../providers/project_provider.dart';

class UploadDocumentSheet extends ConsumerStatefulWidget {
  final VoidCallback onClose;
  final ValueChanged<DocumentItem>? onDocumentUploaded;

  const UploadDocumentSheet({super.key, required this.onClose, this.onDocumentUploaded});

  @override
  ConsumerState<UploadDocumentSheet> createState() => _UploadDocumentSheetState();
}

class _UploadDocumentSheetState extends ConsumerState<UploadDocumentSheet> {
  final _formKey = GlobalKey<FormState>();
  final _filenameController = TextEditingController(text: 'Structural_Framing_Plan_v2.dwg');
  final _uploaderController = TextEditingController(text: 'Rahul Menon');
  String _category = 'Drawings';
  String _fileType = 'DWG';
  String _selectedProject = 'Green Valley Residence';

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(projectsProvider).projects;

    return Container(
      width: 520,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Sheet Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Upload Project Document',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Upload blueprints, DWG CAD drawings, contracts, and estimates.',
                        style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textSecondary),
                    onPressed: widget.onClose,
                  ),
                ],
              ),
            ),

            // Form Body
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    _buildTextField('Document Filename', _filenameController, hint: 'e.g. MasterPlan_v1.dwg'),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Category', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                initialValue: _category,
                                items: ['Drawings', 'Contracts', 'Bills', 'Reports', 'Safety', 'Other']
                                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                                    .toList(),
                                onChanged: (val) => setState(() => _category = val!),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('File Format', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                initialValue: _fileType,
                                items: ['DWG', 'PDF', 'XLSX', 'DOCX']
                                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                                    .toList(),
                                onChanged: (val) => setState(() => _fileType = val!),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Target Project', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          initialValue: projects.first.name,
                          items: projects.map((p) => DropdownMenuItem(value: p.name, child: Text(p.name))).toList(),
                          onChanged: (val) => setState(() => _selectedProject = val!),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    _buildTextField('Uploaded By', _uploaderController, hint: 'Manager or Architect name'),

                    const SizedBox(height: 24),

                    // File Upload Box
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.cloud_upload_outlined, color: AppColors.primary, size: 36),
                          const SizedBox(height: 8),
                          Text('Drag & drop CAD DWG, PDF, or XLSX file here', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                          Text('Max file size 50MB', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.folder_open, size: 16),
                            label: const Text('Browse Files'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer Actions
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.cardBorder)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: widget.onClose,
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final doc = DocumentItem(
                          id: 'doc-${DateTime.now().millisecondsSinceEpoch}',
                          fileName: _filenameController.text,
                          category: _category,
                          projectName: _selectedProject,
                          uploadedBy: _uploaderController.text,
                          date: 'Today',
                          fileSize: '12.4 MB',
                          fileType: _fileType,
                        );

                        if (widget.onDocumentUploaded != null) {
                          widget.onDocumentUploaded!(doc);
                        }

                        widget.onClose();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Document "${doc.fileName}" uploaded!')),
                        );
                      }
                    },
                    child: const Text('Upload Document'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(hintText: hint),
          validator: (val) => val == null || val.isEmpty ? 'Required field' : null,
        ),
      ],
    );
  }
}
