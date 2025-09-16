import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skygoaltest/core/themes/app_theme.dart';
import 'package:skygoaltest/core/widgets/custom_app_bar.dart';
import 'package:skygoaltest/core/widgets/custom_button.dart';
import 'package:skygoaltest/core/widgets/gap/gap_widget.dart';
import 'package:skygoaltest/core/widgets/loading_indicator.dart';
import 'package:skygoaltest/features/authentication/widgets/auth_text_field.dart';

import 'bloc/wallet_bloc.dart';

class AddNewWallet extends StatefulWidget {
  const AddNewWallet({super.key});

  @override
  State<AddNewWallet> createState() => _AddNewWalletState();
}

class _AddNewWalletState extends State<AddNewWallet> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedAccountType;
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  final List<String> _accountTypes = ['Bank', 'Credit Card', 'Debit Card'];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: AppTheme.violet100(context)),
            child: SafeArea(
              bottom: true,
              child: Column(
                children: [
                  /* --------------------------------- App Bar -------------------------------- */
                  CustomAppBar(
                    title: 'Add new wallet',
                    onTap: () {
                      context.pop();
                    },
                    color: Colors.white,
                  ),
                  const Gap(60),

                  /* ----------------------------- Balance Section ---------------------------- */
                  Column(
                    children: [
                      const Text(
                        'Balance',
                        style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                      const Gap(16),
                      SizedBox(
                        width: 200,
                        child: TextField(
                          controller: TextEditingController(),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          style: const TextStyle(color: Colors.white, fontSize: 64, fontWeight: FontWeight.w300),
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '₹00.0',
                            hintStyle: TextStyle(color: Colors.white54, fontSize: 64, fontWeight: FontWeight.w300),
                            isCollapsed: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          cursorColor: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const Gap(80),

                  /* ------------------------------ Form Section ------------------------------ */
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              const SizedBox(height: 24),

                              /* ---------------------------------- Name ---------------------------------- */
                              AuthTextField(hintText: 'Wallet Name', textEditingController: _nameController, keyboardType: TextInputType.name),

                              Gap(20),

                              /* -------------------------- Account Type Dropdown ------------------------- */
                              DropdownButtonFormField<String>(
                                initialValue: _selectedAccountType,
                                hint: Text('Account Type', style: TextStyle(color: Colors.grey[400], fontSize: 16)),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey[300]!),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey[300]!),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Color(0xFF8B5CF6), width: 2),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                ),
                                items: _accountTypes.map((String type) {
                                  return DropdownMenuItem<String>(
                                    value: type,
                                    child: Text(type, style: const TextStyle(fontSize: 16, color: Colors.black87)),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedAccountType = newValue;
                                  });
                                },
                              ),

                              const SizedBox(height: 24),

                              /* ----------------------------- Continue Button ---------------------------- */
                              BlocListener<WalletBloc, WalletState>(
                                listener: (context, state) {
                                  if (state.isLoading) {
                                    isLoading.value = state.isLoading;
                                  } else if (state.errorMessage != null) {
                                  } else {
                                    context.push('/success-page');
                                  }
                                },
                                child: CustomFilledButton(
                                  onPressed: () {
                                    context.read<WalletBloc>().add(
                                      CreateWalletEvent(name: _nameController.text, accountType: _selectedAccountType ?? 'Bank', balance: 0.0),
                                    );
                                  },
                                  title: 'Continue',
                                ),
                              ),
                              Gap(8),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: isLoading,
            builder: (context, value, _) {
              return value ? LoadingIndicator() : SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
