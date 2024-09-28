import 'package:flutter/material.dart';
import 'dart:async';

import 'circular_progess_indicator.dart'; // CircularProgressIndicatorCustom yang sudah Anda buat

class CircularProgressWidget extends StatefulWidget {
  final double progress; // Dari 0.0 ke 1.0, mengontrol progress
  final String
      durationText; // Text yang akan ditampilkan di tengah (seperti durasi waktu)

  const CircularProgressWidget({
    Key? key,
    required this.progress, // Progress harus diberikan
    required this.durationText, // Text harus diberikan
  }) : super(key: key);

  @override
  _CircularProgressWidgetState createState() => _CircularProgressWidgetState();
}

class _CircularProgressWidgetState extends State<CircularProgressWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    // Dapatkan durasi dari teks, misalnya "10 detik"
    final int totalDurationInSeconds =
        int.parse(widget.durationText.split(' ')[0]);

    // Inisialisasi AnimationController dengan durasi berbasis progress
    _controller = AnimationController(
      vsync: this,
      duration:
          Duration(seconds: (totalDurationInSeconds * widget.progress).toInt()),
    );

    // Memulai animasi
    _controller.forward();

    // Opsional: Menggunakan Timer untuk memperbarui UI setiap detik jika dibutuhkan
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        // Perbarui UI setiap detik jika dibutuhkan
      });

      if (timer.tick >= totalDurationInSeconds) {
        // Hentikan timer setelah durasi selesai
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel(); // Hentikan timer ketika widget dihapus
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: 200.0,
          height: 200.0,
          child: CustomPaint(
            painter: CircularProgressIndicatorCustom(
              progress: _controller.value,
              backgroundColor: Colors.grey,
              progressColor: Colors.blue,
            ),
            child: Center(
              child: Text(
                widget.durationText, // Teks ditampilkan di tengah lingkaran
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
