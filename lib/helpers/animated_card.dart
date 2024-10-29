import 'package:flutter/material.dart';

class AnimatedCard extends StatelessWidget {
  final Color color;
  final Widget child;

  const AnimatedCard({super.key, required this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        onTap: () {
          // Animation or other action on tap
        },
        child: child,
      ),
    );
  }
}
