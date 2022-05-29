import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
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
  Completer<void>? _refreshCompleter;
  List<ErrorProduct>? _errorProducts;
  final _items = [];
  late FToast fToast;

  bool isLoading = false;
  final GlobalKey<AnimatedListState> _animatedListKey = GlobalKey();
  late ScrollController _controller;

  void _addItem() {
    _items.insert(0, "Item ${_items.length + 1}");
    _animatedListKey.currentState!
        .insertItem(0, duration: const Duration(seconds: 1));
  }

  // Remove an item
  // This is trigger when an item is tapped
  void _removeItem(int index, BuildContext context) {
    AnimatedList.of(context).removeItem(index, (_, animation) {
      return SlideTransition(
        key: UniqueKey(),
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: const Offset(0, 0),
        ).animate(animation),
        child: SizedBox(
          height: 150,
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 20),
            elevation: 10,
            color: Colors.primaries[(index * 100) % Colors.primaries.length]
                [300],
            child: const Center(
              child:
                  Text("I am going away", style: const TextStyle(fontSize: 28)),
            ),
          ),
        ),
      );
    }, duration: const Duration(milliseconds: 500));
    _items.removeAt(index);
  }

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    fToast = FToast();
    fToast.init(context);
    _controller = ScrollController()..addListener(_scrollListener);
  }

  void _scrollListener() {
    print(_controller.position.extentAfter);
    // if (_controller.position.extentAfter < 10) {
    //   BlocProvider.of<ErrorProductCubit>(context).loadmoreProducts();
    // }
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
          onRefresh: () =>
              BlocProvider.of<ErrorProductCubit>(context).getErrorProducts(),
          child: BlocBuilder<ErrorProductCubit, ErrorProductState>(
            builder: (context, state) {
              if (state is ErrorProductLoading) {
                return const DotIndicatorWidget();
              } else if (state is ErrorProductLoaded) {
                return _buildAnimatedList(state.errorProducts);
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

  Widget _buildAnimatedList(List<ErrorProduct> errProducts,
          {bool isLoadmore = true}) =>
      AnimatedList(
        key: _animatedListKey,
        controller: _controller,
        physics: const BouncingScrollPhysics(),
        initialItemCount: errProducts.length + 1,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        itemBuilder: (context, index, animation) {
          return index == errProducts.length
              ? isLoadmore
                  ? const IndicatorWidget()
                  : const SizedBox()
              : SlideTransition(
                  key: UniqueKey(),
                  position: Tween<Offset>(
                    begin: const Offset(-1, 0),
                    end: const Offset(0, 0),
                  ).animate(animation),
                  child: _product(errProducts[index]),
                );
        },
      );

  Widget _product(ErrorProduct product) => SizedBox(
      child: Card(
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
              constraints: const BoxConstraints(minHeight: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: Text(
                                product.errorDescription,
                                style: TextStyle(
                                    fontSize: 20, color: Colors.red.shade400),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: Text(
                                product.sku!,
                                style: const TextStyle(
                                    fontSize: 18, fontStyle: FontStyle.italic),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: Text(
                                colorToString(product.color),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        )),
                  ),
                  const CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 30,
                    ),
                  )
                ],
              ),
            ),
          )));

  String colorToString(int? index) {
    return BlocProvider.of<ErrorProductCubit>(context).colorToString(index);
  }
}
