import 'package:blog/core/ui.dart';
import 'package:blog/data/models/blogs/blog_model.dart';
import 'package:blog/data/repositories/blog_repository.dart';
import 'package:blog/logic/cubits/blog/blog_state.dart';
import 'package:blog/logic/cubits/user/user_cubit.dart';
import 'package:blog/logic/cubits/user/user_state.dart';
import 'package:blog/logic/services/preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogCubit extends Cubit<BlogState> {
  final UserCubit userCubit;
  BlogCubit(this.userCubit) : super(BlogInitialState()) {
    _initializeBlog();
  }
  final _api = BlogRepository();
  int _currentPage = 1;
  bool _isFetchMoreBlog = false;
  void _initializeBlog() async {
    emit(BlogLoadingState(state.blogs));
    try {
      final blogs = await _api.fetchAllBlogs(page: _currentPage);
      final favBlogs = await Preferences.fetchFavorites();

      for (var blog in blogs) {
        if (favBlogs.contains(blog.sId)) {
          blog.isFavorite = true;
        }
      }
      sortBlogs(blogs);
    } catch (ex) {
      emit(BlogErrorState(ex.toString(), state.blogs));
    }
  }

  void loadMoreBlog() async {
    if (_isFetchMoreBlog) return;
    _isFetchMoreBlog = true;
    emit(BlogLoadedState(isLoadNewBlog: true, state.blogs));
    _currentPage++;
    try {
      final loadedBlog = await _api.fetchAllBlogs(page: _currentPage);
      if (loadedBlog.isEmpty) {
        emit(BlogLoadedState(isLoadNewBlog: false, state.blogs));
        _isFetchMoreBlog = false;
        _currentPage--; //stop the page increment if no pages left
        return;
      }
      final favBlog = await Preferences.fetchFavorites();
      for (var blog in loadedBlog) {
        if (favBlog.contains(blog.sId)) {
          blog.isFavorite = true;
        }
      }
      final updatedBlog = [...state.blogs, ...loadedBlog];
      sortBlogs(updatedBlog);
      // emit(BlogNewState(isLoadNewBlog: false, state.blogs));
    } catch (ex) {
      emit(BlogErrorState(ex.toString(), state.blogs));
    }
    _isFetchMoreBlog = false;
  }

  //ad new blog
  Future<bool> addNewBlog({
    required String title,
    required String content,
  }) async {
    emit(BlogLoadingState(state.blogs));
    try {
      if (userCubit.state is UserLoggedOutState) {
        return false;
      }
      final newBlog = await _api.addBlog(
        id: (userCubit.state as UserLoadedState).userModel.sId!,
        title: title,
        content: content,
      );
      List<BlogModel> newBlogs = [
        ...state.blogs,
        newBlog,
      ];
      sortBlogs(newBlogs);
      return true;
    } catch (ex) {
      emit(BlogErrorState(ex.toString(), state.blogs));
      return false;
    }
  }

  //add fav blog
  void addFavorite(BlogModel blog) async {
    blog.isFavorite = true;
    await Preferences.addFavorite(blog.sId!);
    final updatedBlogs = state.blogs.map((b) {
      return b.sId == blog.sId ? blog : b;
    }).toList();
    sortBlogs(updatedBlogs);
    // emit(BlogLoadedState(updatedBlogs));
  }

  void removeFavorite(BlogModel blog) async {
    blog.isFavorite = false;
    await Preferences.removeFavorite(blog.sId!);
    final updatedBlogs = state.blogs.map((b) {
      return b.sId == blog.sId ? blog : b;
    }).toList();
    sortBlogs(updatedBlogs);
    // emit(BlogLoadedState(updatedBlogs));
  }

  //sort blogs
  void sortBlogs(List<BlogModel> blogs) {
    blogs.sort((a, b) => b.createdOn!.compareTo(a.createdOn!));
    emit(BlogLoadedState(
      blogs,
    ));
  }

  //add reply to blog
  Future<bool> reply({
    required String blogId,
    required String content,
  }) async {
    emit(BlogLoadingState(state.blogs));
    try {
      final replyRes = await _api.addReply(
        uid: (userCubit.state as UserLoadedState).userModel.sId!,
        blocId: blogId,
        content: content,
      );
      _currentPage = 1;
      _initializeBlog();
      // emit(BlogLoadedState(updatedBlogs));
      return true;
    } catch (ex) {
      toast(message: ex.toString());
      emit(BlogErrorState(ex.toString(), state.blogs));
      return false;
    }
  }

  //delete blog
  Future<bool> deleteBlog({
    required String blogId,
  }) async {
    try {
      emit(BlogLoadingState(state.blogs));
      await _api.deleteBlog(
        userId: (userCubit.state as UserLoadedState).userModel.sId!,
        blogId: blogId,
      );
      _currentPage = 1;
      _initializeBlog();
      return true;
    } catch (ex) {
      emit(BlogErrorState(ex.toString(), state.blogs));
      return false;
    }
  }

  //update blog
  Future<bool> updateBlog({
    required BlogModel blogModel,
  }) async {
    try {
      if (userCubit.state is UserLoggedOutState) {
        return false;
      }
      await _api.updateBlog(
        user: (userCubit.state as UserLoadedState).userModel.sId!,
        id: blogModel.sId!,
        title: blogModel.title!,
        content: blogModel.content!,
      );
      // Future.delayed(const Duration(seconds: 1));
      _currentPage = 1;
      _initializeBlog();

      return true;
    } catch (ex) {
      emit(BlogErrorState(ex.toString(), state.blogs));
      return false;
    }
  }
}
