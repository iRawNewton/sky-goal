


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygoaltest/core/themes/app_theme.dart';
import 'package:skygoaltest/core/widgets/gap/gap_widget.dart';

import '../../core/utils/icon_mapper.dart';
import '../transaction/bloc/txn_bloc.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  static const List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  String selectedPeriod = 'Today';
  String selectedMonth = DateTime.now().month > 0 && DateTime.now().month <= 12
      ? _HomepageState.months[DateTime.now().month - 1]
      : 'January';

  @override
  void initState() {
    context.read<TxnBloc>().add(FetchAllTxnsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: SingleChildScrollView(
          // padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xffFFF6E5), Color(0x00EDD900), Color(0x00EDD900)],
                    begin: AlignmentGeometry.topCenter,
                    end: AlignmentGeometry.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    Gap(40),
                    /* --------------------------------- Header --------------------------------- */
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedMonth,
                            items: months.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(value: value, child: Text(value));
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  selectedMonth = newValue;
                                });
                              }
                            },
                            icon: const SizedBox.shrink(),
                            isDense: true,
                            elevation: 0,
                            selectedItemBuilder: (BuildContext context) {
                              return months.map<Widget>((String item) {
                                return Row(
                                  children: [
                                    const Icon(Icons.arrow_drop_down, color: Colors.black),
                                    const SizedBox(width: 4),
                                    Text(item),
                                  ],
                                );
                              }).toList();
                            },
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2))],
                          ),
                          child: const Icon(Icons.notifications_outlined, color: Color(0xFF6366F1)),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    /* ----------------------------- Account Balance ---------------------------- */
                    Center(
                      child: Column(
                        children: [
                          Text('Account Balance', style: TextStyle(fontSize: 14, color: AppTheme.textColor(context))),
                          const SizedBox(height: 8),
                          BlocBuilder<TxnBloc, TxnState>(
                            builder: (context, state) {
                              return Text(
                                '₹${state.totalIncome - state.totalExpense}',
                                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppTheme.textColor(context)),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    /* --------------------------- Income/Expense Cards -------------------------- */
                    BlocBuilder<TxnBloc, TxnState>(
                      buildWhen: (previous, current) => previous.totalIncome != current.totalIncome || previous.totalExpense != current.totalExpense,
                      builder: (context, state) {
                        Widget buildCard({required Color color, required IconData icon, required String label, required String value}) {
                          return Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                                    child: Icon(icon, color: Colors.white, size: 20),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
                                      Text(
                                        value,
                                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return Row(
                          children: [
                            buildCard(color: const Color(0xFF10B981), icon: Icons.arrow_downward, label: 'Income', value: '₹${state.totalIncome}'),
                            const SizedBox(width: 15),
                            buildCard(color: const Color(0xFFEF4444), icon: Icons.arrow_upward, label: 'Expenses', value: '₹${state.totalExpense}'),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 30),

                    /* --------------------------- Spend Frequency --------------------------- */
                    Text(
                      'Spend Frequency',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textColor(context)),
                    ),

                    const SizedBox(height: 20),

                    // Chart placeholder
                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2))],
                      ),
                      child: CustomPaint(painter: ChartPainter()),
                    ),

                    const SizedBox(height: 20),

                    // Time period selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: ['Today', 'Week', 'Month', 'Year'].map((period) {
                        return GestureDetector(
                          onTap: () => setState(() => selectedPeriod = period),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: selectedPeriod == period ? const Color(0xFFFFB020) : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              period,
                              style: TextStyle(
                                color: selectedPeriod == period ? Colors.white : Colors.grey[600],
                                fontWeight: selectedPeriod == period ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    /* ------------------------- Recent Transactions ------------------------- */
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Transaction',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textColor(context)),
                        ),
                        Text(
                          'See All',
                          style: TextStyle(color: AppTheme.violet100(context), fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    BlocBuilder<TxnBloc, TxnState>(
                      builder: (context, state) {
                        final txns = state.txnDataList;
                        return ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: txns.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 15),
                          itemBuilder: (context, index) {
                            final txn = txns[index];
                            final isExpense = txn?.type == 'expense';
                            final sign = isExpense ? '-' : '+';
                            final categoryType = getCategoryType(txn?.category ?? 'Others');
                            final icon = categoryIcons[categoryType] ?? Icons.category;
                            final iconColor = categoryColors[categoryType] ?? const Color(0xFF6366F1);
                            return _buildTransactionItem(
                              icon: icon,
                              iconColor: iconColor,
                              title: txn?.category ?? 'Shopping',
                              subtitle: txn?.description ?? '',
                              amount: '$sign ₹${txn?.amount ?? '0'}',
                              time: txn?.date != null ? TimeOfDay.fromDateTime(txn!.date).format(context) : '',
                              isExpense: isExpense,
                            );
                          },
                        );
                      },
                    ),

                    /*
                    Column(
                      children: [
                        _buildTransactionItem(
                          icon: Icons.shopping_cart,
                          iconColor: const Color(0xFFFFB020),
                          title: 'Shopping',
                          subtitle: 'Buy some grocery',
                          amount: '- ₹120',
                          time: '10:00 AM',
                          isExpense: true,
                        ),
                        const SizedBox(height: 15),
                        _buildTransactionItem(
                          icon: Icons.subscriptions,
                          iconColor: const Color(0xFF6366F1),
                          title: 'Subscription',
                          subtitle: 'Disney+ Annual...',
                          amount: '- ₹80',
                          time: '03:30 PM',
                          isExpense: true,
                        ),
                        const SizedBox(height: 15),
                        _buildTransactionItem(
                          icon: Icons.restaurant,
                          iconColor: const Color(0xFFEF4444),
                          title: 'Food',
                          subtitle: 'Buy a ramen',
                          amount: '- ₹32',
                          time: '07:30 PM',
                          isExpense: true,
                        ),
                        const SizedBox(height: 15),
                        _buildTransactionItem(
                          icon: Icons.local_gas_station,
                          iconColor: const Color(0xFF8B5CF6),
                          title: 'Transport',
                          subtitle: 'Fuel expense',
                          amount: '- ₹500',
                          time: '02:15 PM',
                          isExpense: true,
                        ),
                        const SizedBox(height: 15),
                        _buildTransactionItem(
                          icon: Icons.account_balance_wallet,
                          iconColor: const Color(0xFF10B981),
                          title: 'Salary',
                          subtitle: 'Monthly salary',
                          amount: '+ ₹25000',
                          time: '09:00 AM',
                          isExpense: false,
                        ),
                      ],
                    ),
*/
                    const SizedBox(height: 20), // Bottom padding
                  ],
                ),
              ),
            ],
          ),
        ),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:  TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textColor(context)),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isExpense ? const Color(0xFFEF4444) : const Color(0xFF10B981)),
              ),
              const SizedBox(height: 4),
              Text(time, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom painter for the chart
class ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF8B5CF6)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [const Color(0xFF8B5CF6).withValues(alpha: 0.3), const Color(0xFF8B5CF6).withValues(alpha: 0.05)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Create a simple wave pattern
    final path = Path();
    final fillPath = Path();

    final points = [
      Offset(0, size.height * 0.6),
      Offset(size.width * 0.2, size.height * 0.7),
      Offset(size.width * 0.4, size.height * 0.5),
      Offset(size.width * 0.6, size.height * 0.4),
      Offset(size.width * 0.8, size.height * 0.3),
      Offset(size.width, size.height * 0.2),
    ];

    path.moveTo(points[0].dx, points[0].dy);
    fillPath.moveTo(points[0].dx, points[0].dy);

    for (int i = 1; i < points.length; i++) {
      final controlPoint1 = Offset(points[i - 1].dx + (points[i].dx - points[i - 1].dx) / 3, points[i - 1].dy);
      final controlPoint2 = Offset(points[i].dx - (points[i].dx - points[i - 1].dx) / 3, points[i].dy);

      path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx, controlPoint2.dy, points[i].dx, points[i].dy);

      fillPath.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx, controlPoint2.dy, points[i].dx, points[i].dy);
    }

    // Complete the fill path
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    // Draw fill and stroke
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}



