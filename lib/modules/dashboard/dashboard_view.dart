import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dashboard_provider.dart';
import 'debug_grid_painter.dart';
import 'models/dashboard_module.dart';

const bool showDebugGrid = true;

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  static const double cellSize = 120;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxX = (constraints.maxWidth / cellSize).floor();
        final maxY = (constraints.maxHeight / cellSize).floor();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref
              .read(dashboardProvider.notifier)
              .updateGridBounds(maxX: maxX, maxY: maxY);
        });

        return Stack(
          children: [
            if (showDebugGrid)
              CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: DebugGridPainter(cellSize: cellSize),
              ),

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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
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
  late Offset dragOffset;
  late Offset resizeOffset;
  late int startX;
  late int startY;
  late int startW;
  late int startH;
  bool isDragging = false;
  bool isResizing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (_) {
        setState(() {
          isDragging = true;
        });

        dragOffset = Offset.zero;
        startX = widget.module.position.x;
        startY = widget.module.position.y;
      },
      onPanUpdate: (details) {
        dragOffset += details.delta;

        final dx = dragOffset.dx / widget.cellSize;
        final dy = dragOffset.dy / widget.cellSize;

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
        setState(() {
          isDragging = false;
        });

        final pos = widget.module.position;

        ref
            .read(dashboardProvider.notifier)
            .moveModuleIfFree(
              widget.module.copyWith(
                position: pos.copyWith(x: pos.x.round(), y: pos.y.round()),
              ),
            );
      },
      child: AnimatedScale(
        scale: (isDragging || isResizing) ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: AnimatedPhysicalModel(
          duration: const Duration(milliseconds: 120),
          elevation: (isDragging || isResizing) ? 12 : 6,
          color: Colors.white,
          shadowColor: Colors.black,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              _ModuleCard(widget.module.id),

              // Resize handle
              Positioned(
                right: 4,
                bottom: 4,
                child: GestureDetector(
                  onPanStart: (_) {
                    setState(() {
                      isResizing = true;
                    });

                    resizeOffset = Offset.zero;
                    startW = widget.module.position.w;
                    startH = widget.module.position.h;
                  },
                  onPanUpdate: (details) {
                    resizeOffset += details.delta;

                    final dw = resizeOffset.dx / widget.cellSize;
                    final dh = resizeOffset.dy / widget.cellSize;

                    ref
                        .read(dashboardProvider.notifier)
                        .resizeModuleIfFree(
                          widget.module.copyWith(
                            position: widget.module.position.copyWith(
                              w: startW + dw.round(),
                              h: startH + dh.round(),
                            ),
                          ),
                        );
                  },
                  onPanEnd: (_) {
                    setState(() {
                      isResizing = false;
                    });
                  },
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
