import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:timer_app/constants/app_colors.dart';

import '../blocs/bloc_event.dart';
import '../blocs/timer_bloc.dart';
import '../blocs/timer_state.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // Kembali ke HomeScreen
          },
          icon: Icon(
            Icons.arrow_back,
            size: 22,
            color: AppColors.white,
          ),
        ),
      ),
      backgroundColor: AppColors.primary,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: EdgeInsets.all(22),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.secondary,
        ),
        child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.add,
            color: AppColors.white,
          ),
        ),
      ),
      body: BlocBuilder<TimerBloc, TimerState>(
        builder: (context, state) {
          // Periksa apakah ada timer yang sedang berjalan
          if (state.durations.isEmpty) {
            return Center(
              child: Text(
                'No timers running',
                style: TextStyle(color: AppColors.white),
              ),
            );
          }

          // Menampilkan daftar timer
          return ListView.builder(
            itemCount: state.durations.length,
            itemBuilder: (context, index) {
              final duration = state.durations[index];
              final hours = (duration ~/ 3600).toString().padLeft(2, '0');
              final minutes =
                  ((duration % 3600) ~/ 60).toString().padLeft(2, '0');
              final seconds = (duration % 60).toString().padLeft(2, '0');

              final totalDurationInMillis = (duration) * 1000;
              String formattedDuration(int duration) {
                if (duration >= 0) {
                  // Timer masih berjalan atau habis tepat di 0
                  final hours = (duration ~/ 3600).toString().padLeft(2, '0');
                  final minutes =
                      ((duration % 3600) ~/ 60).toString().padLeft(2, '0');
                  final seconds = (duration % 60).toString().padLeft(2, '0');

                  // Jika durasi lebih dari atau sama dengan 1 jam, tampilkan "hh:mm:ss"
                  if (duration >= 3600) {
                    return "$hours:$minutes:$seconds";
                  }
                  // Jika kurang dari 1 jam, tampilkan hanya "mm:ss"
                  else if (duration >= 60) {
                    return "$minutes:$seconds";
                  }
                  // Jika hanya beberapa detik yang tersisa
                  else {
                    return "00:$seconds";
                  }
                } else {
                  final negativeDuration = duration.abs();
                  final minutes =
                      (negativeDuration ~/ 60).toString().padLeft(2, '0');
                  final seconds =
                      (negativeDuration % 60).toString().padLeft(2, '0');

                  return "-$minutes:$seconds";
                }
              }

              return Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: state.durations[index] <= 0
                      ? Colors.red
                      : AppColors.secondary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Timer ${index + 1}',
                          style: TextStyle(
                            fontSize: 22,
                            color: AppColors.white,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                          child: IconButton(
                            onPressed: () {
                              // Aksi untuk menghapus timer ini (implementasi bisa ditambahkan)
                            },
                            icon: Icon(
                              Icons.clear,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    CircularPercentIndicator(
                      radius: 130.0,
                      animation: true,
                      // Ensure the animationDuration is positive
                      animationDuration:
                          totalDurationInMillis > 0 ? totalDurationInMillis : 1,
                      lineWidth: 15.0,
                      // Ensure percent is between 0 and 1
                      percent: 1,
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            formattedDuration(state.durations[index]),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: AppColors.white,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.lock_reset,
                              color: AppColors.white,
                            ),
                            onPressed: () {
                              // Aksi reset timer
                              context.read<TimerBloc>().add(TimerReset(index));
                            },
                          ),
                        ],
                      ),
                      circularStrokeCap: CircularStrokeCap.butt,
                      backgroundColor: AppColors.primary,
                      progressColor: AppColors.white,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: state.durations[index] <= 0
                            ? Colors.redAccent
                            : Colors.greenAccent,
                      ),
                      child: IconButton(
                        onPressed: () {
                          if (state.durations[index] <= 0) {
                            // Jika waktu sudah habis, hapus timer
                            context.read<TimerBloc>().add(TimerDeleted(index));
                          } else {
                            // Pause atau resume timer
                            if (state.isPaused[index]) {
                              context
                                  .read<TimerBloc>()
                                  .add(TimerResumed(index));
                            } else {
                              context.read<TimerBloc>().add(TimerPaused(index));
                            }
                          }
                        },
                        icon: Icon(
                          state.durations[index] <= 0
                              ? Icons
                                  .clear // Tampilkan ikon clear jika waktu habis
                              : (state.isPaused[index]
                                  ? Icons.play_arrow
                                  : Icons.pause),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
