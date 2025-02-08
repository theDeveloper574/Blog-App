import 'package:blog/data/models/blogs/blog_model.dart';
import 'package:blog/logic/cubits/blog/blog_cubit.dart';
import 'package:blog/logic/cubits/blog/blog_state.dart';
import 'package:blog/presentation/screens/Blog/provider/add_blog_provider.dart';
import 'package:blog/presentation/widgets/gap_widget.dart';
import 'package:blog/presentation/widgets/textField_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../core/ui.dart';
import '../../widgets/ButtonWidget.dart';

class AddBlog extends StatefulWidget {
  final bool showAdd;
  final BlogModel? blogModel;
  const AddBlog({
    super.key,
    this.showAdd = false,
    this.blogModel,
  });
  static const String routeName = "addBlog";

  @override
  State<AddBlog> createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  late String originalTitle;
  late String originalContent;

  @override
  void initState() {
    super.initState();
    // Store the original values before editing
    originalTitle = widget.blogModel?.title ?? "";
    originalContent = widget.blogModel?.content ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final addBlog = Provider.of<AddBlogProvider>(context);
    return BlocListener<BlogCubit, BlogState>(
      listener: (context, state) {
        if (state is BlogErrorState) {
          toast(message: state.message.toString());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          leading: widget.showAdd
              ? null
              : GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 20,
                  ),
                ),
          iconTheme: const IconThemeData(color: AppColors.whiteColor),
          title: Text(
            widget.showAdd ? "Update Blog" : "Post a question",
            style: TextStyles.body1.copyWith(color: AppColors.whiteColor),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: addBlog.key,
            child: ListView(
              children: [
                TextFieldWidget(
                  hintText: "Topic",
                  controller: widget.showAdd ? null : addBlog.titleCon,
                  initialVa: widget.blogModel?.title,
                  onChanged: (val) {
                    widget.blogModel?.title = val;
                  },
                  buttonAction: TextInputAction.next,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Topic is required";
                    }
                    return null;
                  },
                ),
                const GapWidget(),
                TextFieldWidget(
                  initialVa: widget.blogModel?.content,
                  controller: widget.showAdd ? null : addBlog.contentCon,
                  maxLines: 10,
                  hintText: "Content",
                  buttonAction: TextInputAction.done,
                  onChanged: (val) {
                    widget.blogModel?.content = val;
                  },
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Content is required";
                    }
                    return null;
                  },
                ),
                const GapWidget(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ButtonWidget(
                    width: MediaQuery.sizeOf(context).width / 5,
                    text: widget.showAdd
                        ? "update".toUpperCase()
                        : "post".toUpperCase(),
                    onPressed: widget.showAdd
                        ? () async {
                            // Check if the user made changes
                            if (widget.blogModel!.title == originalTitle &&
                                widget.blogModel!.content == originalContent) {
                              Navigator.pop(context);
                              return;
                            }
                            bool isUpdated =
                                await BlocProvider.of<BlogCubit>(context)
                                    .updateBlog(
                              blogModel: widget.blogModel!,
                            );
                            if (isUpdated) {
                              Navigator.pop(context);
                              toast(message: "Blog Updated");
                            }
                          }
                        : addBlog.addBlog,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
