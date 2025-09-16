import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skygoaltest/features/wallet/bloc/wallet_bloc.dart';

import 'config/routes/app_router.dart';
// import 'core/database/auth_state_notifier.dart';
import 'core/database/user_prefs.dart';
import 'core/themes/app_theme.dart';
import 'data/datasources/theme_local_datasource.dart';
import 'data/repositories/theme_repository_impl.dart';
import 'domain/usecases/get_theme.dart';
import 'domain/usecases/toggle_theme.dart';
import 'core/themes/theme_cubit.dart';
import 'features/authentication/bloc/auth_bloc.dart';
import 'features/authentication/repo/auth_repo.dart';
import 'features/settings/bloc/settings_bloc.dart';
import 'features/transaction/bloc/txn_bloc.dart';
import 'features/transaction/repo/transaction_repository.dart';
import 'features/wallet/repo/wallet_repository.dart';
import 'services/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  final themeLocalDataSource = ThemeLocalDataSourceImpl(sharedPreferences);
  final themeRepository = ThemeRepositoryImpl(themeLocalDataSource);
  final getTheme = GetTheme(themeRepository);
  final toggleTheme = ToggleTheme(themeRepository);

  final isLoggedIn = await UserPreferences.isLoggedIn();
  await HiveService.init();
  final hiveService = HiveService();

  runApp(MyApp(getTheme: getTheme, toggleTheme: toggleTheme, isLoggedIn: isLoggedIn, hiveService: hiveService,));
}

class MyApp extends StatelessWidget {
  final GetTheme getTheme;
  final ToggleTheme toggleTheme;
  final bool isLoggedIn;
  final HiveService hiveService;

  const MyApp({super.key, required this.getTheme, required this.toggleTheme, required this.isLoggedIn,  required this.hiveService, });

  @override
  Widget build(BuildContext context) {
    
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit(getTheme, toggleTheme)),
        BlocProvider(create: (context) => AuthBloc(userRepository:  UserRepository(hiveService))),
        BlocProvider(create: (context) => WalletBloc(walletRepository: WalletRepository(hiveService))),
        BlocProvider(create: (context) => TxnBloc(transactionRepository: TransactionRepository(hiveService))),
        BlocProvider(create: (context) => SettingsBloc()),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDarkMode) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: appRouter(isLoggedIn),
            title: 'Sky Goal',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          );
        },
      ),
    );
  }
}
