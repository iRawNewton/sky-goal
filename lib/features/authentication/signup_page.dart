import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skygoaltest/core/themes/app_theme.dart';
import 'package:skygoaltest/core/widgets/custom_app_bar.dart';
import 'package:skygoaltest/core/widgets/custom_button.dart';
import 'package:skygoaltest/core/widgets/custom_snackbar.dart';
import 'package:skygoaltest/core/widgets/gap/gap_widget.dart';

import '../../core/utils/validators.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/rich_text_widget.dart';
import 'bloc/auth_bloc.dart';
import 'widgets/auth_text_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  ValueNotifier<bool> toggleCheck = ValueNotifier<bool>(false);
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    toggleCheck.dispose();
    isLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                CustomAppBar(onTap: () => context.pop(), title: 'Sign Up '),
                Gap(32),

                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        AuthTextField(
                          isPassword: false,
                          hintText: 'Name',
                          textEditingController: _nameController,
                          keyboardType: TextInputType.name,
                          validator: Validators.validateName,
                        ),
                        Gap(8),
                        AuthTextField(
                          isPassword: false,
                          hintText: 'Email',
                          textEditingController: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: Validators.validateEmail,
                        ),
                        Gap(8),
                        AuthTextField(
                          isPassword: true,
                          hintText: 'Password',
                          textEditingController: _passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          validator: Validators.validatePassword,
                        ),
                        Gap(16),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: [
                      ValueListenableBuilder<bool>(
                        valueListenable: toggleCheck,
                        builder: (context, value, _) {
                          return Checkbox(
                            value: value,
                            onChanged: (bool? newValue) {
                              toggleCheck.value = newValue ?? false;
                            },
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            side: BorderSide(color: AppTheme.violet100(context), width: 2),
                            checkColor: Colors.white,
                            activeColor: AppTheme.violet100(context),
                          );
                        },
                      ),
                      Gap(8),
                      /* ElevatedButton(onPressed: ()async {
                         bool userData = await AuthRepository().signup('Gaurab', 'gaurab@mail.com', 'asdASD@123');
                      }, child: Text('data')), */
                      Expanded(
                        child: RichTextWidget(
                          onTap: () {
                            CustomSnackBar.info(
                              context,
                              title: 'Terms and Conditions Clicked',
                              position: CustomSnackBarPosition.bottomCenter,
                              showCloseButton: true,
                            );
                          },
                          text: 'By signing up, you agree to the ',
                          clickableText: 'Terms of Service and Privacy Policy',
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      isLoading.value = state.isLoading ? true : false;

                      if (!state.isLoading && state.signUpSuccess == true) {
                        // CustomSnackBar.success(context, title: 'Sign up successful!');
                        context.go('/login');
                      } else if (!state.isLoading && state.signUpSuccess == false) {
                        // CustomSnackBar.danger(context, title: 'Sign up failed!');
                      }
                    },
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: CustomFilledButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();

                              if (toggleCheck.value) {
                                context.read<AuthBloc>().add(
                                  SignUpEvent(_nameController.text.trim(), _emailController.text.trim(), _passwordController.text.trim()),
                                );
                              } else {
                                CustomSnackBar.danger(
                                  context,
                                  title: 'Please accept T & C',
                                  position: CustomSnackBarPosition.bottomCenter,
                                  showCloseButton: true,
                                );
                              }
                            }
                          },
                          title: state.isLoading ? 'Signing Up...' : 'Sign Up',
                          // isDisabled: state.isLoading,
                        ),
                      );
                    },
                  ),
                ),

                Gap(16),
                Expanded(
                  child: RichTextWidget(
                    onTap: () {
                      context.go('/login');
                    },
                    text: 'Already have an account? ',
                    clickableText: 'Login',
                  ),
                ),
              ],
            ),

            /* ---------------------------- Loading Overlay ---------------------------- */
            ValueListenableBuilder<bool>(
              valueListenable: isLoading,
              builder: (context, value, _) {
                return value ? LoadingIndicator() : SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
