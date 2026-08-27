import 'package:go_router/go_router.dart';
import 'package:weather/core/router/router_path.dart';
import 'package:weather/feature/home_page/presentation/UI/page/home_page.dart';
import 'package:weather/feature/search_page/presentation/UI/page/search_page.dart';

class RouterInit {
  factory RouterInit() => _instance ??= RouterInit._();
  RouterInit._();
  static RouterInit? _instance;

  static final GoRouter router = GoRouter(
    initialLocation: RouterPath.homePage,
    routes: [
      GoRoute(
        path: RouterPath.homePage,
        builder: (context, state) => HomePage(),
        routes: [
          GoRoute(
            path: RouterPath.searchPage,
            name: RouterPath.searchPage,
            builder: (context, state) => SearchPage(),
          ),
        ],
      ),
    ],
  );
}
