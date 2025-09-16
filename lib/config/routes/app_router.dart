import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skygoaltest/core/utils/error_page.dart';
import 'package:skygoaltest/features/authentication/login_page.dart';
import 'package:skygoaltest/features/onboarding_setup/setup_account.dart';

import '../../features/authentication/signup_page.dart';
import '../../features/bottom_nav/bottom_nav.dart';
import '../../features/currency/currency.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/onboarding/first_page.dart';
import '../../features/onboarding_setup/add_new_account.dart';
import '../../features/settings/settings.dart';
import '../../features/settings/theme_settings.dart';
import '../../features/transaction/presentation/txn_list.dart';
import '../../features/wallet/add_new_wallet.dart';
import '../../features/onboarding_setup/success_page.dart';
import '../../features/transaction/presentation/txn_form.dart';

GoRouter appRouter(bool isLoggedIn) {
  return GoRouter(
    initialLocation: isLoggedIn ? '/home-page' : '/onboarding-first-page',
    routes: [
      GoRoute(path: '/onboarding-first-page', builder: (context, state) => FirstPage()),
      GoRoute(path: '/carousel-first-page', builder: (context, state) => OnboardingScreen()),
      GoRoute(path: '/sign-up', builder: (context, state) => SignupPage()),
      GoRoute(path: '/login', builder: (context, state) => LoginPage()),
      GoRoute(path: '/setup-account', builder: (context, state) => SetupAccount()),
      GoRoute(path: '/add-new-account', builder: (context, state) => AddNewAccount()),
      GoRoute(path: '/add-new-wallet', builder: (context, state) => AddNewWallet()),
      GoRoute(path: '/success-page', builder: (context, state) => SuccessPage()),
      GoRoute(path: '/home-page', builder: (context, state) => BottomNav()),
      GoRoute(path: '/record-income', builder: (context, state) => TransactionFormPage(transactionType: TransactionType.income)),
      GoRoute(path: '/record-expense', builder: (context, state) => TransactionFormPage(transactionType: TransactionType.expense)),
      GoRoute(path: '/settings', builder: (context, state) => Settings()),
      GoRoute(path: '/settings/settings-currency', builder: (context, state) => CurrencySettings()),
      GoRoute(path: '/settings/settings-theme', builder: (context, state) => ThemeSettings()),
      GoRoute(path: '/transaction-list', builder: (context, state) => TxnList()),
    ],

    errorBuilder: (context, state) {
      return ErrorPage(errorMessage: 'The page "${state.uri.toString()}" does not exist.');
    },
    observers: [_NavigationLogger()],
  );
}


class _NavigationLogger extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log('Pushed route: ${route.settings.name ?? route.settings}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log('Popped route: ${route.settings.name ?? route.settings}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    log('Replaced route: ${newRoute?.settings.name ?? newRoute}');
  }
}


/* final GoRouter appRouter = GoRouter(
  initialLocation: '/onboarding-first-page',
  routes: [
    GoRoute(
      path: '/onboarding-first-page',
      builder: (context, state) {
        return FirstPage();
      },
    ),
    GoRoute(
      path: '/carousel-first-page',
      builder: (context, state) {
        return OnboardingScreen();
      },
    ),
    GoRoute(
      path: '/sign-up',
      builder: (context, state) {
        return SignupPage();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) {
        return LoginPage();
      },
    ),
    GoRoute(
      path: '/setup-account',
      builder: (context, state) {
        return SetupAccount();
      },
    ),
    GoRoute(
      path: '/add-new-account',
      builder: (context, state) {
        return AddNewAccount();
      },
    ),
    GoRoute(
      path: '/add-new-wallet',
      builder: (context, state) {
        return AddNewWallet();
      },
    ),
    GoRoute(
      path: '/success-page',
      builder: (context, state) {
        return SuccessPage();
      },
    ),
    GoRoute(
      path: '/home-page',
      builder: (context, state) {
        return BottomNav();
      },
    ),
  ],
  errorBuilder: (context, state) {
    log('Navigation error: Page not found at ${state.uri.toString()}');
    return ErrorPage(errorMessage: 'The page "${state.uri.toString()}" does not exist.');
  },
  redirect: (context, state) {
    // Add redirect logic if needed (e.g., for authentication)
    log('Checking redirect for path: ${state.uri.toString()}');
    return null;
  },
  observers: [_NavigationLogger()],
);
 */