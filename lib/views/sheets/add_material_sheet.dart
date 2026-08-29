import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../models/material_item.dart';
import '../../providers/material_provider.dart';
import '../../providers/project_provider.dart';

class AddMaterialSheet extends ConsumerStatefulWidget {
  final VoidCallback onClose;

  const AddMaterialSheet({super.key, required this.onClose});

  @override
  ConsumerState<AddMaterialSheet> createState() => _AddMaterialSheetState();
}

class _AddMaterialSheetState extends ConsumerState<AddMaterialSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'PVC 4-inch Drainage Pipe');
  final _quantityController = TextEditingController(text: '500');
  final _receivedController = TextEditingController(text: '300');
  final _thresholdController = TextEditingController(text: '50');
  String _unit = 'Nos';
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
                        'Add New Material',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Catalog material inventory, target project, and reorder limits.',
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
                    _buildTextField('Material Name', _nameController, hint: 'e.g. Cement OPC 53'),
                    const SizedBox(height: 16),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Target Site Project', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          initialValue: projects.first.name,
                          items: projects.map((p) => DropdownMenuItem(value: p.name, child: Text(p.name))).toList(),
                          onChanged: (val) => setState(() => _selectedProject = val!),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildTextField('Total Quantity', _quantityController, hint: '500')),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Unit', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                initialValue: _unit,
                                items: ['Bags', 'Tons', 'Nos', 'Cu.ft', 'Meters']
                                    .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                                    .toList(),
                                onChanged: (val) => setState(() => _unit = val!),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildTextField('Received Today', _receivedController, hint: '300')),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTextField('Reorder Threshold', _thresholdController, hint: '50')),
                      ],
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
                        final mat = MaterialItem(
                          id: 'mat-${DateTime.now().millisecondsSinceEpoch}',
                          name: _nameController.text,
                          projectName: _selectedProject,
                          totalQuantity: int.tryParse(_quantityController.text) ?? 500,
                          received: int.tryParse(_receivedController.text) ?? 300,
                          used: 50,
                          unit: _unit,
                          status: 'Available',
                          lowStockThreshold: int.tryParse(_thresholdController.text) ?? 50,
                        );

                        ref.read(materialProvider.notifier).addMaterial(mat);
                        widget.onClose();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Material "${mat.name}" added successfully!')),
                        );
                      }
                    },
                    child: const Text('Add Material'),
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
