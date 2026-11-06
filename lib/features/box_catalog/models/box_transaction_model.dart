class BoxTransactionModel {
  final String id;
  final String boxId;
  final String transactionType; // 'IN' or 'OUT'
  final int amount;
  final String? userId;
  final DateTime createdAt;

  const BoxTransactionModel({
    required this.id,
    required this.boxId,
    required this.transactionType,
    required this.amount,
    this.userId,
    required this.createdAt,
  });

  bool get isIn => transactionType.toUpperCase() == 'IN';
  bool get isOut => transactionType.toUpperCase() == 'OUT';

  factory BoxTransactionModel.fromJson(Map<String, dynamic> json) {
    return BoxTransactionModel(
      id: json['id'] as String? ?? '',
      boxId: json['box_id'] as String? ?? '',
      transactionType: json['transaction_type'] as String? ?? 'IN',
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      userId: json['user_id'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson({bool includeId = true}) {
    final data = <String, dynamic>{
      'box_id': boxId,
      'transaction_type': transactionType,
      'amount': amount,
      'user_id': userId,
    };
    if (includeId && id.isNotEmpty) {
      data['id'] = id;
    }
    return data;
  }
}
