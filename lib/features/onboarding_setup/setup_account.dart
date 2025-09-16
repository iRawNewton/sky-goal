import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skygoaltest/core/themes/app_theme.dart';
import 'package:skygoaltest/core/widgets/custom_button.dart';
import 'package:skygoaltest/core/widgets/gap/gap_widget.dart';

class SetupAccount extends StatelessWidget {
  const SetupAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Gap(46.0),
              Text(
                'Let\'s setup your account!',
                style: TextStyle(color: AppTheme.textColor(context), fontWeight: FontWeight.w500, fontSize: 36.0),
              ),
              Gap(16),
              Text(
                'Account can be your bank, credit card or your wallet.',
                style: TextStyle(color: AppTheme.subtitleColor(context), fontWeight: FontWeight.w500, fontSize: 14.0),
              ),
              Spacer(),
              CustomFilledButton(
                onPressed: () {
                  context.push('/add-new-account');
                },
                title: 'Let\'s go',
              ),
              Gap(8),
            ],
          ),
        ),
      ),
    );
  }
}

/* 
font-family: Inter;
font-weight: 500;
font-size: 14px;
leading-trim: NONE;
line-height: 18px;
letter-spacing: 0px;

 */
