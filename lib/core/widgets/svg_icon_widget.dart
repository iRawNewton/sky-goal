import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../themes/app_theme.dart';

class SvgIcon extends StatelessWidget {
  final String name;
  final double? width;
  final double? height;
  final Color? color;
  final Alignment? alignment;

  const SvgIcon({super.key, required this.name, this.width = 20, this.height = 20, this.color, this.alignment = Alignment.topLeft});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/svg/$name.svg',
      width: width,
      height: height,
      fit: BoxFit.contain,
      alignment: Alignment.center,
      colorFilter: ColorFilter.mode(color ?? AppTheme.onBackground(context), BlendMode.srcIn),
      semanticsLabel: '$name icon',
      matchTextDirection: true,
    );
  }
}
