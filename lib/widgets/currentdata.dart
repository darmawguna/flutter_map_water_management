import 'dart:math';

import 'package:flutter/material.dart';

class CurrentDataDiagram extends StatelessWidget {
  const CurrentDataDiagram({
    super.key,
    required this.percent,
    required this.label,
    this.barColor = Colors.red,
    this.backgroundColor = Colors.black12,
    this.height = 30,
  });
  final int percent;
  final String label;
  final Color barColor;
  final Color backgroundColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: max(30, height),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: ProgressPainter(
              percent: percent,
              backgroundColor: backgroundColor,
              barColor: barColor,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '   $percent%',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "$label    ",
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressPainter extends CustomPainter {
  final int percent;
  final Color barColor;
  final Color backgroundColor;
  ProgressPainter({
    required this.percent,
    this.barColor = Colors.red,
    this.backgroundColor = Colors.black26,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = backgroundColor;
    final progressPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = barColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);
    var belokan = (size.width * percent) / 100 - 30;
    if (belokan < 0) belokan = 0;
    final path = Path()
      ..lineTo(belokan, 0)
      ..lineTo((size.width * percent) / 100, size.height / 2)
      ..lineTo(belokan, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
