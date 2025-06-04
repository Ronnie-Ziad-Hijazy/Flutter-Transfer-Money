import 'package:bank/features/history/services/transaction_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository repository;

  TransactionBloc(this.repository) : super(TransactionInitial()) {
    on<LoadTransactions>((event, emit) async {
      emit(TransactionLoading());
      try {
        final transactions = await repository.fetchTransactions();
        emit(TransactionLoaded(transactions));
      } catch (e) {
        emit(TransactionError('Failed to load transactions'));
      }
    });
  }
}