import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';

class AppSnackBarService {
  static void showTopSnackbar({
    required String message,
    required BuildContext context,
    String type='error',
  }) {
    final snackBar = AnimatedSnackBar.material(
      message,
      type: type=='error'?AnimatedSnackBarType.error:AnimatedSnackBarType.success,
      duration: const Duration(seconds: 2),
      mobilePositionSettings: const MobilePositionSettings(
        topOnAppearance: 50,
        topOnDissapear: 50,
      ),
    );

    snackBar.show(context);
  }
}