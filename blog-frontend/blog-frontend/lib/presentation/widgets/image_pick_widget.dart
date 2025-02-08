import 'dart:io';

import 'package:blog/presentation/screens/auth/provider/create_account_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/ui.dart';
import '../dialogs/image_pick_dialog.dart';

class ImagePickWidget extends StatelessWidget {
  final String? imageUrl; // Accept image URL as a parameter

  const ImagePickWidget({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final userPro = Provider.of<CreateAccProvider>(context);
    return GestureDetector(
      onTap: () => showImageSourceDialog(
        context: context,
        onPickImage: (ImageSource image) {
          userPro.pickImage(imageSource: image);
        },
      ),
      child: CircleAvatar(
        radius: MediaQuery.sizeOf(context).height * 0.06,
        backgroundColor: AppColors.primaryColor,
        child:
            (userPro.image != null) // Otherwise, show user image if available
                ? ClipOval(
                    child: kIsWeb
                        ? Image.memory(
                            userPro.webImage!,
                            fit: BoxFit.cover,
                            width: MediaQuery.sizeOf(context).height * 0.14,
                            height: MediaQuery.sizeOf(context).height * 0.14,
                          )
                        : Image.file(
                            File(userPro.image!.path),
                            fit: BoxFit.cover,
                            width: MediaQuery.sizeOf(context).height * 0.14,
                            height: MediaQuery.sizeOf(context).height * 0.14,
                          ),
                  )
                : const Icon(
                    CupertinoIcons.person_circle_fill,
                    size: 44,
                  ),
      ),
    );
  }
}
