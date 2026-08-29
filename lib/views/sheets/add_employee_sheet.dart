import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../models/employee.dart';
import '../../providers/employee_provider.dart';
import '../../providers/project_provider.dart';

class AddEmployeeSheet extends ConsumerStatefulWidget {
  final VoidCallback onClose;

  const AddEmployeeSheet({super.key, required this.onClose});

  @override
  ConsumerState<AddEmployeeSheet> createState() => _AddEmployeeSheetState();
}

class _AddEmployeeSheetState extends ConsumerState<AddEmployeeSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Vikram Singh');
  final _phoneController = TextEditingController(text: '+91 98765 88990');
  final _skillsController = TextEditingController(text: 'Civil Engineering, Structural Audit');
  String _role = 'Engineer';
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
                        'Add New Employee',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Assign staff role, site project, and contact credentials.',
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
                    _buildTextField('Full Name', _nameController, hint: 'e.g. Vikram Singh'),
                    const SizedBox(height: 16),
                    _buildTextField('Phone Number', _phoneController, hint: '+91 98765 XXXXX'),
                    const SizedBox(height: 16),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Employee Role', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          initialValue: _role,
                          items: ['Project Manager', 'Site Supervisor', 'Engineer', 'Mason Leader', 'Safety Specialist']
                              .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                              .toList(),
                          onChanged: (val) => setState(() => _role = val!),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Assigned Project', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          initialValue: projects.first.name,
                          items: projects.map((p) => DropdownMenuItem(value: p.name, child: Text(p.name))).toList(),
                          onChanged: (val) => setState(() => _selectedProject = val!),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    _buildTextField('Specialized Skills', _skillsController, hint: 'Comma separated skills'),

                    const SizedBox(height: 24),

                    // Avatar Image Simulator
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.primary,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Profile Photo Upload', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                                Text('JPG or PNG up to 5MB', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
                              ],
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () {},
                            child: const Text('Browse'),
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
                        final emp = Employee(
                          id: 'emp-${DateTime.now().millisecondsSinceEpoch}',
                          name: _nameController.text,
                          role: _role,
                          projectName: _selectedProject,
                          phone: _phoneController.text,
                          avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=200&q=80',
                          status: 'Active',
                          attendanceToday: 'Present',
                          checkInTime: '08:30 AM',
                          checkOutTime: '--',
                          isVerified: true,
                          skills: _skillsController.text.split(','),
                        );

                        ref.read(employeeProvider.notifier).addEmployee(emp);
                        widget.onClose();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Employee "${emp.name}" added successfully!')),
                        );
                      }
                    },
                    child: const Text('Add Employee'),
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
