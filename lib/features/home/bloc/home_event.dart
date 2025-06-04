abstract class HomeEvent {}

class LoadBalanceEvent extends HomeEvent {}

class SendMoneyEvent extends HomeEvent {
  final String recipientEmail;
  final double amount;

  SendMoneyEvent({
    required this.recipientEmail,
    required this.amount,
  });
}

class RefreshBalanceEvent extends HomeEvent {}
