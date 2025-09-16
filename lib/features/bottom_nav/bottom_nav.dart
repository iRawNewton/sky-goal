import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skygoaltest/core/themes/app_theme.dart';

import '../home/homepage.dart';
import '../transaction/presentation/txn_list.dart';
import '../profile/profile_page.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Transaction', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Budget', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select Type', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: Size(120, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: Icon(Icons.arrow_upward),
                    label: Text('Income'),
                    onPressed: () {
                      context.push('/record-income');
                      context.pop();
                    },
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      minimumSize: Size(120, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: Icon(Icons.arrow_downward),
                    label: Text('Expense'),
                    onPressed: () {
                      context.push('/record-expense');
                      context.pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
    /* setState(() {
      _isExpanded = !_isExpanded;
    });
    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    } */
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _getPage(),
        bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: _selectedIndex,
          isExpanded: _isExpanded,
          animation: _animation,
          onItemTapped: (index) {
            setState(() {
              _selectedIndex = index;
              _isExpanded = false;
            });
            _animationController.reverse();
          },
          onCenterTapped: _toggleExpansion,
        ),
      ),
    );
  }

  Widget _getPage() {
    switch (_selectedIndex) {
      case 0:
        return Homepage();
      case 1:
        return TxnList();
      case 2:
        return BudgetPage();
      case 3:
        return ProfilePage();
      default:
        return Homepage();
    }
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final bool isExpanded;
  final Animation<double> animation;
  final Function(int) onItemTapped;
  final VoidCallback onCenterTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.isExpanded,
    required this.animation,
    required this.onItemTapped,
    required this.onCenterTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 80,
          decoration: BoxDecoration(
            color: AppTheme.cardBackground(context),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: Offset(0, -5))],
          ),
          child: ClipPath(
            clipper: BottomNavClipper(),
            child: Container(
              height: 80,
              color: AppTheme.cardBackground(context),
              child: Row(
                children: [
                  _buildNavItem(Icons.home, 0),
                  _buildNavItem(Icons.receipt_long, 1),
                  Expanded(flex: 2, child: Container()),
                  _buildNavItem(Icons.pie_chart, 2),
                  _buildNavItem(Icons.person, 3),
                ],
              ),
            ),
          ),
        ),
        // Center button
        Positioned(
          left: MediaQuery.of(context).size.width / 2 - 30,
          top: -15,
          child: GestureDetector(
            onTap: onCenterTapped,
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: animation.value * 0.785398, // 45 degrees in radians
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [Color(0xFF6C5CE7), Color(0xFF5A4FCF)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      boxShadow: [BoxShadow(color: Color(0xFF6C5CE7).withValues(alpha: 0.4), blurRadius: 15, offset: Offset(0, 8))],
                    ),
                    child: Icon(isExpanded ? Icons.close : Icons.add, color: Colors.white, size: 30),
                  ),
                );
              },
            ),
          ),
        ),
        // Horizontal Buttons (Left and Right of Center)
        if (isExpanded) ...[
          // LEFT (Up Arrow - Income)
          AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Positioned(
                left: MediaQuery.of(context).size.width / 2 - 25 - (80 * animation.value),
                top: -70,
                child: Transform.scale(
                  scale: animation.value,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                        boxShadow: [BoxShadow(color: Colors.green.withValues(alpha: 0.4), blurRadius: 10, offset: Offset(0, 5))],
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25),
                        onTap: () {
                          print('Income button tapped');
                        },
                        child: Center(child: Icon(Icons.arrow_upward, color: Colors.white, size: 24)),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          // RIGHT (Down Arrow - Expense)
          AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Positioned(
                left: MediaQuery.of(context).size.width / 2 - 25 + (80 * animation.value),
                top: -70,
                child: Transform.scale(
                  scale: animation.value,
                  child: GestureDetector(
                    onTap: () {
                      print('Expense button tapped');
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                        boxShadow: [BoxShadow(color: Colors.red.withValues(alpha: 0.4), blurRadius: 10, offset: Offset(0, 5))],
                      ),
                      child: Icon(Icons.arrow_downward, color: Colors.white, size: 24),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    bool isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onItemTapped(index),
        child: SizedBox(
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? Color(0xFF6C5CE7) : Colors.grey[400], size: 24),
              SizedBox(height: 4),
              Text(
                _getLabel(index),
                style: TextStyle(
                  color: isSelected ? Color(0xFF6C5CE7) : Colors.grey[400],
                  fontSize: 8,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLabel(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Transaction';
      case 2:
        return 'Budget';
      case 3:
        return 'Profile';
      default:
        return 'Home';
    }
  }
}

class BottomNavClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, 0);
    path.lineTo(size.width * 0.35, 0);

    // Create curve for center button
    path.quadraticBezierTo(size.width * 0.4, 0, size.width * 0.4, 20);
    path.arcToPoint(Offset(size.width * 0.6, 20), radius: Radius.circular(20), clockwise: false);
    path.quadraticBezierTo(size.width * 0.6, 0, size.width * 0.65, 0);

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
