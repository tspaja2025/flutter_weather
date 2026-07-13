import 'package:flutter/material.dart';

class SunMoonPathPainter extends CustomPainter {
  final double startProgress;
  final double endProgress;
  final Color color;

  SunMoonPathPainter(this.startProgress, this.endProgress, this.color);

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
    final startTangent = metric.getTangentForOffset(
      metric.length * startProgress.clamp(0.0, 1.0),
    );
    final endTangent = metric.getTangentForOffset(
      metric.length * endProgress.clamp(0.0, 1.0),
    );

    if (startTangent != null) {
      canvas.drawCircle(
        startTangent.position,
        10,
        Paint()..color = Colors.amber,
      );
    }

    if (endTangent != null) {
      canvas.drawCircle(endTangent.position, 10, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant SunMoonPathPainter oldDelegate) {
    return startProgress != oldDelegate.startProgress ||
        endProgress != oldDelegate.endProgress ||
        color != oldDelegate.color;
  }
}
