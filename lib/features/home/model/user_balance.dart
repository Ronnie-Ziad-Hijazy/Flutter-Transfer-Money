class UserBalance {
  final double balance;
  final String? name;

  UserBalance(this.name, {
    required this.balance,
  });

  factory UserBalance.fromJson(Map<String, dynamic> json) {
    return UserBalance(
      json['user_name'],
      balance: double.parse(json['balance'].toString()),
    );
  }

  String get formattedBalance {
    return '\$${balance.toStringAsFixed(2)}';
  }
}

class SendMoneyRequest {
  final String recipientEmail;
  final double amount;

  SendMoneyRequest({
    required this.recipientEmail,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'recipient_email': recipientEmail,
      'amount': amount,
    };
  }
}

class TransactionResponse {
  final int transactionId;
  final double senderBalance;
  final double recipientBalance;

  TransactionResponse({
    required this.transactionId,
    required this.senderBalance,
    required this.recipientBalance,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
      transactionId: json['transaction_id'] as int,
      senderBalance: double.parse(json['sender_balance'].toString()),
      recipientBalance: double.parse(json['recipient_balance'].toString()),
    );
  }
}

class HomeError {
  final String message;

  HomeError({required this.message});

  factory HomeError.fromJson(Map<String, dynamic> json) {
    return HomeError(
      message: json['error_msg'] ?? json['message'] ?? 'An error occurred',
    );
  }
}