import 'dart:io';

import 'package:blog/data/models/user/user_model.dart';
import 'package:blog/data/repositories/user_repository.dart';
import 'package:blog/logic/cubits/user/user_state.dart';
import 'package:blog/logic/services/preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitialState()) {
    _initializeUser();
  }
  void _initializeUser() async {
    final userDetails = await Preferences.getUser();
    String? email = userDetails["email"];
    String? password = userDetails["password"];
    if (email == null || password == null) {
      emit(UserLoggedOutState());
    } else {
      logIn(email: email, password: password);
    }
  }

  final _api = UserRepository();
  //sign in cubit
  Future<void> logIn({
    required String email,
    required String password,
  }) async {
    emit(UserLoadingState());
    try {
      UserModel response = await _api.logIn(
        email: email,
        password: password,
      );
      emit(UserLoadedState(response));
    } catch (ex) {
      emit(UserErrorState(ex.toString()));
    }
  }

  //create account cubit
  Future<void> createAccount({
    required String name,
    required String email,
    required String password,
    File? avatar,
  }) async {
    try {
      emit(UserLoadingState());
      UserModel response = await _api.createUser(
        name: name,
        email: email,
        password: password,
        avatar: avatar,
      );
      emit(UserLoadedState(response));
    } catch (ex) {
      emit(UserErrorState(ex.toString()));
    }
  }

  //update user cubit
  Future<bool> updateUser(UserModel user, {XFile? avatar}) async {
    try {
      emit(UserLoadingState());
      final res = await _api.updateUserInfo(user, newAvatar: avatar);
      emit(UserLoadedState(res));
      return true;
    } catch (ex) {
      emit(UserErrorState(ex.toString()));
      return false;
    }
  }

  Future<void> logOut() async {
    await Preferences.clearUser();
    emit(UserLoggedOutState());
  }
}
