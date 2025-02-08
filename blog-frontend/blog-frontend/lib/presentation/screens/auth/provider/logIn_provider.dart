import 'dart:async';
import 'dart:developer';

import 'package:blog/logic/cubits/user/user_cubit.dart';
import 'package:blog/logic/cubits/user/user_state.dart';
import 'package:blog/logic/services/formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogInProvider extends ChangeNotifier {
  final BuildContext context;
  LogInProvider(this.context) {
    _listToUserChanges();
  }
  StreamSubscription? _userCubitStream;
  bool isSignIn = false;
  String error = "";
  void _listToUserChanges() {
    log("listening to user state");
    _userCubitStream =
        BlocProvider.of<UserCubit>(context).stream.listen((state) {
      if (state is UserLoadingState) {
        isSignIn = true;
        error = "";
        notifyListeners();
      } else if (state is UserErrorState) {
        isSignIn = false;
        error = state.message.toString();
        notifyListeners();
      } else {
        isSignIn = false;
        error = "";
      }
    });
  }

  final emailCon = TextEditingController();
  final passCon = TextEditingController();
  final key = GlobalKey<FormState>();
  bool isRemember = false;
  bool isShowPass = true;
  onChanged(bool? val) {
    if (isRemember) {
      isRemember = false;
    } else {
      isRemember = true;
    }
    notifyListeners();
  }

  void onShowPass() {
    if (isShowPass) {
      isShowPass = false;
    } else {
      isShowPass = true;
    }
    notifyListeners();
  }

  void login() {
    if (!key.currentState!.validate()) return;
    Formatter.hideKeyboard();
    String email = emailCon.text.trim();
    String password = passCon.text.trim();
    BlocProvider.of<UserCubit>(context).logIn(
      email: email,
      password: password,
    );
  }

  @override
  void dispose() {
    _userCubitStream?.cancel();
    super.dispose();
  }
}
