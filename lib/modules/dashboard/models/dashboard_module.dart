import 'module_type.dart';
import 'grid_position.dart';

class DashboardModule {
  final String id;
  final ModuleType type;
  final GridPosition position;
  final bool visible;

  const DashboardModule({
    required this.id,
    required this.type,
    required this.position,
    this.visible = true,
  });

  DashboardModule copyWith({GridPosition? position, bool? visible}) {
    return DashboardModule(
      id: id,
      type: type,
      position: position ?? this.position,
      visible: visible ?? this.visible,
    );
  }
}
