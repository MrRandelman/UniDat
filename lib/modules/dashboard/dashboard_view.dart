import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dashboard_provider.dart';
import 'debug_grid_painter.dart';
import 'models/dashboard_module.dart';
import 'collision.dart';

const bool showDebugGrid = true;

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  static const double cellSize = 120;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardProvider);

    final maxX = (constraints.maxWidth / cellSize).floor();
    final maxY = (constraints.maxHeight / cellSize).floor();

    ref
        .read(dashboardProvider.notifier)
        .updateGridBounds(maxX: maxX, maxY: maxY);

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

            // Modules
            for (final module in dashboard.modules)
              Positioned(
                left: module.position.x * cellSize,
                top: module.position.y * cellSize,
                width: module.position.w * cellSize,
                height: module.position.h * cellSize,
                child: _DraggableModule(module: module, cellSize: cellSize),
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
      elevation: 6,
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
      child: Center(
        child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _DraggableModule extends ConsumerStatefulWidget {
  final DashboardModule module;
  final double cellSize;

  const _DraggableModule({required this.module, required this.cellSize});

  @override
  ConsumerState<_DraggableModule> createState() => _DraggableModuleState();
}

class _DraggableModuleState extends ConsumerState<_DraggableModule> {
  late Offset startDragOffset;
  late int startX;
  late int startY;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (_) {
        startDragOffset = Offset.zero;
        startX = widget.module.position.x;
        startY = widget.module.position.y;
      },
      onPanUpdate: (details) {
        startDragOffset += details.delta;

        final dx = startDragOffset.dx / widget.cellSize;
        final dy = startDragOffset.dy / widget.cellSize;

        ref
            .read(dashboardProvider.notifier)
            .moveModuleIfFree(
              widget.module.copyWith(
                position: widget.module.position.copyWith(
                  x: startX + dx.floor(),
                  y: startY + dy.floor(),
                ),
              ),
            );
      },
      onPanEnd: (_) {
        final pos = widget.module.position;

        ref
            .read(dashboardProvider.notifier)
            .moveModuleIfFree(
              widget.module.copyWith(
                position: pos.copyWith(x: pos.x.round(), y: pos.y.round()),
              ),
            );
      },
      child: _ModuleCard(widget.module.id),
    );
  }
}
