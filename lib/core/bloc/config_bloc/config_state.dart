abstract class ConfigState {}

class ConfigInitial extends ConfigState {}

class ConfigLoading extends ConfigState {}

class ConfigLoaded extends ConfigState {
  final bool publicRegistrationEnabled;

  ConfigLoaded(this.publicRegistrationEnabled);
}

class ConfigError extends ConfigState {
  final String message;

  ConfigError(this.message);
}

class PairingCodeLoaded extends ConfigState {
  final String code; // or int if API returns number
  PairingCodeLoaded(this.code);
}

class PairingApproved extends ConfigState {
  final String userId;

  PairingApproved({
    required this.userId,
  });
}

class KeysUploaded extends ConfigState {
  final bool success;

  KeysUploaded({
    required this.success,
  });
}

class OtpRequested extends ConfigState {
  final bool success;

  OtpRequested({
    required this.success,
  });
}