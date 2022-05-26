import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:weather_app/models/favourite.dart';
import 'package:weather_app/utils/extensions.dart';

part 'error_products_state.dart';

class EProductCubit extends Cubit<EProductState> {
  final IRepository _repository;

  EProductCubit() : super(EProductInitial());
}
