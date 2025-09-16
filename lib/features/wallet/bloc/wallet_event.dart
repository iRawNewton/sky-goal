part of 'wallet_bloc.dart';

sealed class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object> get props => [];
}

class CreateWalletEvent extends WalletEvent {
  final String name;
  final String accountType;
  final double balance;

  const CreateWalletEvent({required this.name, required this.accountType, required this.balance});

  @override
  List<Object> get props => [name, accountType, balance];
}

class LoadWalletsEvent extends WalletEvent {}