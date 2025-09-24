import 'package:flutter/material.dart';

class AnimatedTweenWidget extends StatefulWidget {
  final Widget Function(int value) child;
  final IntTween tween;
  const AnimatedTweenWidget({super.key, required this.child, required this.tween});


  @override
  State<AnimatedTweenWidget> createState() => _AnimatedTweenWidgetState();
}

class _AnimatedTweenWidgetState extends State<AnimatedTweenWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Change the duration as needed
    );

    _animation = IntTween(begin: widget.tween.begin, end: widget.tween.end).animate(_controller)
      ..addListener(() {
        setState(() {}); // Rebuild the widget on every animation tick
      });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    _controller.forward(); // Start the animation
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when not needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child(_animation.value);
  }
}