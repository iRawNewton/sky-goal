import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skygoaltest/features/authentication/repo/auth_repo.dart';

import '../../../core/database/user_prefs.dart';
import '../model/user_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository userRepository;
  AuthBloc({required this.userRepository}) : super(AuthState.initial()) {
    on<SignUpEvent>(_signUpEvent);
    on<LogInEvent>(_logInEvent);
    on<LogOutEvent>(_logOutEvent);
  }

  Future<void> _signUpEvent(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      final newUser = UserModel(name: event.name, email: event.email, password: event.password);

      final id = await userRepository.createUser(newUser);
      newUser.id = id;

      await UserPreferences.saveUser(newUser);

      emit(state.copyWith(isLoading: false, user: newUser, signUpSuccess: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, signUpSuccess: false));
    }
  }

  Future<void> _logInEvent(LogInEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      final user = userRepository.getUserByEmail(event.email);

      if (user == null || user.password != event.password) {
        emit(state.copyWith(isLoading: false, loginSuccess: false));
        return;
      }

      await UserPreferences.saveUser(user);

      emit(state.copyWith(isLoading: false, user: user, loginSuccess: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, loginSuccess: false));
    }
  }

  Future<void> _logOutEvent(LogOutEvent event, Emitter<AuthState> emit) async {
    try {
      await UserPreferences.clearUser();
      emit(AuthState.initial());
    } catch (e) {
      emit(state.copyWith());
    }
  }
}
