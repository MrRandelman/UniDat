import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dashboard_state.dart';
import 'collision.dart';

import 'models/dashboard_module.dart';
import 'models/module_type.dart';
import 'models/grid_position.dart';

class DashboardNotifier extends StateNotifier<DashboardState> {
  DashboardNotifier() : super(DashboardState.initial()) {
    addModule(
      DashboardModule(
        id: 'documents-1',
        type: ModuleType.documents,
        position: GridPosition(x: 0, y: 0, w: 2, h: 2),
      ),
    );
    addModule(
      DashboardModule(
        id: 'tasks-1',
        type: ModuleType.tasks,
        position: GridPosition(x: 2, y: 0, w: 2, h: 1),
      ),
    );
  }

  // ----------------------------
  // Basic CRUD
  // ----------------------------

  void updateGridBounds({required int maxX, required int maxY}) {
    state = state.copyWith(maxGridX: maxX, maxGridY: maxY);
  }

  void addModule(DashboardModule module) {
    state = state.copyWith(modules: [...state.modules, module]);
  }

  void updateModule(DashboardModule updated) {
    state = state.copyWith(
      modules: [
        for (final m in state.modules)
          if (m.id == updated.id) updated else m,
      ],
    );
  }

  void removeModule(String id) {
    state = state.copyWith(
      modules: state.modules.where((m) => m.id != id).toList(),
    );
  }

  // ----------------------------
  // Collision-safe movement
  // ----------------------------

  void moveModuleIfFree(DashboardModule updated) {
    final clampedX = updated.position.x.clamp(
      0,
      state.maxGridX - updated.position.w,
    );
    final clampedY = updated.position.y.clamp(
      0,
      state.maxGridY - updated.position.h,
    );

    final clampedPosition = updated.position.copyWith(x: clampedX, y: clampedY);

    final collision = collidesWithAny(
      candidate: clampedPosition,
      self: updated,
      others: state.modules,
    );

    if (collision) return;

    updateModule(updated.copyWith(position: clampedPosition));
  }
}

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>(
      (ref) => DashboardNotifier(),
    );
