import 'package:flutter/material.dart';

SizedBox spacing({double? width, double? height}) {
  return SizedBox(
    width: width ?? 0.0, // Set width to 0 if not provided.
    height: height ?? 0.0, // Set height to 0 if not provided.
  );
}
