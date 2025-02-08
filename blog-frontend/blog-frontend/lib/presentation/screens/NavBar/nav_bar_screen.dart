import 'package:blog/core/ui.dart';
import 'package:blog/logic/cubits/user/user_cubit.dart';
import 'package:blog/logic/cubits/user/user_state.dart';
import 'package:blog/presentation/screens/Blog/add_blog.dart';
import 'package:blog/presentation/screens/NavBar/favourite.dart';
import 'package:blog/presentation/screens/NavBar/home.dart';
import 'package:blog/presentation/screens/NavBar/profile.dart';
import 'package:blog/presentation/screens/splash/splash_screen.dart';
import 'package:double_tap_to_exit/double_tap_to_exit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavBarScreen extends StatefulWidget {
  const NavBarScreen({super.key});
  static const routeName = "navBar";

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  int _currentIndex = 0;
  late PageController _pageController;
  List<Widget> screens = const [
    Home(),
    Favourite(),
    Profile(),
  ];

  @override
  void initState() {
    _pageController = PageController(initialPage: _currentIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DoubleTapToExit(
      snackBar: SnackBar(
        content: Text(
          "Tap to exit again",
          style: TextStyles.body3.copyWith(
            color: AppColors.whiteColor,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      child: BlocListener<UserCubit, UserState>(
        listener: (context, state) {
          if (state is UserLoggedOutState) {
            Navigator.pushReplacementNamed(context, SplashScreen.routeName);
          }
        },
        child: Scaffold(
          body: PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            elevation: 2.0,
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: (index) {
              _onPageChanged(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: "Favourite",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profile",
              ),
            ],
          ),
          floatingActionButton: _currentIndex == 0
              ? FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AddBlog.routeName,
                      arguments: {
                        "showAdd": false,
                      },
                    );
                  },
                  label: Text(
                    'Create',
                    style: TextStyles.body2,
                  ),
                  icon: const Icon(
                    Icons.add,
                    size: 18,
                    color: Colors.black,
                  ),
                  backgroundColor: const Color(0xffB2D1FF),
                )
              : null,
        ),
      ),
    );
  }

  void _onPageChanged(int index) {
    final adjustedIndex = index;
    setState(() {
      _currentIndex = adjustedIndex;
      _pageController.jumpToPage(adjustedIndex);
    });
  }
}
