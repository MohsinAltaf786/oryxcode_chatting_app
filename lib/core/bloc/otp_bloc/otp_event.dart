abstract class OtpTimerEvent {}

class StartOtpTimer extends OtpTimerEvent {
  final int seconds;
  StartOtpTimer(this.seconds);
}

class TickOtpTimer extends OtpTimerEvent {
  final int seconds;
  TickOtpTimer(this.seconds);
}