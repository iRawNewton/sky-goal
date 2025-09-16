import 'package:flutter/material.dart';
import 'package:skygoaltest/core/themes/app_theme.dart';

class AuthTextField extends StatefulWidget {
  final bool? isPassword;
  final String hintText;
  final TextEditingController textEditingController;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;

  const AuthTextField({super.key, this.isPassword, required this.hintText, required this.textEditingController, this.keyboardType, this.validator});

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  final ValueNotifier<bool> toggleVisibility = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: ValueListenableBuilder<bool>(
        valueListenable: toggleVisibility,
        builder: (context, isHidden, _) {
          return TextFormField(
            controller: widget.textEditingController,
            obscureText: (widget.isPassword ?? false) ? isHidden : false,
            obscuringCharacter: '*',
            validator: widget.validator,
            keyboardType: widget.keyboardType,
            decoration: InputDecoration(
              hint: Text(widget.hintText),
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppTheme.violet100(context), width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              suffixIcon: (widget.isPassword ?? false)
                  ? GestureDetector(
                      onTap: () => toggleVisibility.value = !toggleVisibility.value,
                      child: Icon(isHidden ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                    )
                  : const SizedBox(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), // Controls input height
            ),
          );
        },
      ),
    );
  }
}
