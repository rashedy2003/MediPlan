import 'package:flutter/material.dart';

class BouncingFAB extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double size;

  const BouncingFAB({
    super.key,
    required this.onPressed,
    required this.child,
    this.size = 60,
  });

  @override
  State<BouncingFAB> createState() => _BouncingFABState();
}

class _BouncingFABState extends State<BouncingFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _glowAnimation = Tween<double>(begin: 4, end: 15)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xff1fa8f8), Color(0xff777373)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.6),
                  blurRadius: _glowAnimation.value,
                  spreadRadius: 1,
                )
              ],
            ),
            child: FloatingActionButton(
              onPressed: widget.onPressed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}
