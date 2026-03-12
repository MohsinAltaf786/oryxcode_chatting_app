import 'dart:convert';
import 'package:basic_utils/basic_utils.dart';
import 'package:chat_flow/core/bloc/config_bloc/config_bloc.dart';
import 'package:chat_flow/core/bloc/config_bloc/config_event.dart';
import 'package:chat_flow/core/bloc/config_bloc/config_state.dart';
import 'package:chat_flow/core/services/device_key_service.dart';
import 'package:chat_flow/core/utils/device_utils.dart';
import 'package:chat_flow/core/utils/navigator.dart';
import 'package:chat_flow/presentation/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
const String SYSTEM_SYNC_PUBLIC_KEY = """
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAt1eV+d6F6aGJc2N7+6yT
5q3P/l+5lF5cD0xhtsYk6M9nZk3oFhGv6bk6tQNLW6PRyp8oE/q2GUp2XdsLxJJu
h8+Q/9ZjI/1FJr8Z4WmZy3V0OZjxnR5Fz0WZ9BqU5vM5ZQgS6c5dT3w+dpF/95fB
pE3Rl07z5/2qHy9PZXIh9x9+d9W/7Ymy9T9Yx6D9FZHg3zXgjvKp3x7ivR8KxZjk
6dPgyG6KpH+vY9G+0U7R3H5G9n0WkI6NqLsafzZL8KX+XoKhR6w2H+5c8DRR4kXr5
Gb6v3Y3F8iQm5u4ZR1H4L2uKmskK7eZ2l3vNHk8IFGjx8UftDKtFsF3YV5TX8uX6
9QIDAQAB
-----END PUBLIC KEY-----
""";
class PairingScreen extends StatefulWidget {
  const PairingScreen({super.key});

  @override
  State<PairingScreen> createState() => _PairingScreenState();
}

class _PairingScreenState extends State<PairingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ConfigBloc>().add(RequestPairingEvent());  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConfigBloc, ConfigState>(
      listener: (context, state) async {
        if (state is PairingApproved) {
          print('pairing approved');
          final keys = await DeviceKeyService.generateDeviceKeys();
          final userId=int.parse(state.userId);
           print('approved user Id:$userId publicKey: ${keys['public_key']} and deviceToken ${keys['device_sync_token']}');
          context.read<ConfigBloc>().add(UploadKeysEvent(
            userId:int.parse(state.userId),
            publicKey: keys['public_key']??'',
            deviceSyncToken:keys['device_sync_token']??'',
          ));

        } else if(state is KeysUploaded){
          print('keys uploaded ${state.success}');
          navigateToScreen(context, const Dashboard(),
              clearPreviousRoutes: true);
        }
        else if (state is ConfigError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
      return Scaffold(
        floatingActionButton:FloatingActionButton(onPressed:(){}),
        body:Builder(builder: (context){
          if (state is ConfigLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PairingCodeLoaded) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Your 8-digit pairing code:"),
                  const SizedBox(height: 10),
                  Text(state.code,
                      style: const TextStyle(
                          fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  const Text("Waiting for admin approval..."),
                ],
              ),
            );
          } else if (state is PairingApproved) {
            return const Center(
              child: Text("Approved! Uploading keys...",
                  style: TextStyle(fontSize: 18)),
            );
          } else if (state is ConfigError) {
            return Center(child: Text(state.message));
          } else {
            return const Text('abc');
          }
        })
      );
      },
    );
  }
}







