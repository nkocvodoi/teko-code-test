import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:teko_test/cubit/error_products/error_products_cubit.dart';
import 'package:teko_test/layouts/app_scaffold.dart';
import 'package:teko_test/models/error_product_model.dart';
import 'package:teko_test/pages/widgets/dot_indicator_widget.dart';
import 'package:teko_test/pages/widgets/error_message.dart';
import 'package:teko_test/pages/widgets/error_products/product_overview.dart';
import 'package:teko_test/pages/widgets/error_products/submit_alert_dialog.dart';
import 'package:teko_test/pages/widgets/form/submit_button.dart';
import 'package:teko_test/pages/widgets/indicator_widget.dart';
import 'package:teko_test/utils/route/app_routing.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController _controller;
  late ErrorProductCubit _errCubit;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(_scrollListener);
    _errCubit = BlocProvider.of<ErrorProductCubit>(context);
  }

  void _scrollListener() {
    if (_controller.position.extentAfter < 10 && !_errCubit.isLoading) {
      _errCubit.loadmoreProducts();
    }
  }

  String colorToString(int? index) {
    return _errCubit.colorToString(index);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        isBack: false, isErrorPage: true, title: '', body: _buildBody());
  }

  Widget _buildBody() => SizedBox(
      height: MediaQuery.of(context).size.height,
      child: RefreshIndicator(
          color: Colors.transparent,
          backgroundColor: Colors.transparent,
          onRefresh: () => _errCubit.getErrorProducts(),
          child: BlocBuilder<ErrorProductCubit, ErrorProductState>(
            builder: (context, state) {
              if (state is ErrorProductLoading) {
                return const DotIndicatorWidget();
              } else if (state is ErrorProductLoaded) {
                return _buildList(state.errorProducts);
              } else if (state is LoadingMore) {
                return _buildList(state.errorProducts, isLoadmore: true);
              } else if (state is ErrorProductError) {
                return _buildErrorMessage(state.message);
              } else {
                return const DotIndicatorWidget();
              }
            },
          )));

  Widget _buildList(List<ErrorProduct> errProducts, {bool isLoadmore = false}) {
    bool hasFixed = _errCubit.fixSuccessProducts.isNotEmpty;
    return Stack(
      alignment: Alignment.center,
      children: [
        ListView.builder(
          controller: _controller,
          physics: const BouncingScrollPhysics(),
          itemCount: errProducts.length + 1,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          itemBuilder: (context, index) {
            bool isFixed = _errCubit.fixSuccessProducts.contains(index);
            if (index == errProducts.length && (isLoadmore || hasFixed)) {
              return const SizedBox(height: 100);
            } else if (index == errProducts.length) {
              return const SizedBox();
            } else {
              return ProductOverview(
                index: index,
                product: errProducts[index],
                isFixed: isFixed,
                onTap: () {
                  _errCubit.setEditIndex(index);
                  Navigator.pushNamed(context, RouteDefine.editProduct.name);
                },
                colorToString: colorToString(errProducts[index].color),
              );
            }
          },
        ),
        if (isLoadmore)
          const Positioned(bottom: 40, child: IndicatorWidget())
        else if (hasFixed)
          Positioned(
              bottom: 40,
              child: SubmitButton(onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SubmitAlertDialog(
                        context: context,
                        onSave: () => _errCubit.confirmFixedList(),
                        products: _errCubit.displayErrorProducts,
                        productsIndex: _errCubit.fixSuccessProducts,
                        colorsToString: _errCubit.convertColorsToListString(),
                      );
                    });
              }))
      ],
    );
  }

  Widget _buildErrorMessage(String message) => ErrorMessage(
        message: message,
        reload: () {
          _errCubit.getErrorProducts();
        },
      );
}
