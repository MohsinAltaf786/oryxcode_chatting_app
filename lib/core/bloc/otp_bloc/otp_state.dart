abstract class OtpTimerState {}

class OtpTimerInitial extends OtpTimerState {}

class OtpTimerRunning extends OtpTimerState {
  final int secondsRemaining;
  OtpTimerRunning(this.secondsRemaining);
}

class OtpTimerFinished extends OtpTimerState {}