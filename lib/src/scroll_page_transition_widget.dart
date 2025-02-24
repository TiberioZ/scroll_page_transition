import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'scroll_page_transition_controller.dart';

class ScrollPageTransition extends StatefulWidget {
  const ScrollPageTransition({
    required this.primaryPage,
    required this.secondaryPage,
    this.scrollDirection,
    this.animationSpeed = 200,
    this.animationCurve = Curves.easeOutCubic,
    this.hapticFeedback = true,
    this.hapticFeedbackType = HapticsType.soft,
    this.reverse = true,
    this.swipeDistance = 50,
    this.maxBlur = 10.0,
    this.controller,
    super.key,
  });

  /// The default page to display.
  final Widget primaryPage;

  /// The secondary page to display during the transition.
  final Widget secondaryPage;

  /// The allowed scroll direction. If specified, only drags in that direction will be processed.
  /// Valid values: AxisDirection.up or AxisDirection.down.
  final AxisDirection? scrollDirection;

  /// The duration (in milliseconds) of the transition animation.
  final int animationSpeed;

  /// The animation curve for the transition.
  final Curve animationCurve;

  /// Enable haptic feedback during the transition.
  final bool hapticFeedback;

  /// The type of haptic feedback to use.
  final HapticsType hapticFeedbackType;

  /// If true, the transition will reverse when scrolling back.
  final bool reverse;

  /// The distance (in pixels) required to trigger the transition.
  final double swipeDistance;

  /// The maximum blur sigma to apply to the primary page during the transition.
  final double maxBlur;

  /// Optional controller to trigger open/close actions programmatically.
  final ScrollPageTransitionController? controller;

  @override
  ScrollPageTransitionState createState() => ScrollPageTransitionState();
}

class ScrollPageTransitionState extends State<ScrollPageTransition>
    with SingleTickerProviderStateMixin {
  double opacity = 0.0;
  double offsetY = 0.0;
  late AnimationController _controller;
  late Animation<double> _animation;
  double lastOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.animationSpeed),
    );
    _animation = Tween<double>(begin: 0.0, end: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {
          opacity = _animation.value;
        });
      });

    widget.controller?.attach(
      openSecondaryPage: () => animateToPosition(1.0),
      closeSecondaryPage: () => animateToPosition(0.0),
    );
  }

  void animateToPosition(double targetOpacity) {
    if (widget.hapticFeedback && targetOpacity != lastOpacity) {
      Haptics.vibrate(widget.hapticFeedbackType);
    }
    lastOpacity = targetOpacity;
    _animation = Tween<double>(begin: opacity, end: targetOpacity).animate(
      CurvedAnimation(parent: _controller, curve: widget.animationCurve),
    );
    _controller.forward(from: 0);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    // Ignore drag updates that are not in the specified direction.
    if (widget.scrollDirection == AxisDirection.down &&
            details.primaryDelta! < 0 ||
        widget.scrollDirection == AxisDirection.up &&
            details.primaryDelta! > 0) {
      return;
    }

    setState(() {
      offsetY += details.primaryDelta!;
      double newOpacity = (offsetY / widget.swipeDistance).abs().clamp(
        0.0,
        1.0,
      );
      opacity = newOpacity;
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    double targetOpacity = opacity >= 0.5 ? 1.0 : 0.0;
    animateToPosition(targetOpacity);
    offsetY = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: GestureDetector(
        onVerticalDragUpdate: _handleDragUpdate,
        onVerticalDragEnd: _handleDragEnd,
        child: Stack(
          children: [
            widget.primaryPage,
            // Apply a blur effect to the primary page based on opacity.
            if (opacity > 0)
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: opacity * widget.maxBlur,
                  sigmaY: opacity * widget.maxBlur,
                ),
                child: Container(color: Colors.transparent),
              ),
            // Secondary page fades in on top.
            Opacity(opacity: opacity, child: widget.secondaryPage),
          ],
        ),
      ),
    );
  }
}
