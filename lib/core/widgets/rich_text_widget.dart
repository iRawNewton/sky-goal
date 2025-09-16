import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../themes/app_theme.dart';

class RichTextWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  final String clickableText;

  const RichTextWidget({super.key, this.onTap, required this.text, required this.clickableText});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(color: AppTheme.textColor(context), fontSize: 14),
        children: [
          TextSpan(text: text),
          TextSpan(
            text: clickableText,
            style: TextStyle(color: AppTheme.violet100(context), decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
      textAlign: TextAlign.left,
      softWrap: true,
      overflow: TextOverflow.visible,
    );
  }
}
