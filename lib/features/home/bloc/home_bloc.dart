import 'package:bank/features/home/bloc/home_event.dart';
import 'package:bank/features/home/bloc/home_state.dart';
import 'package:bank/features/home/model/user_balance.dart' as home_models;
import 'package:bank/features/home/services/home_repository.dart' ;
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;
  double? _currentBalance;
  String? _username;

  HomeBloc(this._homeRepository) : super(HomeInitial()) {
    on<LoadBalanceEvent>(_onLoadBalance);
    on<SendMoneyEvent>(_onSendMoney);
    on<RefreshBalanceEvent>(_onRefreshBalance);
  }

  Future<void> _onLoadBalance(LoadBalanceEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    
    try {
      final userBalance = await _homeRepository.getUserBalance();
      _currentBalance = userBalance.balance;
      _username = userBalance.name;
      emit(BalanceLoaded(balance: userBalance.balance,
       name: _username!
      )
       );
    } on home_models.HomeError catch (e) {
      emit(HomeError(message: e.message));
    } catch (e) {
      emit(HomeError(message: 'Failed to load balance'));
    }
  }

  Future<void> _onSendMoney(SendMoneyEvent event, Emitter<HomeState> emit) async {
    if (_currentBalance != null) {
      emit(TransactionLoading(currentBalance: _currentBalance!));
    }
    
    try {
      final request = home_models.SendMoneyRequest(
        recipientEmail: event.recipientEmail,
        amount: event.amount,
      );
      
      final response = await _homeRepository.sendMoney(request);
      _currentBalance = response.senderBalance;
      
      emit(TransactionSuccess(
        newBalance: response.senderBalance,
        transactionId: response.transactionId,
      ));
      
      // Automatically refresh balance after successful transaction
      await Future.delayed(const Duration(milliseconds: 500));
      emit(BalanceLoaded(balance: response.senderBalance,
       name: _username!
       ));
      
    } on home_models.HomeError catch (e) {
      emit(HomeError(
        message: e.message,
        currentBalance: _currentBalance,
      ));
      
      // Return to balance loaded state after showing error
      if (_currentBalance != null) {
        await Future.delayed(const Duration(seconds: 2));
        emit(BalanceLoaded(balance: _currentBalance!,
         name: _username!
         ));
      }
    } catch (e) {
      emit(HomeError(
        message: 'Transaction failed',
        currentBalance: _currentBalance,
      ));
      
      // Return to balance loaded state after showing error
      if (_currentBalance != null) {
        await Future.delayed(const Duration(seconds: 2));
        emit(BalanceLoaded(balance: _currentBalance!,
         name: _username!
         ));
      }
    }
  }

  Future<void> _onRefreshBalance(RefreshBalanceEvent event, Emitter<HomeState> emit) async {
    try {
      final userBalance = await _homeRepository.getUserBalance();
      _currentBalance = userBalance.balance;
      emit(BalanceLoaded(balance: userBalance.balance,
       name: userBalance.name!
       ));
    } on home_models.HomeError catch (e) {
      emit(HomeError(
        message: e.message,
        currentBalance: _currentBalance,
      ));
    } catch (e) {
      emit(HomeError(
        message: 'Failed to refresh balance',
        currentBalance: _currentBalance,
      ));
    }
  }
}