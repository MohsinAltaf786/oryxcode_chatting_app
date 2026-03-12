abstract class ConfigEvent {}

class LoadConfigEvent extends ConfigEvent {}
class RequestPairingEvent extends ConfigEvent {}
class CheckPairingEvent extends ConfigEvent {
  final String code;
  CheckPairingEvent(this.code);
}
class UploadKeysEvent extends ConfigEvent {
  final int userId;
  final String publicKey;
  final String deviceSyncToken;
  UploadKeysEvent({
    required this.userId,
    required this.publicKey,
    required this.deviceSyncToken,
  });
}
class RequestOtpEvent extends ConfigEvent{
  final String mobileNumber;
  RequestOtpEvent({required this.mobileNumber});
}
class RequestPublicRegistrationEvent extends ConfigEvent{
  final String mobile;
  final String otp;
  final String name;
  final String publicKey;
  final String deviceSyncToken;
  RequestPublicRegistrationEvent({required this.mobile,required this.otp,required this.name,required this.publicKey,required this.deviceSyncToken});
}