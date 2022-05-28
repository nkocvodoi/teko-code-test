import 'package:get_it/get_it.dart';
import 'package:weather_app/services/error_products/error_products_api.dart';
import 'package:weather_app/services/error_products/error_products_repository.dart';
import 'package:weather_app/services/repository.dart';
import 'package:weather_app/services/weather_api.dart';
import 'package:http/http.dart' as http;

GetIt injector = GetIt.instance;

Future<void> initializeDependency() async {
  injector.registerSingleton<http.Client>(http.Client());

  injector
      .registerSingleton<IWeatherApi>(WeatherApi(injector.get<http.Client>()));
  injector.registerSingleton<IErrorProductAPI>(
      ErrorProductAPI(injector.get<http.Client>()));
  injector.registerSingleton<IErrorProductRepository>(
      ErrorProductRepository(injector.get<IErrorProductAPI>()));
  injector
      .registerSingleton<IRepository>(Repository(injector.get<IWeatherApi>()));
}
