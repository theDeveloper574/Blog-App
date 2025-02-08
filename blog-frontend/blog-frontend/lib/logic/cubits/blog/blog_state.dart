import 'package:blog/data/models/blogs/blog_model.dart';

abstract class BlogState {
  List<BlogModel> blogs;
  BlogState(this.blogs);
}

class BlogInitialState extends BlogState {
  BlogInitialState() : super([]);
}

class BlogLoadingState extends BlogState {
  BlogLoadingState(super.blogs);
}

class BlogLoadedState extends BlogState {
  bool isLoadNewBlog;
  BlogLoadedState(super.blogs, {this.isLoadNewBlog = false});
}

// class BlogNewState extends BlogState {
//   bool isLoadNewBlog;
//   BlogNewState(super.blogs, {this.isLoadNewBlog = false});
// }

class BlogErrorState extends BlogState {
  String? message;
  BlogErrorState(this.message, super.blogs);
}
