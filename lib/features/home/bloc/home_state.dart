abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class BalanceLoaded extends HomeState {
  final double balance;
  final String name;

  BalanceLoaded( {required this.balance,
  required this.name
  }
  );
}

class TransactionLoading extends HomeState {
  final double currentBalance;

  TransactionLoading({required this.currentBalance});
}

class TransactionSuccess extends HomeState {
  final double newBalance;
  final int transactionId;

  TransactionSuccess({
    required this.newBalance,
    required this.transactionId,
  });
}

class HomeError extends HomeState {
  final String message;
  final double? currentBalance;

  HomeError({
    required this.message,
    this.currentBalance,
  });
}