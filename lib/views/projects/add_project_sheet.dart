import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../models/project.dart';
import '../../providers/project_provider.dart';
import '../widgets/site_image.dart';

class AddProjectSheet extends ConsumerStatefulWidget {
  final VoidCallback onClose;

  const AddProjectSheet({super.key, required this.onClose});

  @override
  ConsumerState<AddProjectSheet> createState() => _AddProjectSheetState();
}

class _AddProjectSheetState extends ConsumerState<AddProjectSheet> {
  final _formKey = GlobalKey<FormState>();

  // Project Info
  final _nameController = TextEditingController(text: 'Highland Luxury Towers');
  final _codeController = TextEditingController(text: 'HLT-2025');
  final _clientController = TextEditingController(text: 'Prestige Realty');
  final _clientContactController = TextEditingController(text: '+91 98765 12345');
  String _projectType = 'Residential';

  // Location
  final _addressController = TextEditingController(text: 'Subhash Chandra Bose Road');
  final _cityController = TextEditingController(text: 'Kochi');
  final _stateController = TextEditingController(text: 'Kerala');

  // Timeline & Financials
  final _startDateController = TextEditingController(text: '01 Sep 2025');
  final _completionDateController = TextEditingController(text: '30 Dec 2026');
  final _budgetController = TextEditingController(text: '2.5');

  // Team
  final _managerController = TextEditingController(text: 'Rahul Menon');
  final _supervisorController = TextEditingController(text: 'Arun Kumar');
  final _engineerController = TextEditingController(text: 'Sameer Khan');

  // Project Plan & Milestones
  final _m1Controller = TextEditingController(text: 'Foundation & Earthworks');
  final _m2Controller = TextEditingController(text: 'Superstructure Concrete Frame');
  final _m3Controller = TextEditingController(text: 'Electrical & MEP Fitting');

  // Image Upload Simulation State
  String _mainImageUrl = 'https://images.unsplash.com/photo-1541888946425-d0fbb186a5b3?auto=format&fit=crop&w=800&q=80';
  final List<String> _uploadedSitePhotos = [
    'https://images.unsplash.com/photo-1503387762-592deb58ef4e?auto=format&fit=crop&w=600&q=80',
    'https://images.unsplash.com/photo-1581094794329-c8112a89af12?auto=format&fit=crop&w=600&q=80',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 560,
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
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
                        'Define project scope, timeline, plan milestones, and site photos.',
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

            // Form Content Body
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    // SECTION 1: PROJECT INFORMATION
                    _buildSectionHeader(Icons.info_outline, '1. Project Information'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildTextField('Project Name', _nameController, hint: 'e.g. Green Valley Residence')),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTextField('Project Code', _codeController, hint: 'e.g. GVR-2025')),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(child: _buildTextField('Client Name', _clientController, hint: 'e.g. ABC Developers')),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTextField('Client Contact', _clientContactController, hint: '+91 Phone')),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Project Type', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          children: ['Residential', 'Commercial', 'Infrastructure', 'Industrial'].map((type) {
                            final isSel = _projectType == type;
                            return ChoiceChip(
                              label: Text(type),
                              selected: isSel,
                              selectedColor: AppColors.primary,
                              labelStyle: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSel ? Colors.white : AppColors.textSecondary,
                              ),
                              backgroundColor: Colors.white,
                              onSelected: (_) => setState(() => _projectType = type),
                            );
                          }).toList(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    const Divider(color: AppColors.cardBorder),
                    const SizedBox(height: 12),

                    // SECTION 2: LOCATION
                    _buildSectionHeader(Icons.location_on_outlined, '2. Site Location'),
                    const SizedBox(height: 12),
                    _buildTextField('Site Address', _addressController, hint: 'Street address'),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(child: _buildTextField('City', _cityController, hint: 'Kochi / Calicut')),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTextField('State', _stateController, hint: 'Kerala')),
                      ],
                    ),

                    const SizedBox(height: 24),
                    const Divider(color: AppColors.cardBorder),
                    const SizedBox(height: 12),

                    // SECTION 3: TIMELINE & FINANCIALS
                    _buildSectionHeader(Icons.calendar_today_outlined, '3. Timeline & Financials'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildTextField('Start Date', _startDateController, hint: '01 Sep 2025')),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTextField('Expected Completion', _completionDateController, hint: '30 Dec 2026')),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _buildTextField('Total Budget (₹ Cr)', _budgetController, hint: 'e.g. 2.5'),

                    const SizedBox(height: 24),
                    const Divider(color: AppColors.cardBorder),
                    const SizedBox(height: 12),

                    // SECTION 4: TEAM ASSIGNMENT
                    _buildSectionHeader(Icons.people_outline, '4. Team Assignment'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildTextField('Project Manager', _managerController)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTextField('Site Supervisor', _supervisorController)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _buildTextField('Lead Engineer', _engineerController),

                    const SizedBox(height: 24),
                    const Divider(color: AppColors.cardBorder),
                    const SizedBox(height: 12),

                    // SECTION 5: PROJECT PLAN & MILESTONES (USER REQUESTED!)
                    _buildSectionHeader(Icons.assignment_outlined, '5. Project Plan & Milestones'),
                    const SizedBox(height: 8),
                    Text(
                      'Define initial construction phase milestones for Gantt timeline tracking.',
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 12),
                    _buildTextField('Milestone 1 (Phase 1)', _m1Controller, hint: 'e.g. Foundation & Substructure'),
                    const SizedBox(height: 10),
                    _buildTextField('Milestone 2 (Phase 2)', _m2Controller, hint: 'e.g. Superstructure Framing'),
                    const SizedBox(height: 10),
                    _buildTextField('Milestone 3 (Phase 3)', _m3Controller, hint: 'e.g. Electrical & Plumbing Fitting'),

                    const SizedBox(height: 24),
                    const Divider(color: AppColors.cardBorder),
                    const SizedBox(height: 12),

                    // SECTION 6: PROJECT IMAGE & SITE PHOTOS UPLOAD (USER REQUESTED!)
                    _buildSectionHeader(Icons.cloud_upload_outlined, '6. Project Images & Site Photos Upload'),
                    const SizedBox(height: 8),
                    Text(
                      'Upload primary banner image and initial site photos (Size: Width 280px, Height 160px).',
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 14),

                    Text('Main Project Banner Image (Width: 280px, Height: 160px)', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        SiteImage(
                          imageUrl: _mainImageUrl,
                          width: 280,
                          height: 160,
                          title: _nameController.text,
                          tag: 'Main Banner',
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _mainImageUrl = 'https://images.unsplash.com/photo-1503387762-592deb58ef4e?auto=format&fit=crop&w=800&q=80';
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Banner image updated!')),
                                  );
                                },
                                icon: const Icon(Icons.photo_library_outlined, size: 16),
                                label: const Text('Change Image'),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Supports PNG, JPG, WEBP. Max size 10MB.',
                                style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    Text('Upload Initial Site Progress Photos', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add_a_photo_outlined, color: AppColors.primary, size: 24),
                              const SizedBox(width: 10),
                              Text(
                                'Drag & drop site photos or click to browse',
                                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              ..._uploadedSitePhotos.map((photoUrl) {
                                return Stack(
                                  children: [
                                    SiteImage(
                                      imageUrl: photoUrl,
                                      width: 120,
                                      height: 80,
                                      title: 'Site Photo',
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            _uploadedSitePhotos.remove(photoUrl);
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: const BoxDecoration(
                                            color: Colors.black54,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.close, color: Colors.white, size: 14),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _uploadedSitePhotos.add(
                                      'https://images.unsplash.com/photo-1589939705384-5185137a7f0f?auto=format&fit=crop&w=600&q=80',
                                    );
                                  });
                                },
                                child: Container(
                                  width: 120,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: AppColors.cardBorder, style: BorderStyle.solid),
                                  ),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add, color: AppColors.primary),
                                      SizedBox(height: 2),
                                      Text('+ Add Photo', style: TextStyle(fontSize: 11, color: AppColors.primary)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Sheet Footer Actions
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                          location: '${_cityController.text}, ${_stateController.text}',
                          manager: _managerController.text,
                          imageUrl: _mainImageUrl,
                          progress: 0.15,
                          budgetCr: double.tryParse(_budgetController.text) ?? 2.5,
                          spentCr: 0.25,
                          startDate: _startDateController.text,
                          completionDate: _completionDateController.text,
                          status: 'On Track',
                          projectType: _projectType,
                          description: '${_nameController.text} located at ${_addressController.text}, ${_cityController.text}. Client: ${_clientController.text} (${_clientContactController.text}).',
                          milestones: [
                            ProjectMilestone(
                              id: 'm1',
                              title: _m1Controller.text,
                              progress: 0.4,
                              plannedStart: _startDateController.text,
                              plannedEnd: '30 Oct 2025',
                              status: 'In Progress',
                              assignee: _managerController.text,
                            ),
                            ProjectMilestone(
                              id: 'm2',
                              title: _m2Controller.text,
                              progress: 0.0,
                              plannedStart: '01 Nov 2025',
                              plannedEnd: '15 Mar 2026',
                              status: 'Not Started',
                              assignee: _supervisorController.text,
                            ),
                            ProjectMilestone(
                              id: 'm3',
                              title: _m3Controller.text,
                              progress: 0.0,
                              plannedStart: '16 Mar 2026',
                              plannedEnd: _completionDateController.text,
                              status: 'Not Started',
                              assignee: _engineerController.text,
                            ),
                          ],
                          dailyUpdates: [
                            DailySiteUpdate(
                              id: 'up-init',
                              date: 'Today',
                              progressPercent: 15.0,
                              workCompleted: 'Project initiated and site office set up.',
                              workPlanned: 'Earthwork excavation',
                              workersPresent: 18,
                              materialsReceived: 'Initial cement batch received',
                              issues: 'None',
                              notes: 'Site setup completed.',
                              siteImageUrls: _uploadedSitePhotos,
                              uploadedBy: _supervisorController.text,
                            ),
                          ],
                        );

                        ref.read(projectsProvider.notifier).addProject(newProj);
                        widget.onClose();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Project "${newProj.name}" created with custom plan & site photos!')),
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

  Widget _buildSectionHeader(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
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
