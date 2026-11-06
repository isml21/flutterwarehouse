class BoxModel {
  final String id;
  final String boxCode;
  final String name;
  final double lengthCm;
  final double widthCm;
  final double heightCm;
  final String materialType;
  final int quantity;
  final String location;
  final String status;
  final DateTime createdAt;

  const BoxModel({
    required this.id,
    required this.boxCode,
    required this.name,
    required this.lengthCm,
    required this.widthCm,
    required this.heightCm,
    required this.materialType,
    required this.quantity,
    required this.location,
    required this.status,
    required this.createdAt,
  });

  /// Calculate status based on current quantity
  static String calculateStatus(int qty) {
    if (qty <= 0) return 'Out of Stock';
    if (qty <= 5) return 'Low Stock';
    return 'In Stock';
  }

  /// Total volume in cubic centimeters (cm³)
  double get volumeCubicCm => lengthCm * widthCm * heightCm;

  /// Total volume in liters (L)
  double get volumeLiters => volumeCubicCm / 1000.0;

  /// Formatted dimension string (L × W × H cm)
  String get dimensionFormatted =>
      '${_formatNum(lengthCm)} × ${_formatNum(widthCm)} × ${_formatNum(heightCm)} cm';

  static String _formatNum(double n) {
    return n.truncateToDouble() == n ? n.toInt().toString() : n.toStringAsFixed(1);
  }

  bool get isOutOfStock => quantity <= 0;
  bool get isLowStock => quantity > 0 && quantity <= 5;
  bool get isInStock => quantity > 5;

  factory BoxModel.fromJson(Map<String, dynamic> json) {
    return BoxModel(
      id: json['id'] as String? ?? '',
      boxCode: json['box_code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      lengthCm: (json['length_cm'] as num?)?.toDouble() ?? 0.0,
      widthCm: (json['width_cm'] as num?)?.toDouble() ?? 0.0,
      heightCm: (json['height_cm'] as num?)?.toDouble() ?? 0.0,
      materialType: json['material_type'] as String? ?? 'Corrugated Cardboard',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      location: json['location'] as String? ?? 'Unassigned',
      status: json['status'] as String? ?? calculateStatus((json['quantity'] as num?)?.toInt() ?? 0),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson({bool includeId = true}) {
    final data = <String, dynamic>{
      'box_code': boxCode,
      'name': name,
      'length_cm': lengthCm,
      'width_cm': widthCm,
      'height_cm': heightCm,
      'material_type': materialType,
      'quantity': quantity,
      'location': location,
      'status': status,
    };
    if (includeId && id.isNotEmpty) {
      data['id'] = id;
    }
    return data;
  }

  BoxModel copyWith({
    String? id,
    String? boxCode,
    String? name,
    double? lengthCm,
    double? widthCm,
    double? heightCm,
    String? materialType,
    int? quantity,
    String? location,
    String? status,
    DateTime? createdAt,
  }) {
    return BoxModel(
      id: id ?? this.id,
      boxCode: boxCode ?? this.boxCode,
      name: name ?? this.name,
      lengthCm: lengthCm ?? this.lengthCm,
      widthCm: widthCm ?? this.widthCm,
      heightCm: heightCm ?? this.heightCm,
      materialType: materialType ?? this.materialType,
      quantity: quantity ?? this.quantity,
      location: location ?? this.location,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
