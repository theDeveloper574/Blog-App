import 'package:blog/core/api.dart';
import 'package:blog/core/app_assets.dart';
import 'package:blog/data/models/blogs/blog_model.dart';
import 'package:blog/logic/services/formatter.dart';
import 'package:blog/presentation/widgets/show_more_text_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/ui.dart';

class BottomListviewWidget extends StatefulWidget {
  final List<Replies> replies;
  const BottomListviewWidget({
    super.key,
    required this.replies,
  });

  @override
  State<BottomListviewWidget> createState() => _BottomListviewWidgetState();
}

class _BottomListviewWidgetState extends State<BottomListviewWidget> {
  @override
  Widget build(BuildContext context) {
    widget.replies.sort((a, b) => b.createdOn!.compareTo(a.createdOn!));
    return (widget.replies.isEmpty)
        ? const Center(
            child: Text(
              "No replies exists Tap + to add reply",
              textAlign: TextAlign.center,
            ),
          )
        : ListView.builder(
            itemCount: widget.replies.length,
            itemBuilder: (context, int index) {
              final reply = widget.replies[index];
              return Card(
                elevation: 1.8,
                shadowColor: AppColors.navBarColor,
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    child: reply.user?.avatar == ""
                        ? ClipOval(
                            child: Image.asset(
                              height: 50,
                              AppAssets.placeholder,
                              fit: BoxFit.cover,
                            ),
                          )
                        : ClipOval(
                            child: CachedNetworkImage(
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                              imageUrl: "$ImgBaseUrl${reply.user!.avatar}",
                              placeholder: (context, String img) {
                                return Image.asset(AppAssets.profile);
                              },
                            ),
                          ),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        reply.user!.fullName!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      ShowMoreTextWidget(
                        leftPad: 0,
                        lines: 2,
                        text: reply.replyCon,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          Formatter.formatDateDat(reply.createdOn!),
                          style: TextStyles.body4.copyWith(
                            color: AppColors.primaryColor,
                            fontStyle: FontStyle.italic,
                            fontSize: 12,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
  }
}
