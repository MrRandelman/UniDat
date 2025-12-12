class GridPosition {
  final int x;
  final int y;
  final int w;
  final int h;

  const GridPosition({
    required this.x,
    required this.y,
    required this.w,
    required this.h,
  });

  GridPosition copyWith({int? x, int? y, int? w, int? h}) {
    return GridPosition(
      x: x ?? this.x,
      y: y ?? this.y,
      w: w ?? this.w,
      h: h ?? this.h,
    );
  }
}
