import 'package:blog/core/ui.dart';
import 'package:blog/logic/cubits/blog/blog_cubit.dart';
import 'package:blog/logic/cubits/blog/blog_state.dart';
import 'package:blog/presentation/widgets/blog_shimmer_effect.dart';
import 'package:blog/presentation/widgets/blog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Blogs",
          style: TextStyles.body1,
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(bottom: 10, right: 10),
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              size: 28,
              color: AppColors.primaryColor,
            ),
          )
        ],
      ),
      body: BlocBuilder<BlogCubit, BlogState>(builder: (context, state) {
        if (state is BlogLoadingState) {
          return const BlogShimmer();
        }
        if (state is BlogLoadedState && state.blogs.isEmpty) {
          return const Center(
            child: Text("No blogs added yet|"),
          );
        }
        return BlogWidget(
          blogs: state.blogs,
        );
      }),
    );
  }
}
