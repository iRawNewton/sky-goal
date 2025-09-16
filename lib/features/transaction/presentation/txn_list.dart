import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygoaltest/core/themes/app_theme.dart';
import '../bloc/txn_bloc.dart';
import '../model/txn_model.dart';

class TxnList extends StatefulWidget {
  const TxnList({super.key});

  @override
  State<TxnList> createState() => _TxnListState();
}

class _TxnListState extends State<TxnList> {
  String _selectedFilterBy = 'Expense';
  String _selectedSortBy = 'Newest';
  int _selectedCategories = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background(context),
      appBar: AppBar(
        backgroundColor: AppTheme.background(context),
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.keyboard_arrow_down, color: AppTheme.textColor(context)),
              const SizedBox(width: 4),
              Text('Month', style: AppTheme.bodyLarge(context)),
            ],
          ),
        ),
        leadingWidth: 100,
        actions: [
          IconButton(
            onPressed: () => _showFilterBottomSheet(),
            icon: Icon(Icons.tune, color: AppTheme.textColor(context)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppTheme.primaryLight, AppTheme.primary], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('See your financial report', style: AppTheme.bodyLarge(context).copyWith(fontWeight: FontWeight.w500)),
                  Icon(Icons.arrow_forward_ios, color: AppTheme.subtitleColor(context), size: 16),
                ],
              ),
            ),

            BlocBuilder<TxnBloc, TxnState>(
              builder: (context, state) {
                final txns = state.txnDataList;

                final Map<String, List<TransactionModel>> grouped = {};
                final now = DateTime.now();
                final today = DateTime(now.year, now.month, now.day);
                final yesterday = today.subtract(const Duration(days: 1));
                for (var txn in txns) {
                  if (txn == null || txn.createdAt == null) continue;
                  final created = DateTime(txn.createdAt.year, txn.createdAt.month, txn.createdAt.day);
                  String key;
                  if (created == today) {
                    key = 'Today';
                  } else if (created == yesterday) {
                    key = 'Yesterday';
                  } else {
                    key = '${created.day}/${created.month}/${created.year}';
                  }
                  grouped.putIfAbsent(key, () => []).add(txn);
                }

                final keys = grouped.keys.toList();
                keys.sort((a, b) {
                  if (a == 'Today') return -1;
                  if (b == 'Today') return 1;
                  if (a == 'Yesterday') return -1;
                  if (b == 'Yesterday') return 1;
                  DateTime da = a == 'Today'
                      ? today
                      : a == 'Yesterday'
                      ? yesterday
                      : _parseDateKey(a);
                  DateTime db = b == 'Today'
                      ? today
                      : b == 'Yesterday'
                      ? yesterday
                      : _parseDateKey(b);
                  return db.compareTo(da);
                });
                return Column(
                  children: [
                    for (final key in keys)
                      _buildDateSection(
                        key,
                        grouped[key]!.map((txn) {
                          final isExpense = txn.type == 'expense';
                          return _buildTransactionItem(
                            icon: Icons.category,
                            iconColor: isExpense ? AppTheme.error : AppTheme.success,
                            title: txn.category,
                            subtitle: txn.description,
                            amount: '${isExpense ? '-' : '+'}₹${txn.amount}',
                            time: txn.createdAt != null ? TimeOfDay.fromDateTime(txn.createdAt).format(context) : '',
                            isExpense: isExpense,
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 100),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  DateTime _parseDateKey(String key) {
    final parts = key.split('/');
    if (parts.length == 3) {
      return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
    }
    return DateTime.now();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filter Transaction',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                    ),
                    TextButton(
                      onPressed: () {
                        setModalState(() {
                          _selectedFilterBy = 'Expense';
                          _selectedSortBy = 'Newest';
                          _selectedCategories = 0;
                        });
                      },
                      child: const Text(
                        'Reset',
                        style: TextStyle(color: Colors.purple, fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Filter By',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _buildFilterChip('Income', _selectedFilterBy == 'Income', setModalState),
                          const SizedBox(width: 12),
                          _buildFilterChip('Expense', _selectedFilterBy == 'Expense', setModalState),
                          const SizedBox(width: 12),
                          _buildFilterChip('Transfer', _selectedFilterBy == 'Transfer', setModalState),
                        ],
                      ),

                      const SizedBox(height: 32),

                      const Text(
                        'Sort By',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _buildFilterChip('Highest', _selectedSortBy == 'Highest', setModalState, isSortBy: true),
                          _buildFilterChip('Lowest', _selectedSortBy == 'Lowest', setModalState, isSortBy: true),
                          _buildFilterChip('Newest', _selectedSortBy == 'Newest', setModalState, isSortBy: true),
                          _buildFilterChip('Oldest', _selectedSortBy == 'Oldest', setModalState, isSortBy: true),
                        ],
                      ),

                      const SizedBox(height: 32),

                      const Text(
                        'Category',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Choose Category', style: TextStyle(fontSize: 16, color: Colors.black87)),
                            Row(
                              children: [
                                Text('$_selectedCategories Selected', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 32),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {});
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text(
                            'Apply',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, StateSetter setModalState, {bool isSortBy = false}) {
    return GestureDetector(
      onTap: () {
        setModalState(() {
          if (isSortBy) {
            _selectedSortBy = label;
          } else {
            _selectedFilterBy = label;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(color: isSelected ? Colors.purple : Colors.grey[100], borderRadius: BorderRadius.circular(20)),
        child: Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: isSelected ? Colors.white : Colors.black87),
        ),
      ),
    );
  }

  Widget _buildDateSection(String date, List<Widget> transactions) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(date, style: AppTheme.titleSmall(context)),
          ),
          ...transactions,
        ],
      ),
    );
  }

  Widget _buildTransactionItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String amount,
    required String time,
    required bool isExpense,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground(context),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: AppTheme.borderColor(context).withOpacity(0.1), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTheme.bodyLarge(context).copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(subtitle, style: AppTheme.bodyMedium(context).copyWith(color: AppTheme.subtitleColor(context))),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: AppTheme.bodyLarge(context).copyWith(fontWeight: FontWeight.w600, color: isExpense ? AppTheme.error : AppTheme.success),
              ),
              const SizedBox(height: 4),
              Text(time, style: AppTheme.bodySmall(context)),
            ],
          ),
        ],
      ),
    );
  }
}
