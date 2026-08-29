import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/status_badge.dart';
import '../widgets/custom_image.dart';
import '../widgets/charts/gantt_timeline_widget.dart';
import '../widgets/charts/schedule_performance_chart.dart';
import '../../providers/project_provider.dart';
import '../../models/project.dart';

class ProjectDetailsScreen extends ConsumerStatefulWidget {
  final String projectId;

  const ProjectDetailsScreen({super.key, required this.projectId});

  @override
  ConsumerState<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends ConsumerState<ProjectDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 10, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final project = ref.watch(selectedProjectProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Project Banner Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
              ),
              child: Column(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isNarrow = constraints.maxWidth < 700;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomImage(
                                imageUrl: project.imageUrl,
                                width: isNarrow ? 90 : 120,
                                height: isNarrow ? 70 : 90,
                                borderRadius: BorderRadius.circular(12),
                                placeholderLabel: project.name,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      spacing: 12,
                                      runSpacing: 6,
                                      children: [
                                        Text(
                                          project.name,
                                          style: GoogleFonts.inter(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        StatusBadge(status: project.status),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Client: ${project.client} • Location: ${project.location} • Manager: ${project.manager}',
                                      style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Timeline: ${project.startDate} to ${project.completionDate}',
                                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                                    ),
                                  ],
                                ),
                              ),
                              if (!isNarrow)
                                OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.edit_outlined, size: 16),
                                  label: const Text('Edit Project'),
                                ),
                            ],
                          ),
                          if (isNarrow) ...[
                            const SizedBox(height: 12),
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.edit_outlined, size: 16),
                              label: const Text('Edit Project'),
                            ),
                          ],
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Overview KPI Mini Grid with Horizontal Scroll / Responsive Layout
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildMetricTile('Progress', '${(project.progress * 100).toInt()}%', AppColors.primary),
                        _buildMetricTile('Total Budget', '₹${project.budgetCr} Cr', AppColors.textPrimary),
                        _buildMetricTile('Spent', '₹${project.spentCr} Cr', AppColors.warning),
                        _buildMetricTile('Remaining', '₹${(project.remainingCr * 100).toInt()} L', AppColors.success),
                        _buildMetricTile('Days Left', '126 Days', AppColors.textSecondary),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Tab Bar Navigation
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Project Plan'),
                  Tab(text: 'Daily Updates'),
                  Tab(text: 'Progress'),
                  Tab(text: 'Attendance'),
                  Tab(text: 'Materials'),
                  Tab(text: 'Expenses'),
                  Tab(text: 'Reports'),
                  Tab(text: 'Documents'),
                  Tab(text: 'Activity'),
                ],
              ),
            ),

            // Tab Views Container
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                height: 850,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOverviewTab(project),
                    _buildProjectPlanTab(project),
                    _buildDailyUpdatesTab(context, ref, project),
                    _buildProgressTab(project),
                    _buildAttendanceTab(),
                    _buildMaterialsTab(context),
                    _buildExpensesTab(context),
                    _buildReportsTab(context, project),
                    _buildDocumentsTab(project),
                    _buildActivityTab(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile(String title, String val, Color color) {
    return Container(
      width: 170,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
          const SizedBox(height: 4),
          Text(
            val,
            style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: color),
          ),
        ],
      ),
    );
  }

  // 1. Overview Tab
  Widget _buildOverviewTab(Project p) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;

        if (isWide) {
          return ListView(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: _buildDescriptionCard(p),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 5,
                    child: _buildSummaryCard(p),
                  ),
                ],
              ),
            ],
          );
        }

        return ListView(
          children: [
            _buildDescriptionCard(p),
            const SizedBox(height: 24),
            _buildSummaryCard(p),
          ],
        );
      },
    );
  }

  Widget _buildDescriptionCard(Project p) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Project Description', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Text(p.description, style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary, height: 1.5)),
          const SizedBox(height: 20),
          CustomImage(
            imageUrl: p.imageUrl,
            height: 260,
            width: double.infinity,
            borderRadius: BorderRadius.circular(12),
            placeholderLabel: p.name,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(Project p) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Project Summary & Team', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          _buildDetailRow('Client', p.client),
          _buildDetailRow('Project Code', p.code),
          _buildDetailRow('Type', p.projectType),
          _buildDetailRow('Project Manager', p.manager),
          _buildDetailRow('Site Address', p.location),
          _buildDetailRow('Start Date', p.startDate),
          _buildDetailRow('Expected End', p.completionDate),
        ],
      ),
    );
  }

  // 2. Project Plan Tab
  Widget _buildProjectPlanTab(Project p) {
    return ListView(
      children: [
        GanttTimelineWidget(milestones: p.milestones),
      ],
    );
  }

  // 3. Daily Updates Tab with Photo Gallery
  Widget _buildDailyUpdatesTab(BuildContext context, WidgetRef ref, Project p) {
    return ListView(
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 8,
          children: [
            Text('Daily Site Progress Logs', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
            ElevatedButton.icon(
              onPressed: () {
                _showAddDailyUpdateModal(context, ref, p.id);
              },
              icon: const Icon(Icons.add_a_photo_outlined, size: 16),
              label: const Text('+ Add Daily Update'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...p.dailyUpdates.map((update) {
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  runSpacing: 6,
                  children: [
                    Text('Daily Log — ${update.date}', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700)),
                    Text('Uploaded by: ${update.uploadedBy}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Work Completed: ${update.workCompleted}', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
                Text('Work Planned: ${update.workPlanned}', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
                Text('Workers Present: ${update.workersPresent} • Materials Received: ${update.materialsReceived}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
                const SizedBox(height: 16),
                Text('Site Photos:', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: update.siteImageUrls.map((url) {
                    return CustomImage(
                      imageUrl: url,
                      width: 120,
                      height: 80,
                      borderRadius: BorderRadius.circular(8),
                      placeholderLabel: 'Site Photo',
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // 4. Progress Tab
  Widget _buildProgressTab(Project p) {
    return ListView(
      children: const [
        SchedulePerformanceChart(),
      ],
    );
  }

  // 5. Attendance Tab
  Widget _buildAttendanceTab() {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Site Worker Attendance', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              _buildSimpleRow('Arun Kumar', 'Site Supervisor', '08:00 AM', '05:00 PM', 'Verified'),
              _buildSimpleRow('Rahul Menon', 'Project Manager', '08:15 AM', '05:30 PM', 'Verified'),
              _buildSimpleRow('Suresh P.', 'Mason Leader', '09:45 AM', '--', 'Pending'),
            ],
          ),
        ),
      ],
    );
  }

  // 6. Materials Tab
  Widget _buildMaterialsTab(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 8,
                children: [
                  Text('Site Inventory & Stock Levels', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
                  ElevatedButton(onPressed: () {}, child: const Text('+ Add Material')),
                ],
              ),
              const SizedBox(height: 16),
              _buildSimpleRow('Cement OPC 53', '600 Bags Received', '420 Used', '180 Remaining', 'Available'),
              _buildSimpleRow('Steel Rod 12mm', '12 Tons Received', '10 Used', '2 Tons Remaining', 'Low Stock'),
            ],
          ),
        ),
      ],
    );
  }

  // 7. Expenses Tab
  Widget _buildExpensesTab(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 8,
                children: [
                  Text('Project Expenses Log', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
                  ElevatedButton(onPressed: () {}, child: const Text('+ Add Expense')),
                ],
              ),
              const SizedBox(height: 16),
              _buildSimpleRow('27 May 2025', 'Steel Rod Batch 4', '₹4,85,000', 'Arun Kumar', 'Approved'),
              _buildSimpleRow('25 May 2025', 'Weekly Labor Wages', '₹1,92,000', 'Rahul Menon', 'Approved'),
            ],
          ),
        ),
      ],
    );
  }

  // 8. Reports Tab
  Widget _buildReportsTab(BuildContext context, Project p) {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 12,
                children: [
                  Text('Project Presentation Report', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700)),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Generating PDF Report...')));
                        },
                        icon: const Icon(Icons.picture_as_pdf, size: 16),
                        label: const Text('Export PDF'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report re-generated!')));
                        },
                        child: const Text('Generate Full Report'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text('Project Summary: ${p.name} is currently ${p.status} with ${(p.progress * 100).toInt()}% progress. Total budget utilization is ₹${p.spentCr}Cr of ₹${p.budgetCr}Cr.'),
            ],
          ),
        ),
      ],
    );
  }

  // 9. Documents Tab
  Widget _buildDocumentsTab(Project p) {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Project Blueprints & Contracts', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              _buildSimpleRow('Architectural_MasterPlan_v3.dwg', 'Drawings', '42.5 MB', '10 Jan 2025', 'Available'),
              _buildSimpleRow('Contractor_Agreement_Signed.pdf', 'Contracts', '4.8 MB', '12 Jan 2025', 'Available'),
            ],
          ),
        ),
      ],
    );
  }

  // 10. Activity Tab
  Widget _buildActivityTab() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: ListView(
        children: [
          Text('Audit Trail', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          Text('• 27 May 2025: Daily update uploaded by Arun Kumar.'),
          Text('• 25 May 2025: Expense ₹1,92,000 approved by Admin.'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted)),
          Text(val, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildSimpleRow(String c1, String c2, String c3, String c4, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 700),
          child: Row(
            children: [
              SizedBox(width: 220, child: Text(c1, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600))),
              SizedBox(width: 140, child: Text(c2, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted))),
              SizedBox(width: 130, child: Text(c3, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary))),
              SizedBox(width: 120, child: Text(c4, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted))),
              StatusBadge(status: status),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddDailyUpdateModal(BuildContext context, WidgetRef ref, String projectId) {
    final workController = TextEditingController(text: 'Concreting of 4th floor slab completed.');
    final workersController = TextEditingController(text: '45');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add Daily Site Update', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: workController,
                decoration: const InputDecoration(labelText: 'Work Completed Summary'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: workersController,
                decoration: const InputDecoration(labelText: 'Workers Present'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final update = DailySiteUpdate(
                id: 'up-${DateTime.now().millisecondsSinceEpoch}',
                date: 'Today',
                progressPercent: 74.0,
                workCompleted: workController.text,
                workPlanned: 'Internal plastering',
                workersPresent: int.tryParse(workersController.text) ?? 42,
                materialsReceived: '80 Bags Cement',
                issues: 'None',
                notes: 'On track',
                siteImageUrls: [
                  'https://images.unsplash.com/photo-1541888946425-d0fbb186a5b3?auto=format&fit=crop&w=600&q=80',
                ],
                uploadedBy: 'Admin',
              );
              ref.read(projectsProvider.notifier).addDailyUpdate(projectId, update);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Daily update added!')));
            },
            child: const Text('Submit Update'),
          ),
        ],
      ),
    );
  }
}
