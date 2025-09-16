part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final bool isLoading;
  final UserModel user;
  final bool? signUpSuccess;
  final bool? loginSuccess;
  const AuthState({required this.isLoading, required this.user, required this.signUpSuccess, required this.loginSuccess});

  factory AuthState.initial() {
    return AuthState(isLoading: false, user: UserModel.empty(), signUpSuccess: null, loginSuccess: null);
  }

  AuthState copyWith({final bool? isLoading, final UserModel? user, final bool? signUpSuccess, final bool? loginSuccess}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      signUpSuccess: signUpSuccess ?? this.signUpSuccess,
      loginSuccess: loginSuccess ?? this.loginSuccess,
    );
  }

  @override
  List<Object?> get props => [isLoading, user, signUpSuccess, loginSuccess];
}

