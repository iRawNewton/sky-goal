import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skygoaltest/core/themes/app_theme.dart';
import 'package:skygoaltest/core/widgets/custom_app_bar.dart';
import 'package:skygoaltest/core/widgets/custom_button.dart';
import 'package:skygoaltest/core/widgets/gap/gap_widget.dart';

import '../../core/widgets/custom_snackbar.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/rich_text_widget.dart';
import 'bloc/auth_bloc.dart';
import 'widgets/auth_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                /* --------------------------------- AppBar --------------------------------- */
                CustomAppBar(onTap: () => context.pop(), title: 'Login'),
                Gap(32),

                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        /* ---------------------------------- Email --------------------------------- */
                        AuthTextField(
                          isPassword: false,
                          hintText: 'Email',
                          textEditingController: _emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        Gap(8),

                        /* -------------------------------- Password -------------------------------- */
                        AuthTextField(
                          isPassword: true,
                          hintText: 'Password',
                          textEditingController: _passwordController,
                          keyboardType: TextInputType.visiblePassword,
                        ),
                        Gap(16),
                      ],
                    ),
                  ),
                ),

                /* ------------------------------ Login Button ------------------------------ */
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) async {
                      isLoading.value = state.isLoading ? true : false;

                      if (!state.isLoading && state.loginSuccess == true) {
                        // Save user to SharedPrefs
                        // await UserPreferences.saveUser(state.user);
                        // authStateNotifier.setLoggedIn(true);
                        context.go('/setup-account');
                      } else if (!state.isLoading && state.loginSuccess == false) {
                        CustomSnackBar.danger(context, title: 'Login failed. Try again!');
                      }
                    },

                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: CustomFilledButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();

                              context.read<AuthBloc>().add(LogInEvent(_emailController.text.trim(), _passwordController.text.trim()));
                            }
                          },
                          title: state.isLoading ? 'Logging In...' : 'Login',
                        ),
                      );
                    },
                  ),
                ),
                Gap(16),

                /* ----------------------------- Forgot Password ---------------------------- */
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: AppTheme.violet100(context), fontWeight: FontWeight.w600),
                  ),
                ),

                /* ---------------------------- Signup Text button --------------------------- */
                Gap(16),
                Expanded(
                  child: RichTextWidget(
                    onTap: () {
                      context.push('/sign-up');
                    },
                    text: 'Don’t have an account yet? ',
                    clickableText: 'Sign Up',
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
