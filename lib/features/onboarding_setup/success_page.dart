import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SuccessPage extends StatefulWidget {
  const SuccessPage({super.key});

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Scale animation for the checkmark
    _scaleController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);

    // Fade animation for the text
    _fadeController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut));

    // Start animations
    _scaleController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    context.go('/home-page');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _navigateToHome,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[50],
            child: Column(
              children: [
                // Main content
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Animated checkmark circle
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(color: Color(0xFF00C853), shape: BoxShape.circle),
                            child: const Icon(Icons.check, color: Colors.white, size: 40),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Animated text
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: const Text(
                            'You are set!',
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400, color: Color(0xFF1F1F1F), letterSpacing: -0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom indicator
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  width: 134,
                  height: 5,
                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(2.5)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
