import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skygoaltest/core/themes/app_theme.dart';
import 'package:skygoaltest/core/widgets/custom_app_bar.dart';
import 'package:skygoaltest/core/widgets/gap/gap_widget.dart';

import 'bloc/settings_bloc.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String theme = 'Light';
  @override
  void initState() {
    context.read<SettingsBloc>().add(LoadSettingsEvent());
    _loadThemeMode();
    super.initState();
  }

   Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final mode = prefs.getString('theme_mode') ?? 'light';
    setState(() {
      if (mode == 'dark') {
        theme = 'Dark';
      } else {
        theme = 'Light';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Gap(5),
            CustomAppBar(
              title: 'Settings',
              onTap: () {
                context.pop();
              },
            ),
            Gap(5),

            BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, state) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.settingsList.length,
                  itemBuilder: (context, index) {
                    final setting = state.settingsList[index];
                    return InkWell(
                      onTap: () {
                        context.push('/settings/${setting.pageSlug}');
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                setting.title,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppTheme.textColor(context)),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (setting.subtitle.isNotEmpty)
                                  Text(
                                    setting.subtitle == 'Dark' ? theme : setting.subtitle,
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppTheme.subtitleColor(context)),
                                  ),
                                const SizedBox(width: 8),
                                Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.subtitleColor(context)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}

/* class SettingsMenuItems extends StatelessWidget {
  const SettingsMenuItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Text(
            'Currency',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppTheme.textColor(context)),
          ),
          Spacer(),
          Text(
            'INR',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.subtitleColor(context)),
          ),
          Gap(10),
          Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.subtitleColor(context)),
        ],
      ),
    );
  }
}
 */