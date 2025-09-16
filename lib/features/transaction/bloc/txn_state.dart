part of 'txn_bloc.dart';

 class TxnState extends Equatable {
  final bool isTxnLoading;
  final TransactionModel? txnData;
  final List<TransactionModel?> txnDataList;
  final int totalIncome;
  final int totalExpense;
  const TxnState({required this.txnData, this.isTxnLoading = false, required this.txnDataList, required this.totalIncome, required this.totalExpense});

  factory TxnState.initial() {
    return const TxnState(isTxnLoading: false, txnData: null, txnDataList: [], totalIncome: 0, totalExpense: 0);
  }

  TxnState copyWith({final bool? isTxnLoading, final TransactionModel? txnData, final List<TransactionModel?>? txnDataList, final int? totalIncome, final int? totalExpense}) {
    return TxnState(
      isTxnLoading: isTxnLoading ?? this.isTxnLoading,
      txnData: txnData ?? this.txnData,
      txnDataList: txnDataList ?? this.txnDataList,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
    );
  }
  @override
  List<Object?> get props => [isTxnLoading, txnData, txnDataList, totalIncome, totalExpense];
}

