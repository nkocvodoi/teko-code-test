import 'package:flutter/cupertino.dart';
import 'package:teko_test/pages/home_page.dart';
import 'package:teko_test/pages/product_edit.dart';

enum RouteDefine { home, favoriteWeather, weather, editProduct, productPage }

class AppRouting {
  static final mainNavigationKey = GlobalKey<NavigatorState>();

  static CupertinoPageRoute generateMainRoute(RouteSettings settings) {
    final routes = <String, WidgetBuilder>{
      RouteDefine.home.name: (_) => const HomePage(),
      RouteDefine.editProduct.name: (_) => const ProductEditPage(),
    };

    final routeBuilder = routes[settings.name];

    return CupertinoPageRoute(
      builder: routeBuilder!,
      settings: RouteSettings(name: settings.name),
    );
  }
}
