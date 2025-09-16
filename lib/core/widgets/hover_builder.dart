import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Customizable hover builder widget for Flutter web
/// that provides hover state management and cursor customization.
class HoverBuilder extends StatefulWidget {
  /// Builder function that provides the current hover state
  final Widget Function(bool isHovered) builder;

  /// Cursor type when hovering over the widget
  final SystemMouseCursor cursor;

  /// Whether the hover effect is enabled
  final bool enabled;

  /// Optional callback when hover state changes
  final ValueChanged<bool>? onHoverChanged;

  /// Duration for hover animations (useful for animated transitions)
  final Duration? animationDuration;

  /// Whether to use ink splash effect on hover (similar to Material buttons)
  final bool useInkWell;

  /// Splash color for ink effect (only works when useInkWell is true)
  final Color? splashColor;

  /// Highlight color for ink effect (only works when useInkWell is true)
  final Color? highlightColor;

  /// Border radius for ink effect (only works when useInkWell is true)
  final BorderRadius? borderRadius;

  /// Custom shape for ink effect (only works when useInkWell is true)
  final ShapeBorder? customBorder;

  /// Whether to exclude this widget from semantics
  final bool excludeFromSemantics;

  /// Optional tap callback
  final VoidCallback? onTap;

  /// Optional double tap callback
  final VoidCallback? onDoubleTap;

  /// Optional long press callback
  final VoidCallback? onLongPress;

  const HoverBuilder({
    super.key,
    required this.builder,
    this.cursor = SystemMouseCursors.basic,
    this.enabled = true,
    this.onHoverChanged,
    this.animationDuration,
    this.useInkWell = false,
    this.splashColor,
    this.highlightColor,
    this.borderRadius,
    this.customBorder,
    this.excludeFromSemantics = false,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
  });

  @override
  State<HoverBuilder> createState() => _HoverBuilderState();
}

class _HoverBuilderState extends State<HoverBuilder> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    if (widget.animationDuration != null) {
      _animationController = AnimationController(duration: widget.animationDuration, vsync: this);
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void _handleHover(bool hovering) {
    if (!widget.enabled) return;

    if (_isHovered != hovering) {
      setState(() {
        _isHovered = hovering;
      });

      // Trigger animation if provided
      if (_animationController != null) {
        if (hovering) {
          _animationController!.forward();
        } else {
          _animationController!.reverse();
        }
      }

      // Notify parent of hover state change
      widget.onHoverChanged?.call(hovering);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child = widget.builder(_isHovered);

    // Wrap with animation builder if animation is enabled
    if (_animationController != null) {
      child = AnimatedBuilder(animation: _animationController!, builder: (context, _) => child);
    }

    // Apply mouse cursor
    child = MouseRegion(
      cursor: widget.enabled ? widget.cursor : SystemMouseCursors.basic,
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: child,
    );

    // Add ink effect if requested
    if (widget.useInkWell) {
      child = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          onDoubleTap: widget.onDoubleTap,
          onLongPress: widget.onLongPress,
          splashColor: widget.splashColor,
          highlightColor: widget.highlightColor,
          borderRadius: widget.borderRadius,
          customBorder: widget.customBorder,
          excludeFromSemantics: widget.excludeFromSemantics,
          child: child,
        ),
      );
    } else if (widget.onTap != null || widget.onDoubleTap != null || widget.onLongPress != null) {
      // Add gesture detection without ink effect
      child = GestureDetector(onTap: widget.onTap, onDoubleTap: widget.onDoubleTap, onLongPress: widget.onLongPress, child: child);
    }

    return child;
  }
}

/// Extension to provide common cursor types for easy access
extension HoverCursors on SystemMouseCursor {
  static const SystemMouseCursor pointer = SystemMouseCursors.click;
  static const SystemMouseCursor grab = SystemMouseCursors.grab;
  static const SystemMouseCursor grabbing = SystemMouseCursors.grabbing;
  static const SystemMouseCursor text = SystemMouseCursors.text;
  static const SystemMouseCursor move = SystemMouseCursors.move;
  static const SystemMouseCursor resize = SystemMouseCursors.resizeUpDown;
  static const SystemMouseCursor wait = SystemMouseCursors.wait;
  static const SystemMouseCursor help = SystemMouseCursors.help;
  static const SystemMouseCursor forbidden = SystemMouseCursors.forbidden;
}

/// Animated version of HoverBuilder that provides built-in animation support
class AnimatedHoverBuilder extends StatefulWidget {
  /// Builder function that provides the current hover state and animation value
  final Widget Function(bool isHovered, double animationValue) builder;

  /// Animation duration
  final Duration duration;

  /// Animation curve
  final Curve curve;

  /// Cursor type when hovering over the widget
  final SystemMouseCursor cursor;

  /// Whether the hover effect is enabled
  final bool enabled;

  /// Optional callback when hover state changes
  final ValueChanged<bool>? onHoverChanged;

  const AnimatedHoverBuilder({
    super.key,
    required this.builder,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeInOut,
    this.cursor = SystemMouseCursors.basic,
    this.enabled = true,
    this.onHoverChanged,
  });

  @override
  State<AnimatedHoverBuilder> createState() => _AnimatedHoverBuilderState();
}

class _AnimatedHoverBuilderState extends State<AnimatedHoverBuilder> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleHover(bool hovering) {
    if (!widget.enabled) return;

    if (_isHovered != hovering) {
      setState(() {
        _isHovered = hovering;
      });

      if (hovering) {
        _controller.forward();
      } else {
        _controller.reverse();
      }

      widget.onHoverChanged?.call(hovering);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.enabled ? widget.cursor : SystemMouseCursors.basic,
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return widget.builder(_isHovered, _animation.value);
        },
      ),
    );
  }
}

// Example usage widgets to demonstrate the functionality
class HoverBuilderExamples extends StatelessWidget {
  const HoverBuilderExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic usage example
            const Text('Basic Hover Effect:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            HoverBuilder(
              cursor: SystemMouseCursors.click,
              builder: (isHovered) {
                return Container(
                  width: 200,
                  height: 100,
                  decoration: BoxDecoration(color: isHovered ? Colors.red : Colors.amber, borderRadius: BorderRadius.circular(8)),
                  child: const Center(child: Text('Hover me!')),
                );
              },
            ),

            const SizedBox(height: 32),

            // Animated hover example
            const Text('Animated Hover Effect:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            AnimatedHoverBuilder(
              cursor: SystemMouseCursors.grab,
              duration: const Duration(milliseconds: 300),
              builder: (isHovered, animationValue) {
                return Transform.scale(
                  scale: 1.0 + (animationValue * 0.1),
                  child: Container(
                    width: 200,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color.lerp(Colors.blue, Colors.purple, animationValue),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5 + (animationValue * 15),
                          offset: Offset(0, 2 + (animationValue * 8)),
                          color: Colors.black.withValues(alpha: 0.1 + (animationValue * 0.2)),
                        ),
                      ],
                    ),
                    child: const Center(child: Text('Animated hover!')),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            // Ink effect example
            const Text('Ink Effect Hover:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            HoverBuilder(
              useInkWell: true,
              cursor: SystemMouseCursors.click,
              borderRadius: BorderRadius.circular(8),
              splashColor: Colors.orange.withValues(alpha: 0.3),
              builder: (isHovered) {
                return Container(
                  width: 200,
                  height: 100,
                  decoration: BoxDecoration(
                    color: isHovered ? Colors.green.shade100 : Colors.green.shade50,
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(child: Text('Click me!')),
                );
              },
            ),
          ],
        ),
      );
   
  }
}
