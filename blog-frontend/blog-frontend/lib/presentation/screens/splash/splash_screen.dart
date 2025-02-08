import 'dart:async';

import 'package:blog/core/app_assets.dart';
import 'package:blog/logic/cubits/user/user_cubit.dart';
import 'package:blog/logic/cubits/user/user_state.dart';
import 'package:blog/presentation/screens/NavBar/nav_bar_screen.dart';
import 'package:blog/presentation/screens/splash/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/ui.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const routeName = "splash";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void _checkUserStatus() {
    UserState userState = BlocProvider.of<UserCubit>(context).state;
    if (userState is UserLoadedState) {
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacementNamed(context, NavBarScreen.routeName);
    } else if (userState is UserLoggedOutState) {
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacementNamed(context, Welcome.routeName);
    } else if (userState is UserErrorState) {
      toast(message: userState.message.toString());
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacementNamed(context, Welcome.routeName);
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 100), () => _checkUserStatus());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        _checkUserStatus();
      },
      child: Scaffold(
        body: Container(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(AppAssets.splash),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.sizeOf(context).height / 8,
            ),
            child: const Align(
              alignment: Alignment.bottomCenter,
              child: CircularProgressIndicator(
                color: AppColors.whiteColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
