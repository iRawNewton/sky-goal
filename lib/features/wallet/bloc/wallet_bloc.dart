import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skygoaltest/features/wallet/model/wallet_model.dart';
import 'package:skygoaltest/features/wallet/repo/wallet_repository.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletRepository walletRepository;

  WalletBloc({required this.walletRepository}) : super(WalletState.initial()) {
    on<CreateWalletEvent>(_createWalletEvent);
    on<LoadWalletsEvent>(_loadWalletsEvent);
  }

  Future<void> _createWalletEvent(CreateWalletEvent event, Emitter<WalletState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      event.name;
      event.accountType;
      event.balance;

      final newWallet = WalletModel(name: event.name, accountType: event.accountType, balance: event.balance);

      await walletRepository.createWallet(newWallet);

      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _loadWalletsEvent(LoadWalletsEvent event, Emitter<WalletState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final wallets = walletRepository.getAllWallets();
      print(' Wallets: ${wallets[0].accountType} ');
      print(' Wallets: ${wallets[0].balance} ');
      print(' Wallets: ${wallets[0].name} ');
      print(' Wallets: ${wallets[0].id} ');

      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
