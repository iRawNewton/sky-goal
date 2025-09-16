import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skygoaltest/core/database/user_prefs.dart';
import 'package:skygoaltest/core/themes/app_theme.dart';
import 'package:skygoaltest/core/widgets/gap/gap_widget.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              /* --------------------------------- Header --------------------------------- */
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ProfileIconWidget(),
                  Gap(20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Username',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppTheme.subtitleColor(context)),
                        ),
                        Gap(4),
                        Text(
                          'Sai Priya',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppTheme.textColor(context)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
                    child: Icon(Icons.edit, size: 16, color: Colors.grey[700]),
                  ),
                ],
              ),

              /* ---------------------------------- Menu Items ---------------------------------- */
              Gap(40),
              Column(
                children: [
                  ProfileMenuItem(
                    icon: Icons.account_balance_wallet,
                    iconColor: Colors.white,
                    iconBackgroundColor: Color(0xFF8B5CF6),
                    title: 'Account',
                    onTap: () {
                     /*  print('*************** Settings Tap ****************');
                      context.read<TxnBloc>().add(FetchAllTxnsEvent());
                      print('*************** Settings Tapped ****************'); */
                    },
                  ),
                  Gap(16),
                  ProfileMenuItem(
                    icon: Icons.settings,
                    iconColor: AppTheme.background(context).withValues(alpha: 0.9),
                    iconBackgroundColor: Color(0xFF8B5CF6),
                    title: 'Settings',
                    onTap: () {
                      context.push('/settings');
                      /* print('*************** Settings Tap ****************');
                      context.read<WalletBloc>().add(LoadWalletsEvent());
                      print('*************** Settings Tapped ****************'); */
                    },
                  ),
                  Gap(16),
                  ProfileMenuItem(
                    icon: Icons.logout,
                    iconColor: Colors.white,
                    iconBackgroundColor: Color(0xFFEF4444),
                    title: 'Logout',
                    onTap: () {
                      UserPreferences.clearUser();
                      context.go('/sign-up');
                    },
                  ),
                ],
              ),

              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileIconWidget extends StatelessWidget {
  const ProfileIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Color(0xFF8B5CF6), width: 2.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: CircleAvatar(radius: 36, backgroundImage: AssetImage('assets/images/onboarding1.png'), backgroundColor: Colors.grey[200]),
      ),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final String title;
  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground(context),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.03), blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: iconBackgroundColor.withValues(alpha:0.15), borderRadius: BorderRadius.circular(12)),
              child: Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(color: iconBackgroundColor, borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: iconColor, size: 20),
              ),
            ),
            Gap(16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppTheme.textColor(context)),
              ),
            ),
            Icon(Icons.chevron_right, color: AppTheme.subtitleColor(context), size: 20),
          ],
        ),
      ),
    );
  }
}
