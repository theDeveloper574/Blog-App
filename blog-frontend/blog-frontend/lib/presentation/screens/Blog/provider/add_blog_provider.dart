import 'package:blog/core/ui.dart';
import 'package:blog/logic/cubits/blog/blog_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBlogProvider extends ChangeNotifier {
  final BuildContext context;
  AddBlogProvider(this.context);
  final key = GlobalKey<FormState>();
  final titleCon = TextEditingController();
  final contentCon = TextEditingController();
  void addBlog() async {
    if (!key.currentState!.validate()) return;
    String title = titleCon.text.trim();
    String content = contentCon.text.trim();
    bool isSuccess = await BlocProvider.of<BlogCubit>(context).addNewBlog(
      title: title,
      content: content,
    );
    if (isSuccess) {
      toast(message: "Blog Added");
      Navigator.of(context).pop();
    }
  }
}
