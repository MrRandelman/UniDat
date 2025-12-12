import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dashboard_state.dart';
import 'models/dashboard_module.dart';
import 'models/module_type.dart';
import 'models/grid_position.dart';

class DashboardNotifier extends StateNotifier<DashboardState> {
  DashboardNotifier() : super(DashboardState.initial()) {
    addModule(
      DashboardModule(
        id: 'documents-1',
        type: ModuleType.documents,
        position: const GridPosition(x: 0, y: 0, w: 2, h: 2),
      ),
    );
    addModule(
      DashboardModule(
        id: 'stats-1',
        type: ModuleType.stats,
        position: const GridPosition(x: 2, y: 0, w: 2, h: 2),
      ),
    );
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
}

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>(
      (ref) => DashboardNotifier(),
    );
