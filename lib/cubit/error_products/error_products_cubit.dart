import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:weather_app/models/color_model.dart';
import 'package:weather_app/models/error_product_model.dart';
import 'package:weather_app/services/error_products/error_products_repository.dart';

part 'error_products_state.dart';

class ErrorProductCubit extends Cubit<ErrorProductState> {
  final IErrorProductRepository _repository;

  ErrorProductCubit(this._repository) : super(ErrorProductInitial()) {
    getColors().then((value) => getErrorProducts());
  }

  List<ErrorProduct> errorProducts = [];
  List<ErrorProduct> displayErrorProducts = [];
  List<ColorModel> colors = [];
  int productPerPage = 10;
  int currentIndexEdit = 0;

  Future<void> getColors() async {
    try {
      emit(ErrorProductLoading());
      colors = await _repository.getColors();
    } catch (_) {
      if (_.toString().contains('error retrieving colors')) {
        emit(ErrorProductError("Colors not found."));
      } else {
        emit(ErrorProductError(
            "Network error, please check your Internet connection then try again."));
      }
    }
  }

  Future<void> getErrorProducts() async {
    try {
      emit(ErrorProductLoading());
      await getColors();
      errorProducts = await _repository.getErrorProducts();
      displayErrorProducts = errorProducts.sublist(1, productPerPage);
      emit(ErrorProductLoaded(errorProducts: displayErrorProducts));
    } catch (_) {
      if (_.toString().contains('error retrieving error products')) {
        emit(ErrorProductError("Products not found."));
      } else {
        emit(ErrorProductError(
            "Network error, please check your Internet connection then try again."));
      }
    }
  }

  void loadmoreProducts() {
    if (displayErrorProducts.length < errorProducts.length) {
      emit(LoadingMore(errorProducts: displayErrorProducts));
      int sublistLower = displayErrorProducts.length + 1 < errorProducts.length
          ? displayErrorProducts.length + 1
          : errorProducts.length;
      int sublistUpper =
          displayErrorProducts.length + productPerPage < errorProducts.length
              ? displayErrorProducts.length + productPerPage
              : errorProducts.length;
      List<ErrorProduct> productAddUp =
          errorProducts.sublist(sublistLower, sublistUpper);
      displayErrorProducts.addAll(productAddUp);
      emit(LoadedMore(errorProducts: displayErrorProducts));
    }
  }

  String colorToString(int? index) {
    return index != null
        ? colors.firstWhere((element) => element.id == index).name
        : 'null';
  }

  @override
  void onChange(Change<ErrorProductState> change) {
    // TODO: implement onChange
    super.onChange(change);
    print(change);
  }
}
