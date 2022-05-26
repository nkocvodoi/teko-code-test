part of 'error_products_cubit.dart';

@immutable
abstract class EProductState {}

class EProductInitial extends EProductState {}

class FavouriteLoaded extends EProductState {
  final List<Favourite> favoriteList;

  FavouriteLoaded({required this.favoriteList}) : super();
}
