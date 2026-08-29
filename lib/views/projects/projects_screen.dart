import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/status_badge.dart';
import '../widgets/custom_image.dart';
import '../../providers/project_provider.dart';
import 'add_project_sheet.dart';

class ProjectsScreen extends ConsumerStatefulWidget {
  const ProjectsScreen({super.key});

  @override
  ConsumerState<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends ConsumerState<ProjectsScreen> {
  bool _isAddDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    final projectsState = ref.watch(projectsProvider);
    final projectsNotifier = ref.read(projectsProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Projects',
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Manage active site operations, timelines, and budgets across all locations.',
                            style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _isAddDrawerOpen = true;
                        });
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('+ New Project'),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Controls Bar: Search & Filter Tabs
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.cardBorder),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isNarrow = constraints.maxWidth < 750;

                      if (isNarrow) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              onChanged: (val) => projectsNotifier.setSearchQuery(val),
                              decoration: InputDecoration(
                                hintText: 'Search project name, client...',
                                prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.textMuted),
                                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: _buildFilterChips(projectsState, projectsNotifier),
                              ),
                            ),
                          ],
                        );
                      }

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 320,
                            height: 40,
                            child: TextField(
                              onChanged: (val) => projectsNotifier.setSearchQuery(val),
                              decoration: InputDecoration(
                                hintText: 'Search project name, client, location...',
                                prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.textMuted),
                                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: _buildFilterChips(projectsState, projectsNotifier),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Projects List / Table Card
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.cardBorder),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: projectsState.filteredProjects.length,
                    separatorBuilder: (context, index) => const Divider(color: Color(0xFFF1F5F9), height: 1),
                    itemBuilder: (context, index) {
                      final project = projectsState.filteredProjects[index];
                      return InkWell(
                        onTap: () {
                          ref.read(selectedProjectIdProvider.notifier).state = project.id;
                          context.go('/projects/${project.id}');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(minWidth: 800),
                              child: Row(
                                children: [
                                  // Project Thumbnail
                                  CustomImage(
                                    imageUrl: project.imageUrl,
                                    width: 80,
                                    height: 60,
                                    borderRadius: BorderRadius.circular(10),
                                    placeholderLabel: project.name,
                                  ),
                                  const SizedBox(width: 16),

                                  // Name & Client
                                  SizedBox(
                                    width: 240,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          project.name,
                                          style: GoogleFonts.inter(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Client: ${project.client} • Manager: ${project.manager}',
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                                        ),
                                        Text(
                                          'Location: ${project.location}',
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 16),

                                  // Progress Column
                                  SizedBox(
                                    width: 160,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Progress',
                                              style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                                            ),
                                            Text(
                                              '${(project.progress * 100).toInt()}%',
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        LinearProgressIndicator(
                                          value: project.progress,
                                          backgroundColor: const Color(0xFFF1F5F9),
                                          color: project.status == 'Delayed'
                                              ? AppColors.danger
                                              : (project.status == 'At Risk' ? AppColors.warning : AppColors.success),
                                          minHeight: 6,
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 24),

                                  // Budget & Spent
                                  SizedBox(
                                    width: 160,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Budget / Spent',
                                          style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '₹${project.spentCr} Cr / ₹${project.budgetCr} Cr',
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 16),

                                  // Status Badge
                                  StatusBadge(status: project.status),

                                  const SizedBox(width: 16),

                                  const Icon(Icons.chevron_right, color: AppColors.textMuted),
                                ],
                              ),
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

          // Slide-Over Drawer for "+ New Project"
          if (_isAddDrawerOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => _isAddDrawerOpen = false),
                child: Container(color: Colors.black.withValues(alpha: 0.3)),
              ),
            ),
          if (_isAddDrawerOpen)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: AddProjectSheet(
                onClose: () => setState(() => _isAddDrawerOpen = false),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildFilterChips(dynamic projectsState, dynamic projectsNotifier) {
    return ['All', 'Active', 'Completed', 'Delayed'].map((filter) {
      final isSelected = projectsState.statusFilter == filter;
      return Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: ChoiceChip(
          label: Text(filter),
          selected: isSelected,
          selectedColor: AppColors.primary,
          labelStyle: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
          backgroundColor: Colors.white,
          onSelected: (_) => projectsNotifier.setFilter(filter),
        ),
      );
    }).toList();
  }
}
