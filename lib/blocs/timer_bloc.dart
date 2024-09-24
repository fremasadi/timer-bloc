import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer_app/blocs/bloc_event.dart';
import 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  List<Timer?> _timers = []; // List untuk menyimpan semua Timer

  TimerBloc()
      : super(TimerState(
          durations: [],
          initialDurations: [],
          isPaused: [],
          isRunning: false,
        )) {
    on<TimerStarted>(_onStarted);
    on<TimerPaused>(_onPaused);
    on<TimerResumed>(_onResumed);
    on<TimerReset>(_onReset);
    on<TimerTicked>(_onTicked);
    on<TimerDeleted>(_onDeleted);
  }

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    if (event.duration <= 0) {
      print("Cannot start timer with non-positive duration");
      return; // Jangan lanjut jika durasi tidak valid
    }

    int index = state.durations.length;

    _timers.add(Timer.periodic(Duration(seconds: 1), (timer) {
      add(TimerTicked(event.duration - timer.tick, index));
    }));

    emit(state.copyWith(
      durations: List.from(state.durations)..add(event.duration),
      initialDurations: List.from(state.initialDurations)..add(event.duration),
      isPaused: List.from(state.isPaused)..add(false),
      isRunning: true,
    ));
  }

  void _onTicked(TimerTicked event, Emitter<TimerState> emit) {
    List<int> updatedDurations = List.from(state.durations);

    if (event.index < updatedDurations.length) {
      updatedDurations[event.index] = event.duration;
      emit(state.copyWith(durations: updatedDurations));
    }
  }

  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    _timers[event.index]?.cancel(); // Pause timer di index yang sesuai

    List<bool> updatedPaused = List.from(state.isPaused);
    updatedPaused[event.index] = true;

    emit(state.copyWith(isPaused: updatedPaused, isRunning: false));
  }

  void _onResumed(TimerResumed event, Emitter<TimerState> emit) {
    // Timer dilanjutkan di index yang sesuai
    _timers[event.index] = Timer.periodic(Duration(seconds: 1), (timer) {
      add(TimerTicked(state.durations[event.index] - timer.tick, event.index));
    });

    List<bool> updatedPaused = List.from(state.isPaused);
    updatedPaused[event.index] = false;

    emit(state.copyWith(isPaused: updatedPaused, isRunning: true));
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    _timers[event.index]?.cancel();

    // Reset durasi ke durasi awal
    List<int> updatedDurations = List.from(state.durations);
    updatedDurations[event.index] = state.initialDurations[event.index];

    emit(state.copyWith(durations: updatedDurations));
  }

  void _onDeleted(TimerDeleted event, Emitter<TimerState> emit) {
    if (event.index < _timers.length) {
      _timers[event.index]?.cancel();
      _timers.removeAt(event.index);

      List<int> updatedDurations = List.from(state.durations)
        ..removeAt(event.index);
      List<int> updatedInitialDurations = List.from(state.initialDurations)
        ..removeAt(event.index);
      List<bool> updatedPaused = List.from(state.isPaused)
        ..removeAt(event.index);

      emit(state.copyWith(
        durations: updatedDurations,
        initialDurations: updatedInitialDurations,
        isPaused: updatedPaused,
      ));
    }
  }

  @override
  Future<void> close() {
    // Hentikan semua timer saat bloc ditutup
    for (var timer in _timers) {
      timer?.cancel();
    }
    return super.close();
  }
}
