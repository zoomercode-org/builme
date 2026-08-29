import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/status_badge.dart';
import '../widgets/kpi_card.dart';
import '../widgets/site_image.dart';
import '../sheets/add_material_sheet.dart';
import '../../providers/material_provider.dart';

class MaterialsScreen extends ConsumerStatefulWidget {
  const MaterialsScreen({super.key});

  @override
  ConsumerState<MaterialsScreen> createState() => _MaterialsScreenState();
}

class _MaterialsScreenState extends ConsumerState<MaterialsScreen> {
  bool _isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    final materials = ref.watch(materialProvider);

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
                          Text('Materials & Inventory', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                          const SizedBox(height: 4),
                          Text('Track stock levels, material consumption, and automated reorder alerts.', style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _isDrawerOpen = true),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('+ Add Material'),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Material Stock Yard Images (Width: 280px, Height: 160px)
                Text('Site Storage & Materials Yards', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(right: 14.0),
                        child: SiteImage(
                          width: 280,
                          height: 160,
                          title: 'Green Valley Cement Depot',
                          tag: '1250 Bags',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 14.0),
                        child: SiteImage(
                          width: 280,
                          height: 160,
                          title: 'City Mall Steel Storage',
                          tag: 'Low Stock Alert',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 14.0),
                        child: SiteImage(
                          width: 280,
                          height: 160,
                          title: 'Calicut Sand & Aggregate Pit',
                          tag: 'Reorder Soon',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Compact KPI Cards Grid (Width: 230px, Height: 120px)
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: const [
                    KpiCard(title: 'Total Materials', value: '56', trend: 'Cataloged'),
                    KpiCard(title: 'Low Stock Alert', value: '03', trend: 'Requires order', isPositive: false),
                    KpiCard(title: 'Received Today', value: '1,250', trend: 'Bags & Tons'),
                    KpiCard(title: 'Pending Orders', value: '870', trend: 'In transit'),
                  ],
                ),

                const SizedBox(height: 24),

                // Low Stock Reorder Alert Banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.warningLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Reorder Warning: 3 items below minimum threshold', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                            Text('Steel Rod 12mm (2 Tons left), M-Sand (160 Tons left), PVC 4-inch Pipes (15 Nos left)', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning),
                        onPressed: () {},
                        child: const Text('Quick Reorder All'),
                      ),
                    ],
                  ),
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
                    itemCount: materials.length,
                    separatorBuilder: (context, index) => const Divider(color: Color(0xFFF1F5F9), height: 1),
                    itemBuilder: (context, index) {
                      final mat = materials[index];
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
                                  decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
                                  child: const Icon(Icons.inventory_2_outlined, color: AppColors.primary, size: 20),
                                ),
                                const SizedBox(width: 14),
                                SizedBox(
                                  width: 180,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(mat.name, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700)),
                                      Text(mat.projectName, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 130, child: Text('Total: ${mat.totalQuantity} ${mat.unit}', style: GoogleFonts.inter(fontSize: 13))),
                                SizedBox(width: 130, child: Text('Used: ${mat.used} ${mat.unit}', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted))),
                                SizedBox(width: 140, child: Text('Remaining: ${mat.remaining} ${mat.unit}', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
                                StatusBadge(status: mat.status),
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

          // Slide-Over Drawer for "+ Add Material"
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
              child: AddMaterialSheet(
                onClose: () => setState(() => _isDrawerOpen = false),
              ),
            ),
        ],
      ),
    );
  }
}
