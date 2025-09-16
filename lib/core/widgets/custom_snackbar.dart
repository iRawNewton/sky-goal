import 'package:flutter/material.dart';

import '../themes/app_theme.dart';

enum CustomSnackBarType { success, info, danger, warning }

enum CustomSnackBarPosition { topLeft, topCenter, topRight, bottomLeft, bottomCenter, bottomRight }

class CustomSnackBarConfig {
  final String title;
  final String? subtitle;
  final CustomSnackBarType type;
  final bool showCloseButton;
  final double? width;
  final double height;
  final CustomSnackBarPosition position;
  final Duration duration;
  final VoidCallback? onDismissed;

  const CustomSnackBarConfig({
    required this.title,
    this.subtitle,
    required this.type,
    this.showCloseButton = false,
    this.width,
    this.height = 48.0,
    this.position = CustomSnackBarPosition.topCenter,
    this.duration = const Duration(seconds: 4),
    this.onDismissed,
  });
}

class CustomSnackBarManager {
  static final CustomSnackBarManager _instance = CustomSnackBarManager._internal();
  factory CustomSnackBarManager() => _instance;
  CustomSnackBarManager._internal();

  final List<OverlayEntry> _overlayEntries = [];
  static const int maxSnackBars = 5;
  bool allowMultipleSnackBars = true;

  void show(BuildContext context, CustomSnackBarConfig config) {
    if (!allowMultipleSnackBars && _overlayEntries.isNotEmpty) {
      dismissAll();
    }

    if (_overlayEntries.length >= maxSnackBars) {
      _removeOldest();
    }

    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _CustomSnackBarWidget(
        config: config,
        overlayEntry: overlayEntry,
        manager: this,
        onDismiss: () {
          _removeEntry(overlayEntry);
          config.onDismissed?.call();
        },
      ),
    );

    _overlayEntries.add(overlayEntry);
    Overlay.of(context).insert(overlayEntry);

    Future.delayed(config.duration, () {
      if (_overlayEntries.contains(overlayEntry)) {
        _removeEntry(overlayEntry);
        config.onDismissed?.call();
      }
    });
  }

  void _removeEntry(OverlayEntry entry) {
    if (_overlayEntries.contains(entry)) {
      entry.remove();
      _overlayEntries.remove(entry);
      _updatePositions();
    }
  }

  void _removeOldest() {
    if (_overlayEntries.isNotEmpty) {
      final oldest = _overlayEntries.first;
      _removeEntry(oldest);
    }
  }

  void _updatePositions() {
    for (final entry in _overlayEntries) {
      entry.markNeedsBuild();
    }
  }

  int getIndexOf(OverlayEntry entry) {
    return _overlayEntries.indexOf(entry);
  }

  int get entriesCount => _overlayEntries.length;

  void dismissAll() {
    final entries = List<OverlayEntry>.from(_overlayEntries);
    for (final entry in entries) {
      _removeEntry(entry);
    }
  }
}

class _CustomSnackBarWidget extends StatefulWidget {
  final CustomSnackBarConfig config;
  final OverlayEntry overlayEntry;
  final CustomSnackBarManager manager;
  final VoidCallback onDismiss;

  const _CustomSnackBarWidget({required this.config, required this.overlayEntry, required this.manager, required this.onDismiss});

  @override
  State<_CustomSnackBarWidget> createState() => _CustomSnackBarWidgetState();
}

class _CustomSnackBarWidgetState extends State<_CustomSnackBarWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getBackgroundColor() {
    return AppTheme.background(context).withValues(alpha: 0.3);
  }

  Color _getTextColor() {
    return AppTheme.textColor(context);
  }

  Color _getIconColor() {
    switch (widget.config.type) {
      case CustomSnackBarType.success:
        return AppTheme.successColor(context);
      case CustomSnackBarType.info:
        return AppTheme.infoColor(context);
      case CustomSnackBarType.danger:
        return AppTheme.errorColor(context);
      case CustomSnackBarType.warning:
        return AppTheme.warningColor(context);
    }
  }

  Color _getAccentColor() {
    switch (widget.config.type) {
      case CustomSnackBarType.success:
        return AppTheme.successColor(context);
      case CustomSnackBarType.info:
        return AppTheme.infoColor(context);
      case CustomSnackBarType.danger:
        return AppTheme.errorColor(context);
      case CustomSnackBarType.warning:
        return AppTheme.warningColor(context);
    }
  }

  IconData _getIcon() {
    switch (widget.config.type) {
      case CustomSnackBarType.success:
        return Icons.check_circle;
      case CustomSnackBarType.info:
        return Icons.info;
      case CustomSnackBarType.danger:
        return Icons.error;
      case CustomSnackBarType.warning:
        return Icons.warning;
    }
  }

  Alignment _getAlignment() {
    switch (widget.config.position) {
      case CustomSnackBarPosition.topLeft:
        return Alignment.topLeft;
      case CustomSnackBarPosition.topCenter:
        return Alignment.topCenter;
      case CustomSnackBarPosition.topRight:
        return Alignment.topRight;
      case CustomSnackBarPosition.bottomLeft:
        return Alignment.bottomLeft;
      case CustomSnackBarPosition.bottomCenter:
        return Alignment.bottomCenter;
      case CustomSnackBarPosition.bottomRight:
        return Alignment.bottomRight;
    }
  }

  EdgeInsets _getMargin() {
    const double bottomPadding = 10.0;
    const double sidePadding = 16.0;
    final double snackBarSpacing = widget.config.height + 8.0;

    final int currentIndex = widget.manager.getIndexOf(widget.overlayEntry);
    final int totalEntries = widget.manager.entriesCount;

    final int safeIndex = currentIndex >= 0 ? currentIndex : 0;
    final int reversedIndex = totalEntries > 0 ? (totalEntries - 1 - safeIndex).clamp(0, totalEntries - 1) : 0;
    final double stackOffset = reversedIndex * snackBarSpacing;

    switch (widget.config.position) {
      case CustomSnackBarPosition.topLeft:
      case CustomSnackBarPosition.topCenter:
      case CustomSnackBarPosition.topRight:
        return EdgeInsets.only(top: sidePadding + stackOffset, left: sidePadding, right: sidePadding);
      case CustomSnackBarPosition.bottomLeft:
      case CustomSnackBarPosition.bottomCenter:
      case CustomSnackBarPosition.bottomRight:
        return EdgeInsets.only(bottom: bottomPadding + stackOffset, left: sidePadding, right: sidePadding);
    }
  }

  void _dismiss() {
    _animationController.reverse().then((_) {
      widget.onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: _getAlignment(),
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Container(
            margin: _getMargin(),
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: widget.config.width ?? 400,
                    constraints: BoxConstraints(minHeight: widget.config.height, maxHeight: widget.config.height, maxWidth: 600),
                    decoration: BoxDecoration(
                      color: _getBackgroundColor(),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0),
                        bottomLeft: Radius.circular(5.0),
                        bottomRight: Radius.circular(5.0),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(_getIcon(), color: _getIconColor(), size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: widget.config.subtitle == null ? MainAxisAlignment.center : MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        widget.config.title,
                                        style: TextStyle(color: _getTextColor(), fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600),
                                      ),
                                      if (widget.config.subtitle != null) ...[
                                        const SizedBox(height: 1),
                                        Text(
                                          widget.config.subtitle!,
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: _getTextColor().withValues(alpha: 0.8),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                if (widget.config.showCloseButton) ...[
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: _dismiss,
                                    child: Container(
                                      padding: const EdgeInsets.all(2),

                                      child: Icon(Icons.close, color: _getTextColor(), size: 16),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 1.0),
                            child: Container(
                              height: 10,
                              decoration: BoxDecoration(
                                color: _getAccentColor().withValues(alpha: 1),
                                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(7.0), bottomRight: Radius.circular(7.0)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomSnackBar {
  static void show(BuildContext context, CustomSnackBarConfig config) {
    CustomSnackBarManager().show(context, config);
  }

  static void setAllowMultiple(bool allow) {
    CustomSnackBarManager().allowMultipleSnackBars = allow;
  }

  static void success(
    BuildContext context, {
    required String title,
    String? subtitle,
    bool showCloseButton = false,
    double? width,
    double height = 48.0,
    CustomSnackBarPosition position = CustomSnackBarPosition.topCenter,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onDismissed,
  }) {
    show(
      context,
      CustomSnackBarConfig(
        title: title,
        subtitle: subtitle,
        type: CustomSnackBarType.success,
        showCloseButton: showCloseButton,
        width: width,
        height: height,
        position: position,
        duration: duration,
        onDismissed: onDismissed,
      ),
    );
  }

  static void info(
    BuildContext context, {
    required String title,
    String? subtitle,
    bool showCloseButton = false,
    double? width,
    double height = 48.0,
    CustomSnackBarPosition position = CustomSnackBarPosition.topCenter,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onDismissed,
  }) {
    show(
      context,
      CustomSnackBarConfig(
        title: title,
        subtitle: subtitle,
        type: CustomSnackBarType.info,
        showCloseButton: showCloseButton,
        width: width,
        height: height,
        position: position,
        duration: duration,
        onDismissed: onDismissed,
      ),
    );
  }

  static void danger(
    BuildContext context, {
    required String title,
    String? subtitle,
    bool showCloseButton = false,
    double? width,
    double height = 48.0,
    CustomSnackBarPosition position = CustomSnackBarPosition.topCenter,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onDismissed,
  }) {
    show(
      context,
      CustomSnackBarConfig(
        title: title,
        subtitle: subtitle,
        type: CustomSnackBarType.danger,
        showCloseButton: showCloseButton,
        width: width,
        height: height,
        position: position,
        duration: duration,
        onDismissed: onDismissed,
      ),
    );
  }

  static void warning(
    BuildContext context, {
    required String title,
    String? subtitle,
    bool showCloseButton = false,
    double? width,
    double height = 48.0,
    CustomSnackBarPosition position = CustomSnackBarPosition.topCenter,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onDismissed,
  }) {
    show(
      context,
      CustomSnackBarConfig(
        title: title,
        subtitle: subtitle,
        type: CustomSnackBarType.warning,
        showCloseButton: showCloseButton,
        width: width,
        height: height,
        position: position,
        duration: duration,
        onDismissed: onDismissed,
      ),
    );
  }

  static void dismissAll() {
    CustomSnackBarManager().dismissAll();
  }
}
