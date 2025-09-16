import 'package:flutter/material.dart';
import 'package:skygoaltest/core/themes/app_theme.dart';
import 'package:skygoaltest/core/widgets/svg_icon_widget.dart';

import 'gap/gap_widget.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final Color? color;
  final void Function()? onTap;
  const CustomAppBar({
    super.key, required this.title, this.onTap, this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 64,
        width: double.infinity,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: onTap,
                  child: SizedBox(
                    height: 32,
                    width: 32,
                    child: Center(
                      child: SvgIcon(name: 'arrow_left', color: color ?? AppTheme.onBackground(context)),
                    ),
                  ),
                ),
          
                Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0, color: color)),
                Gap(32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
