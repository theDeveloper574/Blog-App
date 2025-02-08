import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/api.dart';

class ProfileImgWidget extends StatelessWidget {
  final String imgUrl;
  final void Function()? onTap;
  const ProfileImgWidget({
    super.key,
    this.onTap,
    required this.imgUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: MediaQuery.sizeOf(context).height * 0.07,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: "$ImgBaseUrl$imgUrl",
            width: MediaQuery.sizeOf(context).height * 0.14,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
