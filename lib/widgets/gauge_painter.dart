import 'dart:math';
import 'package:flutter/material.dart';

class GaugePainter extends CustomPainter {
  final double value;
  final Color color;

  GaugePainter(this.value, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2.5;

    final background = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final foreground = Paint()
      ..color = color
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi,
      false,
      background,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi * value,
      false,
      foreground,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class GaugePainter2 extends CustomPainter {
  final int activeTicks;

  GaugePainter2(this.activeTicks);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2.5;

    const totalTicks = 12;

    const startAngle = -180 * pi / 180;
    const sweepAngle = 180 * pi / 180;

    final inactivePaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final activePaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < totalTicks; i++) {
      final angle = startAngle + (sweepAngle / (totalTicks - 1)) * i;

      final start = Offset(
        center.dx + cos(angle) * radius,
        center.dy + sin(angle) * radius,
      );

      final end = Offset(
        center.dx + cos(angle) * (radius + 12),
        center.dy + sin(angle) * (radius + 12),
      );

      canvas.drawLine(
        start,
        end,
        i < activeTicks ? activePaint : inactivePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant GaugePainter2 oldDelegate) {
    return oldDelegate.activeTicks != activeTicks;
  }
}
