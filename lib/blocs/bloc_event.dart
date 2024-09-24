abstract class TimerEvent {}

// Event untuk memulai timer
class TimerStarted extends TimerEvent {
  final int duration;

  TimerStarted(this.duration);
}

// Event untuk jeda timer
class TimerPaused extends TimerEvent {
  final int
      index; // Tambahkan index untuk mengidentifikasi timer mana yang dijeda
  TimerPaused(this.index);
}

// Event untuk melanjutkan timer yang dijeda
class TimerResumed extends TimerEvent {
  final int
      index; // Tambahkan index untuk mengidentifikasi timer mana yang dilanjutkan
  TimerResumed(this.index);
}

// Event untuk mereset timer
class TimerReset extends TimerEvent {
  final int
      index; // Tambahkan index untuk mengidentifikasi timer mana yang di-reset
  TimerReset(this.index);
}

// Event untuk mengupdate waktu (dipanggil setiap detik)
class TimerTicked extends TimerEvent {
  final int duration;
  final int
      index; // Tambahkan index untuk mengidentifikasi timer mana yang diperbarui
  TimerTicked(this.duration, this.index);
}

class TimerDeleted extends TimerEvent {
  final int index; // Untuk menunjukkan timer mana yang akan dihapus

  TimerDeleted(this.index);
}
