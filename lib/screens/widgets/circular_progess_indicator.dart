import 'package:flutter/material.dart';

class CircularProgressIndicatorCustom extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;

  CircularProgressIndicatorCustom({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth =
        20.0; // Lebar dari garis (membuat lingkaran seperti donat)

    // Paint untuk background
    final Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke // Menggambar hanya garis luar
      ..strokeWidth = strokeWidth // Menentukan ketebalan "garis" donat
      ..strokeCap =
          StrokeCap.round; // Membuat ujung garis halus (bila diinginkan)

    // Paint untuk progress
    final Paint progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke // Menggambar hanya garis luar
      ..strokeWidth = strokeWidth // Ketebalan progress sama dengan background
      ..strokeCap = StrokeCap.round; // Ujung progress berbentuk bulat

    // Gambar lingkaran background
    canvas.drawCircle(
      size.center(Offset.zero),
      (size.width / 2) - (strokeWidth / 2),
      // Sesuaikan radius agar mempertimbangkan stroke width
      backgroundPaint,
    );

    // Gambar progress (arc)
    double sweepAngle = 2 * 3.141592653589793 * progress;
    canvas.drawArc(
      Rect.fromCircle(
        center: size.center(Offset.zero),
        radius: (size.width / 2) - (strokeWidth / 2),
      ),
      -3.141592653589793 / 2, // Mulai dari atas
      sweepAngle, // Sudut sesuai dengan progress
      false, // False karena kita ingin garis, bukan lingkaran penuh
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
