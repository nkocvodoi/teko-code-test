import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/color_model.dart';
import 'package:weather_app/models/error_product_model.dart';

import '../constants.dart';

abstract class IErrorProductAPI {
  Future<List<ColorModel>> getColors();
  Future<List<ErrorProduct>> getErrorProducts();
}

class ErrorProductAPI extends IErrorProductAPI {
  final http.Client httpClient;

  ErrorProductAPI(this.httpClient);

  @override
  Future<List<ColorModel>> getColors() async {
    final response = await httpClient.get(Uri.parse(colorUrl));

    if (response.statusCode != 200) {
      throw Exception('error retrieving colors');
    }

    return List<ColorModel>.from(
        json.decode(response.body).map((model) => ColorModel.fromJson(model)));
  }

  @override
  Future<List<ErrorProduct>> getErrorProducts() async {
    final response = await httpClient.get(Uri.parse(errorUrl));

    if (response.statusCode != 200) {
      throw Exception('error retrieving error products');
    }

    return List<ErrorProduct>.from(json
        .decode(response.body)
        .map((model) => ErrorProduct.fromJson(model)));
  }
}
