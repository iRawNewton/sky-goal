import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../model/txn_model.dart';
import '../repo/transaction_repository.dart';

part 'txn_event.dart';
part 'txn_state.dart';

class TxnBloc extends Bloc<TxnEvent, TxnState> {
  final TransactionRepository transactionRepository;
  TxnBloc({required this.transactionRepository}) : super(TxnState.initial()) {
    on<CreateTxnEvent>(_createTxnEvent);
    on<FetchAllTxnsEvent>(_fetchAllTxnsEvent);
  }

  Future<void> _createTxnEvent(CreateTxnEvent event, Emitter<TxnState> emit) async {
    emit(state.copyWith(isTxnLoading: true));
    try {
      final id = await transactionRepository.createTransaction(event.txnData);
      final newTxn = event.txnData;
      newTxn.id = id;
      final updatedTxnList = List<TransactionModel?>.from(state.txnDataList)..add(newTxn);
      emit(state.copyWith(isTxnLoading: false, txnData: newTxn, txnDataList: updatedTxnList));
    } catch (e) {
      emit(state.copyWith(isTxnLoading: false, txnData: null));
    }
  }

  Future<void> _fetchAllTxnsEvent(FetchAllTxnsEvent event, Emitter<TxnState> emit) async {
    emit(state.copyWith(isTxnLoading: true));
    try {
      final txns = transactionRepository.getTransactions();

      double totalIncome = 0;
      double totalExpense = 0;

      for (var txn in txns) {
        if (txn.type == 'income') {
          totalIncome += txn.amount;
        } else if (txn.type == 'expense') {
          totalExpense += txn.amount;
        }
      }

      emit(state.copyWith(isTxnLoading: false, txnDataList: txns, totalIncome: totalIncome.toInt(), totalExpense: totalExpense.toInt()));
    } catch (e) {
      emit(state.copyWith(isTxnLoading: false, txnDataList: []));
    }
  }
}
