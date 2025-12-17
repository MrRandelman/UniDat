import 'models/dashboard_module.dart';
import 'models/grid_position.dart';

bool collidesWithAny({
  required GridPosition candidate,
  required DashboardModule self,
  required List<DashboardModule> others,
}) {
  for (final m in others) {
    if (m.id == self.id) continue;

    final a = candidate;
    final b = m.position;

    final overlapX = a.x < b.x + b.w && a.x + a.w > b.x;
    final overlapY = a.y < b.y + b.h && a.y + a.h > b.y;

    if (overlapX && overlapY) {
      return true;
    }
  }
  return false;
}
