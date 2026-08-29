import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/auth_provider.dart';

class TopHeader extends ConsumerWidget {
  const TopHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.headerBackground,
        border: Border(
          bottom: BorderSide(color: AppColors.headerBorder, width: 1),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 900;
          final isNarrow = constraints.maxWidth < 650;

          return Row(
            children: [
              // Logo Section
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.architecture_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  if (!isNarrow) ...[
                    const SizedBox(width: 12),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Buil',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                text: 'Me',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'by ZoomerCode',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: AppColors.headerTextMuted,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),

              const SizedBox(width: 16),

              // Global Search Bar
              Expanded(
                child: Container(
                  height: 38,
                  constraints: const BoxConstraints(maxWidth: 380),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F2937),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF374151)),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      const Icon(Icons.search, size: 18, color: AppColors.headerTextMuted),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
                          onChanged: (val) {
                            ref.read(globalSearchQueryProvider.notifier).state = val;
                          },
                          decoration: InputDecoration(
                            hintText: isCompact ? 'Search...' : 'Search projects, workers... (Ctrl+K)',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.headerTextMuted,
                            ),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      if (!isCompact)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF374151),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '⌘K',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.headerTextMuted,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // ✨ AI Assistant Pill Button
              InkWell(
                onTap: () {
                  ref.read(isAiDrawerOpenProvider.notifier).state = true;
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isNarrow ? 10 : 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
                      if (!isNarrow) ...[
                        const SizedBox(width: 8),
                        Text(
                          'AI Assistant',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Calendar Icon Button
              if (!isNarrow)
                IconButton(
                  icon: const Icon(Icons.calendar_today_outlined, color: AppColors.headerTextMuted, size: 18),
                  onPressed: () {},
                  tooltip: 'Calendar Schedule',
                ),

              // Notifications Icon with Badge
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_none_outlined, color: AppColors.headerTextMuted, size: 20),
                    onPressed: () {},
                    tooltip: 'Notifications',
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.danger,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 8),
              Container(width: 1, height: 24, color: const Color(0xFF374151)),
              const SizedBox(width: 8),

              // User Profile Dropdown
              PopupMenuButton<String>(
                offset: const Offset(0, 48),
                color: AppColors.cardBackground,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                onSelected: (value) {
                  if (value == 'logout') {
                    ref.read(authProvider.notifier).logout();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'profile',
                    child: Row(
                      children: [
                        const Icon(Icons.person_outline, size: 18, color: AppColors.textSecondary),
                        const SizedBox(width: 10),
                        Text('Admin Profile', style: GoogleFonts.inter(fontSize: 13)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'settings',
                    child: Row(
                      children: [
                        const Icon(Icons.settings_outlined, size: 18, color: AppColors.textSecondary),
                        const SizedBox(width: 10),
                        Text('System Settings', style: GoogleFonts.inter(fontSize: 13)),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        const Icon(Icons.logout, size: 18, color: AppColors.danger),
                        const SizedBox(width: 10),
                        Text('Sign Out', style: GoogleFonts.inter(fontSize: 13, color: AppColors.danger)),
                      ],
                    ),
                  ),
                ],
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(auth.avatarUrl),
                    ),
                    if (!isNarrow) ...[
                      const SizedBox(width: 8),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            auth.userName,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            auth.userRole,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.headerTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_down, color: AppColors.headerTextMuted, size: 18),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
