import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skygoaltest/core/themes/app_theme.dart';
import 'package:skygoaltest/core/widgets/custom_app_bar.dart';

class CurrencySettings extends StatefulWidget {
  const CurrencySettings({super.key});

  @override
  State<CurrencySettings> createState() => _CurrencySettingsState();
}

class _CurrencySettingsState extends State<CurrencySettings> {
  String selectedCurrency = 'INR';
  
  final List<Map<String, String>> currencies = [
    {'name': 'India', 'code': 'INR'},
    {'name': 'United States', 'code': 'USD'},
    {'name': 'Indonesia', 'code': 'IDR'},
    {'name': 'Japan', 'code': 'JPY'},
    {'name': 'Russia', 'code': 'RUB'},
    {'name': 'Germany', 'code': 'EUR'},
    {'name': 'Korea', 'code': 'WON'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            title: 'Currency',
            onTap: () {
              context.pop();
            },
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.background(context),
                borderRadius: BorderRadius.circular(12),
              /*   boxShadow: [
                  BoxShadow(
                    // color: AppTheme.cardBackground(context).withOpacity(0.05),
                    blurRadius: 50,
                    offset: const Offset(0, 2),
                  ),
                ], */
              ),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: currencies.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: AppTheme.onBackground(context).withValues(alpha: 0.1),
                  indent: 16,
                  endIndent: 16,
                ),
                itemBuilder: (context, index) {
                  final currency = currencies[index];
                  final isSelected = selectedCurrency == currency['code'];
                  
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 4,
                    ),
                    title: Text(
                      '${currency['name']} (${currency['code']})',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.onBackground(context),
                      ),
                    ),
                    trailing: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey[400]!,
                          width: isSelected ? 6 : 2,
                        ),
                        color: isSelected ? Colors.blue : Colors.transparent,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        selectedCurrency = currency['code']!;
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}