import 'package:flutter/material.dart';

import '../../core/app_assets.dart';
import '../../core/ui.dart';
import 'gap_widget.dart';

class ProfileLisTileWidget extends StatelessWidget {
  final String title;
  final Function()? onTap;
  const ProfileLisTileWidget({
    super.key,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const GapWidget(),
        ListTile(
          onTap: onTap,
          leading: Image.asset(AppAssets.profile),
          title: Text(title),
          trailing: const Icon(
            size: 16,
            Icons.arrow_forward_ios_sharp,
            color: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}
