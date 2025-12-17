import 'grid_position.dart';
import 'module_type.dart';

class DashboardModule {
  final String id;
  final ModuleType type;
  final GridPosition position;

  DashboardModule({
    required this.id,
    required this.type,
    required this.position,
  });

  DashboardModule copyWith({GridPosition? position}) {
    return DashboardModule(
      id: id,
      type: type,
      position: position ?? this.position,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'position': position.toJson(),
  };

  factory DashboardModule.fromJson(Map<String, dynamic> json) {
    return DashboardModule(
      id: json['id'],
      type: ModuleType.values.byName(json['type']),
      position: GridPosition.fromJson(json['position']),
    );
  }
}
