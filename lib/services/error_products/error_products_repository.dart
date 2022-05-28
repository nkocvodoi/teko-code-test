import 'package:weather_app/models/color_model.dart';
import 'package:weather_app/models/error_product_model.dart';
import 'package:weather_app/services/error_products/error_products_api.dart';

abstract class IErrorProductRepository {
  Future<List<ColorModel>> getColors();
  Future<List<ErrorProduct>> getErrorProducts();
}

class ErrorProductRepository extends IErrorProductRepository {
  final IErrorProductAPI errorProductAPI;
  ErrorProductRepository(this.errorProductAPI);

  @override
  Future<List<ColorModel>> getColors() async {
    final colors = await errorProductAPI.getColors();
    return colors;
  }

  @override
  Future<List<ErrorProduct>> getErrorProducts() async {
    final errProducts = await errorProductAPI.getErrorProducts();
    return errProducts;
  }
}

class NetworkException implements Exception {}
