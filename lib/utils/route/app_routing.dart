import 'package:flutter/cupertino.dart';
import 'package:weather_app/pages/favourite_page.dart';
import 'package:weather_app/pages/home_page.dart';
import 'package:weather_app/pages/weather_page.dart';

enum RouteDefine { home, favoriteWeather, weather, editProduct, productPage }

class AppRouting {
  static final mainNavigationKey = GlobalKey<NavigatorState>();

  static CupertinoPageRoute generateMainRoute(RouteSettings settings) {
    final routes = <String, WidgetBuilder>{
      RouteDefine.home.name: (_) => const HomePage(),
      RouteDefine.favoriteWeather.name: (_) => const FavouritePage(),
      RouteDefine.weather.name: (_) => const WeatherPage(),
    };

    final routeBuilder = routes[settings.name];

    return CupertinoPageRoute(
      builder: routeBuilder!,
      settings: RouteSettings(name: settings.name),
    );
  }
}
