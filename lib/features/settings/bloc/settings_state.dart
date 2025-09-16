part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final List<SettingsModel> settingsList;
  const SettingsState({required this.settingsList});

  factory SettingsState.initial() {
    return SettingsState(
      settingsList: [],
    );
  }
  SettingsState copyWith({final List<SettingsModel>? settingsList}) {
    return SettingsState(settingsList: settingsList ?? this.settingsList);
  }

  @override
  List<Object> get props => [settingsList];
}
