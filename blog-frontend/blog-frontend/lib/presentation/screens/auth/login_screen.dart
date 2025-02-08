import 'package:blog/core/ui.dart';
import 'package:blog/logic/cubits/user/user_cubit.dart';
import 'package:blog/logic/cubits/user/user_state.dart';
import 'package:blog/logic/services/preferences.dart';
import 'package:blog/presentation/screens/NavBar/nav_bar_screen.dart';
import 'package:blog/presentation/screens/auth/provider/logIn_provider.dart';
import 'package:blog/presentation/widgets/ButtonWidget.dart';
import 'package:blog/presentation/widgets/gap_widget.dart';
import 'package:blog/presentation/widgets/textField_widget.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../widgets/link_button.dart';
import 'create_account.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const routeName = "loginscreen";
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final userPro = Provider.of<LogInProvider>(context);
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) async {
        if (state is UserLoadedState) {
          if (userPro.isRemember) {
            await Preferences.saveUser(
              userPro.emailCon.text.trim(),
              userPro.passCon.text,
            );
          }
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacementNamed(context, NavBarScreen.routeName);
        }
        if (state is UserErrorState) {
          toast(message: "Error: ${userPro.error.toString()}");
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: userPro.key,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GapWidget(
                  height: MediaQuery.sizeOf(context).height * 0.08,
                ),
                Text(
                  "Log In",
                  style: TextStyles.heading3.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyles.body1.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    LinkButton(
                      text: "Create Account",
                      onTap: () {
                        Navigator.pushNamed(context, CreateAccount.routeName);
                      },
                    ),
                  ],
                ),
                const GapWidget(),
                TextFieldWidget(
                  keyboardType: TextInputType.emailAddress,
                  buttonAction: TextInputAction.next,
                  hintText: "Email",
                  controller: userPro.emailCon,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Please Enter email";
                    }
                    if (!EmailValidator.validate(val)) {
                      return "Enter valid email";
                    }
                    return null;
                  },
                ),
                const GapWidget(),
                TextFieldWidget(
                  onSubmit: (val) => userPro.login,
                  obscure: userPro.isShowPass,
                  buttonAction: TextInputAction.done,
                  controller: userPro.passCon,
                  maxLines: 1,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Please Enter Password";
                    }
                    if (val.length < 5) {
                      return "Password cannot be less then 5";
                    }
                    return null;
                  },
                  hintText: "Password",
                  preFix: InkWell(
                    onTap: userPro.onShowPass,
                    child: Icon(
                      userPro.isShowPass
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.greyColor,
                    ),
                  ),
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Remember Me"),
                  value: userPro.isRemember,
                  onChanged: userPro.onChanged,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const GapWidget(),
                ButtonWidget(
                  text: "Log In",
                  isShowLoading: userPro.isSignIn,
                  onPressed: userPro.login,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
