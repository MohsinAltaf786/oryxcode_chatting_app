import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';

class DeviceKeyService {

  /// Main function that returns both keys
  static Future<Map<String, String>> generateDeviceKeys() async {
    final keyPair = _generateRSAKeyPair();

    final publicKey = _encodePublicKey(keyPair.publicKey);
    final deviceSyncToken = _encodePrivateKey(keyPair.privateKey);

    return {
      "public_key": publicKey,
      "device_sync_token": deviceSyncToken,
    };
  }

  /// Generate RSA Key Pair
  static AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> _generateRSAKeyPair() {
    final secureRandom = FortunaRandom();

    final seed = Uint8List(32);
    final random = Random.secure();

    for (int i = 0; i < seed.length; i++) {
      seed[i] = random.nextInt(256);
    }

    secureRandom.seed(KeyParameter(seed));

    final keyGen = RSAKeyGenerator()
      ..init(
        ParametersWithRandom(
          RSAKeyGeneratorParameters(
            BigInt.parse('65537'),
            2048,
            64,
          ),
          secureRandom,
        ),
      );

    final pair = keyGen.generateKeyPair();

    return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(
      pair.publicKey as RSAPublicKey,
      pair.privateKey as RSAPrivateKey,
    );
  }

  /// Encode Public Key
  static String _encodePublicKey(RSAPublicKey publicKey) {
    final modulus = publicKey.modulus!.toRadixString(16);
    final exponent = publicKey.exponent!.toRadixString(16);

    final keyString = "$modulus|$exponent";

    return base64Encode(utf8.encode(keyString));
  }

  /// Encode Private Key (Device Sync Token)
  static String _encodePrivateKey(RSAPrivateKey privateKey) {
    final privateKeyString =
        "${privateKey.modulus}|${privateKey.privateExponent}";

    return base64Encode(utf8.encode(privateKeyString));
  }
}