class GridPosition {
  final int x;
  final int y;
  final int w;
  final int h;

  GridPosition({
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

  Map<String, dynamic> toJson() => {'x': x, 'y': y, 'w': w, 'h': h};

  factory GridPosition.fromJson(Map<String, dynamic> json) {
    return GridPosition(x: json['x'], y: json['y'], w: json['w'], h: json['h']);
  }
}
