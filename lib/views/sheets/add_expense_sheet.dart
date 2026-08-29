import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../models/expense.dart';
import '../../providers/expense_provider.dart';
import '../../providers/project_provider.dart';

class AddExpenseSheet extends ConsumerStatefulWidget {
  final VoidCallback onClose;

  const AddExpenseSheet({super.key, required this.onClose});

  @override
  ConsumerState<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends ConsumerState<AddExpenseSheet> {
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController(text: 'Ready-Mix Concrete Batch #14');
  final _amountController = TextEditingController(text: '185000');
  final _submitterController = TextEditingController(text: 'Arun Kumar');
  String _category = 'Materials';
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
                        'Add Site Expense Claim',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Log expense claims, receipts, and project cost allocations.',
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
                    _buildTextField('Expense Description', _descController, hint: 'e.g. Steel Rod Batch #4'),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(child: _buildTextField('Amount (₹)', _amountController, hint: 'e.g. 185000')),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Category', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                initialValue: _category,
                                items: ['Materials', 'Labor', 'Equipment', 'Transport', 'Permits', 'Utility']
                                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                                    .toList(),
                                onChanged: (val) => setState(() => _category = val!),
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
                        Text('Project Allocation', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          initialValue: projects.first.name,
                          items: projects.map((p) => DropdownMenuItem(value: p.name, child: Text(p.name))).toList(),
                          onChanged: (val) => setState(() => _selectedProject = val!),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    _buildTextField('Submitted By', _submitterController, hint: 'Supervisor or Engineer name'),

                    const SizedBox(height: 24),

                    // Receipt Upload Box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.receipt_long_outlined, color: AppColors.primary, size: 28),
                          const SizedBox(height: 8),
                          Text('Attach Invoice / Receipt Bill', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                          Text('PDF or Image up to 10MB', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
                          const SizedBox(height: 10),
                          OutlinedButton(onPressed: () {}, child: const Text('Upload Receipt')),
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
                        final exp = Expense(
                          id: 'exp-${DateTime.now().millisecondsSinceEpoch}',
                          date: 'Today',
                          description: _descController.text,
                          projectName: _selectedProject,
                          category: _category,
                          amount: double.tryParse(_amountController.text) ?? 185000.0,
                          submittedBy: _submitterController.text,
                          status: 'Approved',
                        );

                        ref.read(expenseProvider.notifier).addExpense(exp);
                        widget.onClose();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Expense claim of ₹${exp.amount.toInt()} logged!')),
                        );
                      }
                    },
                    child: const Text('Log Expense'),
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
