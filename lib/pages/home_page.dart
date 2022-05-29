import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:weather_app/cubit/error_products/error_products_cubit.dart';
import 'package:weather_app/layouts/app_scaffold.dart';
import 'package:weather_app/models/error_product_model.dart';
import 'package:weather_app/pages/widgets/dot_indicator_widget.dart';
import 'package:weather_app/pages/widgets/image_network.dart';
import 'package:weather_app/pages/widgets/indicator_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  late ScrollController _controller;
  late ErrorProductCubit _errCubit;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_controller.position.extentAfter < 10 && !_errCubit.isLoading) {
      _errCubit.loadmoreProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    _errCubit = BlocProvider.of<ErrorProductCubit>(context);
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
                return _buildListLoading(state.errorProducts);
              } else if (state is LoadingMore) {
                return _buildListLoading(state.errorProducts, isLoadmore: true);
              } else if (state is ErrorProductError) {
                return buildMessageText(state.message);
              } else {
                return const DotIndicatorWidget();
              }
            },
          )));

  Widget buildMessageText(String message) {
    return Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Center(
            child: Text(message,
                style: const TextStyle(fontSize: 21, color: Colors.red))));
  }

  Widget _buildListLoading(List<ErrorProduct> errProducts,
          {bool isLoadmore = false}) =>
      Stack(
        alignment: Alignment.center,
        children: [
          _buildAnimatedList(errProducts),
          if (isLoadmore) const Positioned(bottom: 40, child: IndicatorWidget())
        ],
      );

  Widget _buildAnimatedList(List<ErrorProduct> errProducts) => ListView.builder(
        controller: _controller,
        physics: const BouncingScrollPhysics(),
        itemCount: errProducts.length,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        itemBuilder: (context, index) {
          return _product(errProducts[index]);
        },
      );

  Widget _product(ErrorProduct product) => SizedBox(
          child: Stack(
        children: [
          Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              elevation: 2,
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  color: Colors.black,
                  width: 0.2,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  debugPrint('Card tapped.');
                },
                child: Container(
                  constraints: const BoxConstraints(minHeight: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(flex: 1, child: ImageNetwork(product.image)),
                      Expanded(
                        flex: 2,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  child: Text(
                                    product.name!,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  child: Text(
                                    product.sku!,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    child: Row(
                                      children: [
                                        Container(),
                                        Text(
                                          colorToString(product.color),
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )),
                              ],
                            )),
                      ),
                      const CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      )
                    ],
                  ),
                ),
              )),
          Positioned(
              top: 20,
              left: 0,
              child: Container(
                color: Colors.red.shade400,
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Text(
                  product.errorDescription,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ))
        ],
      ));

  String colorToString(int? index) {
    return _errCubit.colorToString(index);
  }
}
