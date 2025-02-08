import 'package:blog/data/models/user/user_model.dart';
import 'package:blog/logic/cubits/user/user_cubit.dart';
import 'package:blog/logic/cubits/user/user_state.dart';
import 'package:blog/presentation/screens/auth/provider/create_account_provider.dart';
import 'package:blog/presentation/widgets/ButtonWidget.dart';
import 'package:blog/presentation/widgets/gap_widget.dart';
import 'package:blog/presentation/widgets/image_pick_widget.dart';
import 'package:blog/presentation/widgets/profile_img_widget.dart';
import 'package:blog/presentation/widgets/textField_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/ui.dart';
import '../../dialogs/image_pick_dialog.dart';

class UpdateProfile extends StatelessWidget {
  UpdateProfile({super.key});
  static const String routeName = "updateProfile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
        title: const Text(
          "Update Profile",
          style: TextStyle(
            color: AppColors.whiteColor,
          ),
        ),
      ),
      body: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
        if (state is UserLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        // if (state is UserErrorState) {
        //   toast(message: state.message.toString());
        // }
        if (state is UserLoadedState) {
          return updateUser(context, state.userModel);
        }
        return const SizedBox.shrink();
      }),
    );
  }

  late String name;
  late String email;
  late String avatar;
  Widget updateUser(context, UserModel user) {
    name = user.fullName!;
    email = user.email!;
    avatar = user.avatar!;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Provider.of<CreateAccProvider>(context).image != null
              ? const ImagePickWidget()
              : ProfileImgWidget(
                  imgUrl: user.avatar!,
                  onTap: () => showImageSourceDialog(
                    context: context,
                    onPickImage: (ImageSource image) {
                      Provider.of<CreateAccProvider>(context, listen: false)
                          .pickImage(imageSource: image);
                    },
                  ),
                ),
          const GapWidget(),
          TextFieldWidget(
            hintText: "Name",
            initialVa: user.fullName!,
            onChanged: (val) {
              user.fullName = val;
            },
          ),
          const GapWidget(),
          TextFieldWidget(
            hintText: "Email",
            initialVa: user.email!,
            readonly: true,
          ),
          const GapWidget(),
          ButtonWidget(
            width: 40,
            text: "Update",
            onPressed: () async {
              final img = Provider.of<CreateAccProvider>(
                context,
                listen: false,
              );
              if (img.image != null) {
                user.avatar = img.image?.path;
              }
              if (name == user.fullName &&
                  email == user.email! &&
                  avatar == user.avatar) {
                Navigator.pop(context);
                return;
              }
              bool isUpdated =
                  await BlocProvider.of<UserCubit>(context).updateUser(
                user,
                avatar: img.image,
              );
              if (isUpdated) {
                toast(message: "User Update");
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
    );
  }
}
