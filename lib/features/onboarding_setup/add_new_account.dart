import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skygoaltest/core/themes/app_theme.dart';
import 'package:skygoaltest/core/widgets/custom_app_bar.dart';
import 'package:skygoaltest/core/widgets/custom_button.dart';
import 'package:skygoaltest/core/widgets/gap/gap_widget.dart';
import 'package:skygoaltest/features/authentication/widgets/auth_text_field.dart';

class AddNewAccount extends StatefulWidget {
  const AddNewAccount({super.key});

  @override
  State<AddNewAccount> createState() => _AddNewAccountState();
}

class _AddNewAccountState extends State<AddNewAccount> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedAccountType;

  final List<String> _accountTypes = ['Savings Account', 'Checking Account', 'Credit Card', 'Investment Account', 'Cash'];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: AppTheme.violet100(context)),
        child: SafeArea(
          bottom: true,
          child: Column(
            children: [
              /* --------------------------------- App Bar -------------------------------- */
              CustomAppBar(
                title: 'Add new account',
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
                  const Text(
                    '₹00.0',
                    style: TextStyle(color: Colors.white, fontSize: 64, fontWeight: FontWeight.w300),
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
                    child: Column(
                      children: [
                        const SizedBox(height: 24),

                        /* ---------------------------------- Name ---------------------------------- */
                        AuthTextField(hintText: 'Name', textEditingController: _nameController, keyboardType: TextInputType.name),

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

                        const Spacer(),

                        /* ----------------------------- Continue Button ---------------------------- */
                        CustomFilledButton(
                          onPressed: () {
                            context.push('/add-new-wallet');
                          },
                          title: 'Continue',
                        ),
                        Gap(8),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
