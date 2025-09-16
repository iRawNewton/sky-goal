import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skygoaltest/features/settings/model/settings_model.dart';

import '../repo/settings_repo.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState.initial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
  }

  Future<void> _onLoadSettings(LoadSettingsEvent event, Emitter<SettingsState> emit) async {
    final settings = await SettingsRepo().loadSettings();
    print(' :::: Loaded settings: $settings');
    emit(state.copyWith(settingsList: settings));
  }
}
