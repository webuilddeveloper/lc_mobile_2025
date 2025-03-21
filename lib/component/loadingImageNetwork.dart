import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'ColorLoader5.dart';

Widget loadingImageNetwork(
  String url, {
  BoxFit? fit,
  double? height,
  double? width,
  Color? color,
  bool isProfile = false,
}) {
  if (url == '' && isProfile) {
    return Container(
      height: 30,
      width: 30,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.white,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Image.asset(
        'assets/images/user_not_found.png',
        color: Colors.white,
      ),
    );
  }

  return CachedNetworkImage(
    imageUrl: url,
    fit: fit,
    height: height,
    width: width,
    color: color,
    progressIndicatorBuilder: (_, __, ___) => const ColorLoader5(
      dotOneColor: Color(0xFF2D9CED),
      dotTwoColor: Colors.blue,
      dotThreeColor: Color(0x802D9CED),
    ),
    errorWidget: (_, __, ___) => Container(
      color: const Color(0xFFF2FAFF),
      padding: const EdgeInsets.all(10),
      child: Image.asset(
        'assets/images/metro-file-picture.png',
      ),
    ),
  );
}
