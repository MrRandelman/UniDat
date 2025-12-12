import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dashboard_provider.dart';
import 'debug_grid_painter.dart';

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  static const double cellSize = 120;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // Debug Grid
            if (showDebugGrid)
              CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: DebugGridPainter(cellSize: cellSize),
              ),

            // Module
            for (final module in dashboard.modules)
              Positioned(
                left: module.position.x * cellSize,
                top: module.position.y * cellSize,
                width: module.position.w * cellSize,
                height: module.position.h * cellSize,
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
