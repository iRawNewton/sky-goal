part of 'txn_bloc.dart';

sealed class TxnEvent extends Equatable {
  const TxnEvent();

  @override
  List<Object> get props => [];
}

class CreateTxnEvent extends TxnEvent {
  final TransactionModel txnData;
  const CreateTxnEvent({required this.txnData});

  @override
  List<Object> get props => [txnData];
}

class FetchAllTxnsEvent extends TxnEvent {}

class FetchTxnEvent extends TxnEvent {
  final String txnId;
  const FetchTxnEvent({required this.txnId});

  @override
  List<Object> get props => [txnId];
}

class UpdateTxnEvent extends TxnEvent {
  final TransactionModel txnData;
  const UpdateTxnEvent({required this.txnData});

  @override
  List<Object> get props => [txnData];
}

class DeleteTxnEvent extends TxnEvent {
  final String txnId;
  const DeleteTxnEvent({required this.txnId});

  @override
  List<Object> get props => [txnId];
}
