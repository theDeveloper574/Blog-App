import 'package:blog/data/models/blogs/blog_model.dart';
import 'package:blog/presentation/screens/Blog/my_blogs.dart';
import 'package:blog/presentation/screens/Blog/provider/add_blog_provider.dart';
import 'package:blog/presentation/screens/auth/update_profile.dart';
import 'package:blog/presentation/screens/splash/welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../presentation/screens/Blog/add_blog.dart';
import '../presentation/screens/NavBar/nav_bar_screen.dart';
import '../presentation/screens/auth/create_account.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/provider/create_account_provider.dart';
import '../presentation/screens/auth/provider/logIn_provider.dart';
import '../presentation/screens/splash/splash_screen.dart';

class Routes {
  static Route? routeSetting(RouteSettings route) {
    switch (route.name) {
      case SplashScreen.routeName:
        return CupertinoPageRoute(builder: (context) => const SplashScreen());

      case NavBarScreen.routeName:
        return CupertinoPageRoute(builder: (context) => const NavBarScreen());

      case Welcome.routeName:
        return CupertinoPageRoute(builder: (context) => const Welcome());

      case AddBlog.routeName:
        final args = route.arguments as Map<String, dynamic>;
        return CupertinoPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => AddBlogProvider(context),
            child: AddBlog(
              showAdd: args["showAdd"] as bool, // Extract the boolean flag
              blogModel:
                  args["blogModel"] as BlogModel?, // Extract the BlogModel
            ),
          ),
          fullscreenDialog: true,
        );

      case MyBlogs.routeName:
        return CupertinoPageRoute(
          builder: (context) => MyBlogs(
            userId: route.arguments.toString(),
          ),
        );
      case CreateAccount.routeName:
        return CupertinoPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => CreateAccProvider(context),
            child: const CreateAccount(),
          ),
        );

      case LoginScreen.routeName:
        return CupertinoPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => LogInProvider(context),
            child: const LoginScreen(),
          ),
        );
      case UpdateProfile.routeName:
        return CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (context) => ChangeNotifierProvider(
            create: (context) => CreateAccProvider(context),
            child: UpdateProfile(),
          ),
        );

      default:
        return null;
    }
  }
}
