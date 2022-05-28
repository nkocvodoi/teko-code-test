part of 'error_products_cubit.dart';

@immutable
abstract class ErrorProductState {}

class ErrorProductInitial extends ErrorProductState {}

class ErrorProductLoading extends ErrorProductState {}

class ErrorProductLoaded extends ErrorProductState {
  final List<ErrorProduct> errorProducts;

  ErrorProductLoaded({required this.errorProducts}) : super();
}

class ErrorProductError extends ErrorProductState {
  final String message;
  ErrorProductError(this.message);
}

class ColorLoading extends ErrorProductState {}

class ColorLoaded extends ErrorProductState {
  final List<ColorModel> colors;

  ColorLoaded({required this.colors}) : super();
}

class ColorError extends ErrorProductState {
  final String message;
  ColorError(this.message);
}
