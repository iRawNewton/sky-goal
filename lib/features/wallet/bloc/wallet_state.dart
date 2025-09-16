part of 'wallet_bloc.dart';

class WalletState extends Equatable {
  final bool isLoading;
  final String? errorMessage;

  const WalletState({this.isLoading = false, this.errorMessage});
  factory WalletState.initial() {
    return const WalletState(isLoading: false, errorMessage: null);
  }
  WalletState copyWith({final bool? isLoading, final String? errorMessage}) {
    return WalletState(isLoading: isLoading ?? this.isLoading, errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  List<Object> get props => [isLoading, errorMessage ?? ''];
}
