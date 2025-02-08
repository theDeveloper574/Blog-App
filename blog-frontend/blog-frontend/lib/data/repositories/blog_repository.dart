import 'dart:convert';

import 'package:blog/core/api.dart';
import 'package:blog/data/models/blogs/blog_model.dart';
import 'package:dio/dio.dart';

class BlogRepository {
  final _api = Api();
  //fetch all bogs
  Future<List<BlogModel>> fetchAllBlogs({required int page}) async {
    try {
      final blogs = await _api.sendRequest.get("/blog?page=$page");
      ApiResponse apiResponse = ApiResponse.fromResponse(blogs);
      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }
      return (apiResponse.data as List<dynamic>)
          .map((e) => BlogModel.fromJson(e))
          .toList();
    } on DioException catch (dioError) {
      if (dioError.type == DioExceptionType.connectionError) {
        throw "Connection error: Unable to connect to the server. Please check your internet connection.";
      } else if (dioError.type == DioExceptionType.connectionTimeout) {
        throw "Please Check your internet connection";
      } else {
        throw "An error occurred: ${dioError.message}";
      }
    } catch (ex) {
      rethrow;
    }
  }

  //Fetch blog by Id
  Future<List<BlogModel>> fetchBlogById(String uid) async {
    try {
      final blogs = await _api.sendRequest.get("/blog/$uid");
      ApiResponse apiResponse = ApiResponse.fromResponse(blogs);
      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }
      return (apiResponse.data as List<dynamic>)
          .map((e) => BlogModel.fromJson(e))
          .toList();
    } on DioException catch (dioError) {
      if (dioError.type == DioExceptionType.connectionError) {
        throw "Connection error: Unable to connect to the server. Please check your internet connection.";
      } else if (dioError.type == DioExceptionType.connectionTimeout) {
        throw "Please Check your internet connection";
      } else {
        throw "An error occurred: ${dioError.message}";
      }
    } catch (ex) {
      rethrow;
    }
  }

  //add blog
  Future<BlogModel> addBlog({
    required String id,
    required String title,
    required String content,
  }) async {
    try {
      Map<String, dynamic> mapData = {
        "title": title,
        "content": content,
        "user": id,
      };
      final res = await _api.sendRequest.post(
        "/blog",
        data: jsonEncode(mapData),
      );
      ApiResponse apiResponse = ApiResponse.fromResponse(res);
      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }
      Map<String, dynamic> blocRes = (apiResponse.data as Map<String, dynamic>);
      return BlogModel.fromJson(blocRes);
    } on DioException catch (dioError) {
      if (dioError.type == DioExceptionType.connectionError) {
        throw "Connection error: Unable to connect to the server. Please check your internet connection.";
      } else if (dioError.type == DioExceptionType.connectionTimeout) {
        throw "Please Check your internet connection";
      } else {
        throw "An error occurred: ${dioError.message}";
      }
    } catch (ex) {
      rethrow;
    }
  }

  //add reply
  Future<Replies> addReply({
    required String uid,
    required String blocId,
    required String content,
  }) async {
    try {
      Map<String, dynamic> mapData = {
        "blogId": blocId,
        "content": content,
      };
      final replyRes = await _api.sendRequest.post(
        "/blog/$uid",
        data: jsonEncode(mapData),
      );
      ApiResponse apiResponse = ApiResponse.fromResponse(replyRes);
      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }
      return Replies.fromJson(apiResponse.data);
    } on DioException catch (dioError) {
      if (dioError.type == DioExceptionType.connectionError) {
        throw "Connection error: Unable to connect to the server. Please check your internet connection.";
      } else if (dioError.type == DioExceptionType.connectionTimeout) {
        throw "Please Check your internet connection";
      } else {
        throw "An error occurred: ${dioError.message}";
      }
    } catch (ex) {
      rethrow;
    }
  }

  //delete reply
  Future<BlogModel> deleteReply({
    required String userId,
    required String blogId,
    required String replyId,
  }) async {
    try {
      Map<String, dynamic> mapData = {
        "user": userId,
        "blogId": blogId,
        "replyId": replyId
      };
      final res = await _api.sendRequest.delete(
        "/deleteReply",
        data: jsonEncode(mapData),
      );
      ApiResponse apiResponse = ApiResponse.fromResponse(res);
      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }
      return BlogModel.fromJson(apiResponse.data);
    } on DioException catch (dioError) {
      if (dioError.type == DioExceptionType.connectionError) {
        throw "Connection error: Unable to connect to the server. Please check your internet connection.";
      } else if (dioError.type == DioExceptionType.connectionTimeout) {
        throw "Please Check your internet connection";
      } else {
        throw "An error occurred: ${dioError.message}";
      }
    } catch (ex) {
      rethrow;
    }
  }

  //delete add blog
  Future<BlogModel> deleteBlog({
    required String userId,
    required String blogId,
  }) async {
    try {
      Map<String, dynamic> mapData = {"user": userId, "id": blogId};
      final res = await _api.sendRequest.delete(
        "/blog",
        data: jsonEncode(mapData),
      );
      ApiResponse apiResponse = ApiResponse.fromResponse(res);
      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }
      return BlogModel.fromJson(apiResponse.data);
    } on DioException catch (dioError) {
      if (dioError.type == DioExceptionType.connectionError) {
        throw "Connection error: Unable to connect to the server. Please check your internet connection.";
      } else if (dioError.type == DioExceptionType.connectionTimeout) {
        throw "Please Check your internet connection";
      } else {
        throw "An error occurred: ${dioError.message}";
      }
    } catch (ex) {
      rethrow;
    }
  }

  //remove reply to blog
  Future<BlogModel> updateBlog({
    required String user,
    required String id,
    required String title,
    required String content,
  }) async {
    try {
      Map<String, dynamic> updatedBlog = {
        "user": user,
        "id": id,
        "title": title,
        "content": content,
      };
      final response = await _api.sendRequest.put(
        "/blog",
        data: jsonEncode(updatedBlog),
      );
      ApiResponse apiResponse = ApiResponse.fromResponse(response);
      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }
      return BlogModel.fromJson(apiResponse.data);
    } on DioException catch (dioError) {
      if (dioError.type == DioExceptionType.connectionError) {
        throw "Connection error: Unable to connect to the server. Please check your internet connection.";
      } else if (dioError.type == DioExceptionType.connectionTimeout) {
        throw "Please Check your internet connection";
      } else {
        throw "An error occurred: ${dioError.message}";
      }
    } catch (ex) {
      rethrow;
    }
  }
}
