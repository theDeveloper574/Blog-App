import 'package:blog/core/app_assets.dart';
import 'package:blog/core/ui.dart';
import 'package:blog/presentation/screens/auth/create_account.dart';
import 'package:blog/presentation/screens/auth/login_screen.dart';
import 'package:blog/presentation/widgets/ButtonWidget.dart';
import 'package:flutter/material.dart';

import '../../widgets/gap_widget.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});
  static const String routeName = "welcome";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const GapWidget(),
            SizedBox(
              height: MediaQuery.sizeOf(context).height / 2.2,
              width: double.infinity,
              child: Image.asset(
                AppAssets.welcome,
              ),
            ),
            Text(
              "Hey! Welcome",
              textAlign: TextAlign.center,
              style: TextStyles.heading3,
            ),
            const GapWidget(
              height: -10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                welcomeText,
                textAlign: TextAlign.center,
                style: TextStyles.body1,
              ),
            ),
            const GapWidget(
              height: 20,
            ),
            ButtonWidget(
              text: "Log In",
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.routeName);
              },
            ),
            const GapWidget(
              height: -4,
            ),
            ButtonWidget(
              text: "Create Account",
              onPressed: () {
                Navigator.pushNamed(context, CreateAccount.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
