import 'package:blog/core/api.dart';
import 'package:blog/core/app_assets.dart';
import 'package:blog/data/models/blogs/blog_model.dart';
import 'package:blog/logic/cubits/blog/blog_cubit.dart';
import 'package:blog/logic/cubits/blog/blog_state.dart';
import 'package:blog/logic/services/formatter.dart';
import 'package:blog/presentation/dialogs/permission_dialog.dart';
import 'package:blog/presentation/dialogs/reply_bottom_sheet.dart';
import 'package:blog/presentation/screens/Blog/add_blog.dart';
import 'package:blog/presentation/widgets/show_more_text_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/ui.dart';
import 'gap_widget.dart';

class BlogWidget extends StatefulWidget {
  final List<BlogModel> blogs;
  final bool isShowDel;
  const BlogWidget({
    super.key,
    this.isShowDel = false,
    required this.blogs,
  });

  @override
  State<BlogWidget> createState() => _BlogWidgetState();
}

class _BlogWidgetState extends State<BlogWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      BlocProvider.of<BlogCubit>(context).loadMoreBlog();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.blogs.length + 1,
      itemBuilder: (context, int index) {
        if (index < widget.blogs.length) {
          final item = widget.blogs[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            elevation: 2.0,
            surfaceTintColor: AppColors.navBarColor,
            shadowColor: AppColors.navBarColor,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      child: ClipOval(
                        child: item.user!.avatar == ""
                            ? Image.asset(
                                AppAssets.placeholder,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: "$ImgBaseUrl${item.user!.avatar}",
                                placeholder: (context, String img) {
                                  return Image.asset(
                                    AppAssets.placeholder,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  );
                                },
                                height: 50,
                                width: 50,
                              ),
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.title!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              item.user!.fullName!,
                              style: TextStyles.body4.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              Formatter.formatDate(item.createdOn),
                              style: TextStyles.body4.copyWith(
                                color: AppColors.primaryColor,
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  ShowMoreTextWidget(
                    text: item.content,
                  ),
                  const GapWidget(
                    height: -10,
                  ),
                  widget.isShowDel
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    AddBlog.routeName,
                                    arguments: {
                                      "showAdd": true,
                                      "blogModel": item,
                                    },
                                  ),
                                  child: const Icon(
                                    size: 24,
                                    Icons.update,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                const GapWidget(
                                  height: -16,
                                ),
                                InkWell(
                                  onTap: () => showPerDialog(
                                    context,
                                    "delete this Blog",
                                    () async {
                                      Navigator.pop(context);
                                      bool isSuccess =
                                          await BlocProvider.of<BlogCubit>(
                                        context,
                                      ).deleteBlog(
                                        blogId: item.sId!,
                                      );
                                      if (isSuccess) {
                                        toast(message: "Blog deleted");
                                      }
                                    },
                                  ),
                                  child: const Icon(
                                    size: 24,
                                    Icons.delete,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                if (item.isFavorite) {
                                  BlocProvider.of<BlogCubit>(context)
                                      .removeFavorite(item);
                                } else {
                                  BlocProvider.of<BlogCubit>(context)
                                      .addFavorite(item);
                                }
                              },
                              child: Icon(
                                item.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 22,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            const GapWidget(
                              height: -16,
                            ),
                            InkWell(
                              onTap: () {
                                showFullScreenBottomSheet(
                                  context,
                                  item.replies!,
                                  item.sId!,
                                );
                              },
                              child: const Icon(
                                size: 22,
                                color: AppColors.primaryColor,
                                CupertinoIcons.reply_thick_solid,
                              ),
                            ),
                            const GapWidget(
                              width: -6,
                              height: -16,
                            ),
                          ],
                        ),
                  const GapWidget(
                    height: -14,
                  ),
                ],
              ),
            ),
          );
        } else {
          return BlocBuilder<BlogCubit, BlogState>(
            builder: (context, state) {
              if (state is BlogLoadedState && state.isLoadNewBlog) {
                return const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          );
        }
      },
    );
  }
}
