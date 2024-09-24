class TimerState {
  final List<int> durations; // Daftar durasi untuk setiap timer
  final List<int> initialDurations; // Durasi awal dari setiap timer
  final List<bool> isPaused; // Status pause untuk setiap timer
  final bool isRunning;

  TimerState({
    required this.durations,
    required this.initialDurations,
    required this.isPaused,
    required this.isRunning,
  });

  TimerState copyWith({
    List<int>? durations,
    List<int>? initialDurations,
    List<bool>? isPaused,
    bool? isRunning,
  }) {
    return TimerState(
      durations: durations ?? this.durations,
      initialDurations: initialDurations ?? this.initialDurations,
      isPaused: isPaused ?? this.isPaused,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}
