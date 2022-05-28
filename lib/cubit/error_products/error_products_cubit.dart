import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:weather_app/models/color_model.dart';
import 'package:weather_app/models/error_product_model.dart';
import 'package:weather_app/models/favourite.dart';
import 'package:weather_app/services/error_products/error_products_repository.dart';
import 'package:weather_app/utils/extensions.dart';

part 'error_products_state.dart';

class ErrorProductCubit extends Cubit<ErrorProductState> {
  final IErrorProductRepository _repository;

  ErrorProductCubit(this._repository) : super(ErrorProductInitial()) {
    getErrorProducts();
  }

  List<ErrorProduct> errorProducts = [];
  List<ColorModel> colors = [];

  Future<void> getColors() async {
    try {
      emit(ColorLoading());
      colors = await _repository.getColors();
      emit(ColorLoaded(colors: colors));
    } catch (_) {
      if (_.toString().contains('error retrieving colors')) {
        emit(ColorError("Colors not found."));
      } else {
        emit(ColorError(
            "Network error, please check your Internet connection then try again."));
      }
    }
  }

  Future<void> getErrorProducts() async {
    try {
      emit(ErrorProductLoading());
      errorProducts = await _repository.getErrorProducts();
      emit(ErrorProductLoaded(errorProducts: errorProducts));
    } catch (_) {
      if (_.toString().contains('error retrieving error products')) {
        emit(ErrorProductError("Products not found."));
      } else {
        emit(ErrorProductError(
            "Network error, please check your Internet connection then try again."));
      }
    }
  }

  @override
  void onChange(Change<ErrorProductState> change) {
    // TODO: implement onChange
    super.onChange(change);
    print(change);
  }
}
