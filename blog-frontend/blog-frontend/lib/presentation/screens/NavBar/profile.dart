import 'package:blog/data/models/user/user_model.dart';
import 'package:blog/logic/cubits/user/user_cubit.dart';
import 'package:blog/logic/cubits/user/user_state.dart';
import 'package:blog/presentation/widgets/gap_widget.dart';
import 'package:blog/presentation/widgets/profile_listile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_assets.dart';
import '../../../core/ui.dart';
import '../../dialogs/permission_dialog.dart';
import '../../widgets/profile_img_widget.dart';
import '../Blog/my_blogs.dart';
import '../auth/update_profile.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        // if (state is UserErrorState) {
        //   toast(message: state.message.toString());
        // }
        if (state is UserLoadedState) {
          return _user(context, state.userModel);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _user(context, UserModel user) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(bottom: 10, right: 10),
            onPressed: () {
              showPerDialog(
                context,
                "log out",
                () {
                  BlocProvider.of<UserCubit>(context).logOut();
                },
              );
            },
            icon: const Icon(
              Icons.logout,
              color: AppColors.primaryColor,
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          const GapWidget(),
          InkWell(
            onTap: () => Navigator.pushNamed(context, UpdateProfile.routeName),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  user.avatar == ""
                      ? Image.asset(
                          AppAssets.placeholder,
                          height: MediaQuery.sizeOf(context).height * 0.12,
                          fit: BoxFit.cover,
                        )
                      : ProfileImgWidget(
                          imgUrl: user.avatar!,
                        ),
                  const GapWidget(height: -16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.fullName!,
                        style: TextStyles.body1,
                      ),
                      Text(
                        user.email!,
                        style: TextStyles.body2,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          const GapWidget(height: -10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Level: Beginner",
              style: TextStyles.body1,
            ),
          ),
          ProfileLisTileWidget(
            onTap: () {
              Navigator.pushNamed(
                context,
                MyBlogs.routeName,
                arguments: user.sId,
              );
            },
            title: "My Blogs",
          ),
          ProfileLisTileWidget(
            title: "Update Profile",
            onTap: () => Navigator.pushNamed(context, UpdateProfile.routeName),
          ),
        ],
      ),
    );
  }
}
