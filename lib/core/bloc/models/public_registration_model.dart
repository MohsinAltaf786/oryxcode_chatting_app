class PublicRegistrationModel {
  final String? mobile;
  final String? otp;
  final String? name;
  final String? deviceUuid;
  final String?publicKey;
  final String? deviceSyncKey;
  PublicRegistrationModel({this.name,this.mobile,this.publicKey,this.deviceSyncKey,this.otp,this.deviceUuid});
}