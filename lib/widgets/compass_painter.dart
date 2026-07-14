import 'dart:math';

import 'package:flutter/material.dart';

class CompassPainter extends CustomPainter {
  final String direction;

  CompassPainter(this.direction);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    final borderPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Compass circle
    canvas.drawCircle(center, radius - 2, borderPaint);

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    void drawLabel(String text, Offset offset) {
      textPainter.text = TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        offset - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }

    drawLabel('N', Offset(center.dx, 10));
    drawLabel('E', Offset(size.width - 10, center.dy));
    drawLabel('S', Offset(center.dx, size.height - 10));
    drawLabel('W', Offset(10, center.dy));

    final angle = _directionToRadians(direction);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);

    final arrowPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    // Shaft
    canvas.drawLine(Offset(0, 0), Offset(0, -radius + 18), arrowPaint);

    // Arrow head
    final path = Path()
      ..moveTo(0, -radius + 10)
      ..lineTo(-6, -radius + 22)
      ..lineTo(6, -radius + 22)
      ..close();

    canvas.drawPath(path, Paint()..color = Colors.blue);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CompassPainter oldDelegate) =>
      oldDelegate.direction != direction;

  double _directionToRadians(String dir) {
    const directions = {
      'N': 0,
      'NNE': 22.5,
      'NE': 45,
      'ENE': 67.5,
      'E': 90,
      'ESE': 112.5,
      'SE': 135,
      'SSE': 157.5,
      'S': 180,
      'SSW': 202.5,
      'SW': 225,
      'WSW': 247.5,
      'W': 270,
      'WNW': 292.5,
      'NW': 315,
      'NNW': 337.5,
    };

    final degress = directions[dir] ?? 0;
    return degress * pi / 180;
  }
}
