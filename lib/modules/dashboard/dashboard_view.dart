import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dashboard_provider.dart';

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // Hintergrund (optional Grid später)
            Container(color: Colors.grey.shade100),

            // Module
            for (final module in dashboard.modules)
              Positioned(
                left: module.position.x * 120,
                top: module.position.y * 120,
                width: module.position.w * 120,
                height: module.position.h * 120,
                child: _ModuleCard(module.id),
              ),
          ],
        );
      },
    );
  }
}

class _ModuleCard extends StatelessWidget {
  final String title;

  const _ModuleCard(this.title);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
      child: Center(
        child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
