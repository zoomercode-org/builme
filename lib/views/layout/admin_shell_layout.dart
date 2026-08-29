import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'top_header.dart';
import 'left_sidebar.dart';
import '../widgets/ai_assistant_drawer.dart';
import '../../providers/navigation_provider.dart';

class AdminShellLayout extends ConsumerWidget {
  final String currentPath;
  final Widget child;

  const AdminShellLayout({
    super.key,
    required this.currentPath,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAiOpen = ref.watch(isAiDrawerOpenProvider);

    return Scaffold(
      endDrawer: isAiOpen ? const AiAssistantDrawer() : null,
      onEndDrawerChanged: (isOpen) {
        if (!isOpen) {
          ref.read(isAiDrawerOpenProvider.notifier).state = false;
        }
      },
      body: Column(
        children: [
          const TopHeader(),
          Expanded(
            child: Row(
              children: [
                LeftSidebar(currentPath: currentPath),
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(child: child),
                      if (isAiOpen)
                        Positioned.fill(
                          child: GestureDetector(
                            onTap: () {
                              ref.read(isAiDrawerOpenProvider.notifier).state = false;
                            },
                            child: Container(
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ),
                        ),
                      if (isAiOpen)
                        const Positioned(
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: AiAssistantDrawer(),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
