import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_flow/core/constants/assets_const.dart';
import 'package:chat_flow/core/constants/image_type_const.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget(
      {super.key,
      required this.image,
      required this.type,
      this.fit,
      this.backgroundColor,
      this.cachedNetworkImage = false,
      this.placeholder,
      this.height,
      this.width,
      this.borderRadius,
      this.imageColor,
      this.onTap,
      this.errorWidget});

  final String image;
  final int type;
  final BoxFit? fit;
  final Color? backgroundColor;
  final Color? imageColor;
  final bool cachedNetworkImage;
  final String? placeholder;
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;
  final Function()? onTap;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: height,
        width: width,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: backgroundColor,
        ),
        child: imageWidget(),
      ),
    );
  }

  Widget imageWidget() {
    if (type == ImageType.network) {
      if (cachedNetworkImage) {
        return CachedNetworkImage(
          imageUrl: image,
          fit: fit,
          color: imageColor,
          placeholder: (context, url) => Image.asset(
              placeholder ?? AssetsConst.logoPlaceholder,
              fit: BoxFit.cover),
          errorWidget: (context, url, error) =>
              errorWidget ??
              (placeholder != null
                  ? Image.asset(placeholder ?? '', fit: fit ?? BoxFit.cover)
                  : Center(
                      child: Icon(Icons.warning, color: Colors.red.shade600))),
        );
      } else {
        return FadeInImage.assetNetwork(
          placeholder: placeholder ?? '',
          image: image,
          fit: fit,
          placeholderFit: BoxFit.cover,
          imageErrorBuilder: (context, error, stackTrace) =>
              errorWidget ??
              (placeholder != null
                  ? Image.asset(placeholder ?? AssetsConst.logoPlaceholder,
                      fit: fit ?? BoxFit.cover)
                  : Center(
                      child: Icon(Icons.warning, color: Colors.red.shade600))),
        );
      }
    } else if (type == ImageType.asset) {
      return Image.asset(
        image,
        fit: fit,
        color: imageColor,
        errorBuilder: (context, error, stackTrace) =>
            errorWidget ??
            (placeholder != null
                ? Image.asset(placeholder ?? AssetsConst.logoPlaceholder,
                    fit: fit ?? BoxFit.cover)
                : Center(
                    child: Icon(Icons.warning, color: Colors.red.shade600))),
      );
    } else {
      return Image.file(
        File(image),
        fit: fit,
        color: imageColor,
        errorBuilder: (context, error, stackTrace) =>
        errorWidget ??
        (placeholder != null
                ? Image.asset(placeholder ?? AssetsConst.logoPlaceholder,
                    fit: fit ?? BoxFit.cover)
                : Center(
                    child: Icon(Icons.warning, color: Colors.red.shade600))),
      );
    }
  }
}
