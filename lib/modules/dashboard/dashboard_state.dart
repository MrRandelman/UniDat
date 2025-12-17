import 'models/dashboard_module.dart';

class DashboardState {
  final List<DashboardModule> modules;
  final int maxGridX;
  final int maxGridY;

  const DashboardState({
    required this.modules,
    required this.maxGridX,
    required this.maxGridY,
  });

  factory DashboardState.initial() {
    return const DashboardState(modules: [], maxGridX: 0, maxGridY: 0);
  }

  DashboardState copyWith({
    List<DashboardModule>? modules,
    int? maxGridX,
    int? maxGridY,
  }) {
    return DashboardState(
      modules: modules ?? this.modules,
      maxGridX: maxGridX ?? this.maxGridX,
      maxGridY: maxGridY ?? this.maxGridY,
    );
  }
}
