import 'dart:async';

import 'package:chat_flow/core/bloc/otp_bloc/otp_event.dart';
import 'package:chat_flow/core/bloc/otp_bloc/otp_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpTimerBloc extends Bloc<OtpTimerEvent, OtpTimerState> {
  Timer? _timer;

  OtpTimerBloc() : super(OtpTimerInitial()) {
    on<StartOtpTimer>(_onStart);
    on<TickOtpTimer>(_onTick);
  }

  void _onStart(StartOtpTimer event, Emitter<OtpTimerState> emit) {
    _timer?.cancel();

    int seconds = event.seconds;

    emit(OtpTimerRunning(seconds));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      seconds--;

      if (seconds <= 0) {
        timer.cancel();
        add(TickOtpTimer(0));
      } else {
        add(TickOtpTimer(seconds));
      }
    });
  }

  void _onTick(TickOtpTimer event, Emitter<OtpTimerState> emit) {
    if (event.seconds == 0) {
      emit(OtpTimerFinished());
    } else {
      emit(OtpTimerRunning(event.seconds));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}