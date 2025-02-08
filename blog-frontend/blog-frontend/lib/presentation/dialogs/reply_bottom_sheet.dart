import 'package:blog/core/app_assets.dart';
import 'package:blog/data/models/blogs/blog_model.dart';
import 'package:blog/logic/cubits/blog/blog_cubit.dart';
import 'package:blog/logic/cubits/user/user_cubit.dart';
import 'package:blog/logic/cubits/user/user_state.dart';
import 'package:blog/presentation/widgets/bottom_listview_widget.dart';
import 'package:blog/presentation/widgets/gap_widget.dart';
import 'package:blog/presentation/widgets/textField_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/ui.dart';
import '../../logic/services/formatter.dart';

void showFullScreenBottomSheet(
  BuildContext context,
  List<Replies> replies,
  String blogId,
) {
  TextEditingController conCon = TextEditingController();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useSafeArea: true,
    isDismissible: true,
    enableDrag: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, StateSetter setState) {
          return GestureDetector(
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      height: 5,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const GapWidget(
                      height: -10,
                    ),
                    Expanded(
                      child: BottomListviewWidget(
                        replies: replies,
                      ),
                    ),
                    Container(
                      color: AppColors.navBarColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFieldWidget(
                                hintText: "Reply to blog...",
                                controller: conCon,
                                maxLines: 1,
                              ),
                            ),
                            const GapWidget(
                              height: -16,
                            ),
                            InkWell(
                              onTap: () async {
                                final content = conCon.text.trim();
                                if (content.isNotEmpty) {
                                  conCon.clear();
                                  final userCubit =
                                      BlocProvider.of<UserCubit>(context);
                                  if (userCubit.state is UserLoggedOutState) {
                                    return;
                                  }
                                  bool isSuccess =
                                      await BlocProvider.of<BlogCubit>(context)
                                          .reply(
                                    blogId: blogId,
                                    content: content,
                                  );
                                  if (isSuccess) {
                                    Replies newRepl = Replies(
                                      replyCon: content,
                                      user: (userCubit.state as UserLoadedState)
                                          .userModel,
                                      createdOn: DateTime.now(),
                                    );
                                    replies.add(newRepl);
                                    toast(message: "reply added");
                                    Formatter.hideKeyboard();
                                    setState(() {});
                                  }
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Image.asset(AppAssets.send, height: 24),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
