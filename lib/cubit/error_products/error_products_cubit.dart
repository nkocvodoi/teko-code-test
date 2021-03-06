import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:teko_test/models/color_model.dart';
import 'package:teko_test/models/error_product_model.dart';
import 'package:teko_test/services/error_products/error_products_repository.dart';

part 'error_products_state.dart';

class ErrorProductCubit extends Cubit<ErrorProductState> {
  final IErrorProductRepository _repository;

  ErrorProductCubit(this._repository) : super(ErrorProductInitial()) {
    getColors().then((value) => getErrorProducts());
  }

  var fbKey = GlobalKey<FormBuilderState>();

  List<ErrorProduct> errorProducts = [];
  List<ErrorProduct> displayErrorProducts = [];
  List<ColorModel> colors = [];
  int productPerPage = 10;
  int currentIndexEdit = 0;
  int totalProducts = 0;
  bool isLoading = false;
  List<int> fixSuccessProducts = [];
  bool submitSuccess = false;

  String colorToString(int? index) {
    return index != null
        ? colors.firstWhere((element) => element.id == index).name
        : 'null';
  }

  List<String> convertColorsToListString() {
    List<String> colorsToString = [];
    displayErrorProducts.forEach((element) {
      colorsToString.add(colorToString(element.color));
    });
    return colorsToString;
  }

  void setEditIndex(int index) {
    currentIndexEdit = index;
  }

  void resetAllData() {
    errorProducts = [];
    displayErrorProducts = [];
    colors = [];
    currentIndexEdit = 0;
    totalProducts = 0;
    isLoading = false;
    fixSuccessProducts = [];
  }

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
      resetAllData();
      await getColors();
      errorProducts = await _repository.getErrorProducts();
      displayErrorProducts = errorProducts.sublist(0, productPerPage);
      totalProducts = displayErrorProducts.length;
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

  Future<void> loadmoreProducts() async {
    if (displayErrorProducts.length < errorProducts.length && !isLoading) {
      isLoading = true;
      emit(LoadingMore(errorProducts: displayErrorProducts));
      Future.delayed(const Duration(seconds: 2), () {
        int sublistLower = displayErrorProducts.length < errorProducts.length
            ? displayErrorProducts.length
            : errorProducts.length;
        int sublistUpper =
            displayErrorProducts.length + productPerPage < errorProducts.length
                ? displayErrorProducts.length + productPerPage
                : errorProducts.length;
        List<ErrorProduct> productAddUp =
            errorProducts.sublist(sublistLower, sublistUpper);
        displayErrorProducts.addAll(productAddUp);
        totalProducts = displayErrorProducts.length;
        emit(ErrorProductLoaded(errorProducts: displayErrorProducts));
        isLoading = false;
      });
    }
  }

  Future<void> editProducts() async {
    var data = fbKey.currentState!.value;
    emit(ErrorProductLoading());
    var errProduct = errorProducts[currentIndexEdit];
    errorProducts[currentIndexEdit] = ErrorProduct(
        id: errProduct.id,
        errorDescription: errProduct.errorDescription,
        image: errProduct.image,
        color: data['color'],
        name: data["name"],
        sku: data["sku"]);
    displayErrorProducts = errorProducts.sublist(0, totalProducts);
    if (!fixSuccessProducts.contains(currentIndexEdit))
      fixSuccessProducts.add(currentIndexEdit);
    emit(ErrorProductLoaded(errorProducts: displayErrorProducts));
  }

  Future<void> confirmFixedList() async {
    emit(ErrorProductLoading());
    fixSuccessProducts.sort();
    for (var i = fixSuccessProducts.length - 1; i >= 0; i--) {
      errorProducts.removeAt(fixSuccessProducts[i]);
      displayErrorProducts.removeAt(fixSuccessProducts[i]);
    }
    totalProducts = displayErrorProducts.length;
    submitSuccess = true;
    fixSuccessProducts = [];
    emit(ErrorProductLoaded(errorProducts: displayErrorProducts));
  }
}
