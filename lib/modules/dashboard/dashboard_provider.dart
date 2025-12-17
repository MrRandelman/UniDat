import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dashboard_state.dart';
import 'dashboard_storage.dart';
import 'collision.dart';
import 'models/module_type.dart';
import 'models/grid_position.dart';

import 'models/dashboard_module.dart';

class DashboardNotifier extends StateNotifier<DashboardState> {
  DashboardNotifier() : super(DashboardState.initial()) {
    _load();
    addModule(
      DashboardModule(
        id: 'test-1',
        type: ModuleType.tasks,
        position: GridPosition(x: 2, y: 0, w: 2, h: 2),
      ),
    );
    addModule(
      DashboardModule(
        id: 'test-2',
        type: ModuleType.calendar,
        position: GridPosition(x: 0, y: 2, w: 4, h: 2),
      ),
    );
    addModule(
      DashboardModule(
        id: 'test-3',
        type: ModuleType.stats,
        position: GridPosition(x: 4, y: 0, w: 2, h: 4),
      ),
    );
  }

  Future<void> _load() async {
    final modules = await DashboardStorage.load();
    if (modules.isEmpty) return;

    state = state.copyWith(modules: modules);
  }

  void updateGridBounds({required int maxX, required int maxY}) {
    state = state.copyWith(maxGridX: maxX, maxGridY: maxY);
  }

  void addModule(DashboardModule module) {
    state = state.copyWith(modules: [...state.modules, module]);
    DashboardStorage.save(state.modules);
  }

  void updateModule(DashboardModule updated) {
    state = state.copyWith(
      modules: [
        for (final m in state.modules)
          if (m.id == updated.id) updated else m,
      ],
    );
    DashboardStorage.save(state.modules);
  }

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

  void resizeModuleIfFree(DashboardModule updated) {
    final clampedW = updated.position.w.clamp(
      1,
      state.maxGridX - updated.position.x,
    );
    final clampedH = updated.position.h.clamp(
      1,
      state.maxGridY - updated.position.y,
    );

    final clampedPosition = updated.position.copyWith(w: clampedW, h: clampedH);

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
