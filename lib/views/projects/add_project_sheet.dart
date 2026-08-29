import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../models/project.dart';
import '../../providers/project_provider.dart';

class AddProjectSheet extends ConsumerStatefulWidget {
  final VoidCallback onClose;

  const AddProjectSheet({super.key, required this.onClose});

  @override
  ConsumerState<AddProjectSheet> createState() => _AddProjectSheetState();
}

class _AddProjectSheetState extends ConsumerState<AddProjectSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Highland Luxury Towers');
  final _codeController = TextEditingController(text: 'HLT-2025');
  final _clientController = TextEditingController(text: 'Prestige Realty');
  final _locationController = TextEditingController(text: 'Kochi, Kerala');
  final _budgetController = TextEditingController(text: '2.5');
  final _managerController = TextEditingController(text: 'Rahul Menon');
  final _startDateController = TextEditingController(text: '01 Sep 2025');
  final _completionDateController = TextEditingController(text: '30 Dec 2026');
  String _projectType = 'Residential';

  @override
  Widget build(BuildContext context) {
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
                        'Create New Project',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Fill in construction details to initiate project tracking.',
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
                    _buildSectionHeader('Project Information'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField('Project Name', _nameController, hint: 'e.g. Green Valley'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField('Project Code', _codeController, hint: 'Auto-generated'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField('Client Name', _clientController, hint: 'e.g. ABC Corp'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Project Type',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                initialValue: _projectType,
                                items: ['Residential', 'Commercial', 'Infrastructure', 'Industrial']
                                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                                    .toList(),
                                onChanged: (val) => setState(() => _projectType = val!),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    _buildSectionHeader('Location'),
                    const SizedBox(height: 12),
                    _buildTextField('Site Address / Location', _locationController, hint: 'City, State'),

                    const SizedBox(height: 24),
                    _buildSectionHeader('Project Timeline & Financials'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildTextField('Start Date', _startDateController)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTextField('Expected Completion', _completionDateController)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildTextField('Total Budget (₹ Cr)', _budgetController)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTextField('Project Manager', _managerController)),
                      ],
                    ),

                    const SizedBox(height: 24),
                    _buildSectionHeader('Project Thumbnail Image'),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.cardBorder, style: BorderStyle.solid),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.cloud_upload_outlined, size: 36, color: AppColors.primary),
                          const SizedBox(height: 8),
                          Text(
                            'Drag & drop project photo or browse files',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'PNG, JPG up to 10MB',
                            style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer Buttons
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
                        final newProj = Project(
                          id: 'proj-${DateTime.now().millisecondsSinceEpoch}',
                          name: _nameController.text,
                          code: _codeController.text,
                          client: _clientController.text,
                          location: _locationController.text,
                          manager: _managerController.text,
                          imageUrl: 'https://images.unsplash.com/photo-1541888946425-d0fbb186a5b3?auto=format&fit=crop&w=800&q=80',
                          progress: 0.10,
                          budgetCr: double.tryParse(_budgetController.text) ?? 2.0,
                          spentCr: 0.2,
                          startDate: _startDateController.text,
                          completionDate: _completionDateController.text,
                          status: 'On Track',
                          projectType: _projectType,
                          description: 'Newly added construction project.',
                          milestones: [
                            ProjectMilestone(
                              id: 'm-new-1',
                              title: 'Site Preparation & Excavation',
                              progress: 0.3,
                              plannedStart: _startDateController.text,
                              plannedEnd: '30 Oct 2025',
                              status: 'In Progress',
                              assignee: _managerController.text,
                            ),
                          ],
                          dailyUpdates: [],
                        );

                        ref.read(projectsProvider.notifier).addProject(newProj);
                        widget.onClose();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Project "${newProj.name}" created successfully!')),
                        );
                      }
                    },
                    child: const Text('Create Project'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
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
