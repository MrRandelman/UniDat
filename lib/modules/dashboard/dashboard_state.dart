import 'models/dashboard_module.dart';

class DashboardState {
  final List<DashboardModule> modules;

  const DashboardState({required this.modules});

  factory DashboardState.initial() {
    return DashboardState(modules: []);
  }

  DashboardState copyWith({List<DashboardModule>? modules}) {
    return DashboardState(modules: modules ?? this.modules);
  }
}
