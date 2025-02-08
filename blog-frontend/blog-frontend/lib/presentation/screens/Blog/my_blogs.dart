import 'package:blog/presentation/widgets/blog_shimmer_effect.dart';
import 'package:blog/presentation/widgets/blog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/ui.dart';
import '../../../logic/cubits/blog/blog_cubit.dart';
import '../../../logic/cubits/blog/blog_state.dart';

class MyBlogs extends StatelessWidget {
  final String userId;
  const MyBlogs({super.key, required this.userId});
  static const String routeName = "routeName";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(
          color: AppColors.whiteColor,
        ),
        title: const Text(
          "My Blogs",
          style: TextStyle(
            color: AppColors.whiteColor,
          ),
        ),
      ),
      body: BlocBuilder<BlogCubit, BlogState>(builder: (context, state) {
        if (state is BlogLoadingState) {
          return const BlogShimmer();
        }
        if (state is BlogErrorState) {
          toast(message: state.message.toString());
        }
        if (state is BlogLoadedState) {
          final blogs =
              state.blogs.where((uid) => uid.user!.sId == userId).toList();
          if (blogs.isEmpty) {
            return const Center(
              child: Text("No Blogs added YET!"),
            );
          }
          return BlogWidget(
            blogs: blogs,
            isShowDel: true,
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }
}
