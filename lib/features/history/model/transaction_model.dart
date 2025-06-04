class TransactionModel {
  final String transactionType;
  final DateTime createdAt;
  final double amount;
  final String status;
  final String from;
  final String to;

  TransactionModel({
    required this.transactionType,
    required this.createdAt,
    required this.amount,
    required this.status,
    required this.from,
    required this.to,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      transactionType: json['transaction_type'],
      createdAt: DateTime.parse(json['created_at']),
      amount: double.parse(json['amount'].toString()),
      status: json['status'],
      from: json['from'],
      to: json['to'],
    );
  }
}