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

class LoadingMore extends ErrorProductState {
  final List<ErrorProduct> errorProducts;

  LoadingMore({required this.errorProducts}) : super();
}

class LoadedMore extends ErrorProductState {
  final List<ErrorProduct> errorProducts;

  LoadedMore({required this.errorProducts}) : super();
}

class ProductEditing extends ErrorProductState {}

class ProductEdited extends ErrorProductState {}


