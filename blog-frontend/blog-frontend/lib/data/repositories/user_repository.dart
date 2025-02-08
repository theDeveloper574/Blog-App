import 'dart:convert';
import 'dart:io';

import 'package:blog/core/api.dart';
import 'package:blog/data/models/user/user_model.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class UserRepository {
  final _api = Api();
  //login user
  Future<UserModel> logIn({
    required String email,
    required String password,
  }) async {
    try {
      Response response = await _api.sendRequest.post(
        "/user/logIn",
        data: jsonEncode(
          {"email": email, "password": password},
        ),
      );
      ApiResponse apiResponse = ApiResponse.fromResponse(response);
      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }
      return UserModel.fromJson(apiResponse.data);
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

  //create new account
  Future<UserModel> createUser({
    required String name,
    required String email,
    required String password,
    File? avatar,
  }) async {
    // Create a map for the form data
    final Map<String, dynamic> formDataMap = {
      "fullName": name,
      "email": email,
      "password": password,
    };

    // Add the avatar only if it is not null and not empty
    if (avatar != null && avatar.path.isNotEmpty) {
      formDataMap["avatar"] = await MultipartFile.fromFile(avatar.path);
    }
    // Convert the map to FormData\\
    FormData data = FormData.fromMap(formDataMap);
    try {
      Response response =
          await _api.sendRequest.post("/user/createAccount", data: data);
      ApiResponse apiResponse = ApiResponse.fromResponse(response);
      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }
      return UserModel.fromJson(apiResponse.data);
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

  Future<UserModel> updateUserInfo(
    UserModel user, {
    XFile? newAvatar,
  }) async {
    try {
      // Prepare form data map from UserModel
      final Map<String, dynamic> formDataMap = user.toJson();

      // Check if the user selected a new avatar (Local File)
      if (newAvatar != null && newAvatar.path.isNotEmpty) {
        formDataMap["avatar"] = await MultipartFile.fromFile(newAvatar.path);
      }

      // Convert map to FormData
      FormData data = FormData.fromMap(formDataMap);

      // Send the PUT request to update user information
      final response =
          await _api.sendRequest.put("/user/${user.sId}", data: data);

      // Handle API response
      ApiResponse apiResponse = ApiResponse.fromResponse(response);
      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }

      // Return the updated UserModel from the API response
      return UserModel.fromJson(apiResponse.data);
    } on DioException catch (dioError) {
      if (dioError.type == DioExceptionType.connectionError) {
        throw "Connection error: Unable to connect to the server. Please check your internet connection.";
      } else {
        throw "An error occurred: ${dioError.message}";
      }
    } catch (ex) {
      rethrow;
    }
  }
}
