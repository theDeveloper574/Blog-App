import 'package:blog/presentation/widgets/blog_shimmer_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/cubits/blog/blog_cubit.dart';
import '../../../logic/cubits/blog/blog_state.dart';
import '../../widgets/blog_widget.dart';

class Favourite extends StatelessWidget {
  const Favourite({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favourite Blogs"),
      ),
      body: BlocBuilder<BlogCubit, BlogState>(builder: (context, state) {
        if (state is BlogLoadingState) {
          return const BlogShimmer();
        }
        if (state is BlogLoadedState &&
            state.blogs.where((item) => item.isFavorite).toList().isEmpty) {
          return const Center(
            child: Text("No Favourite blogs added yet|"),
          );
        }
        if (state is BlogLoadedState) {
          final favBlogs =
              state.blogs.where((item) => item.isFavorite).toList();
          return BlogWidget(
            blogs: favBlogs,
          );
        }
        return const SizedBox();
      }),
    );
  }
}
