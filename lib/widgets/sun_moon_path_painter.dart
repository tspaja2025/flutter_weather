import 'package:flutter/material.dart';

class SunMoonPathPainter extends CustomPainter {
  final double progress;
  final Color color;

  SunMoonPathPainter(this.progress, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final pathPaint = Paint()
      ..color = Colors.white54
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final baselinePaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      baselinePaint,
    );

    final path = Path();
    path.moveTo(20, size.height - 8);
    path.quadraticBezierTo(size.width / 2, 8, size.width - 20, size.height - 8);
    canvas.drawPath(path, pathPaint);

    final dotPaint = Paint()..color = Colors.white54;
    canvas.drawCircle(Offset(20, size.height - 8), 3, dotPaint);
    canvas.drawCircle(Offset(size.width - 20, size.height - 8), 3, dotPaint);

    final metric = path.computeMetrics().first;
    final tangent = metric.getTangentForOffset(metric.length * progress)!;

    canvas.drawCircle(tangent.position, 10, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant SunMoonPathPainter oldDelegate) {
    return progress != oldDelegate.progress || color != oldDelegate.color;
  }
}
