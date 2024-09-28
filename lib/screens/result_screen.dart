import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:timer_app/constants/app_colors.dart';
import 'package:timer_app/screens/widgets/circular_proses_widget.dart';

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
          if (state.durations.isEmpty) {
            return Center(
              child: Text(
                'Belum Ada Timer',
                style: TextStyle(color: AppColors.white),
              ),
            );
          }

          return ListView.builder(
            itemCount: state.durations.length,
            itemBuilder: (context, index) {
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
                            onPressed: () {},
                            icon: Icon(
                              Icons.clear,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    CircularProgressWidget(
                      progress: 1,
                      durationText: '${state.durations[index]} detik',
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
