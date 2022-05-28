import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:weather_app/cubit/error_products/error_products_cubit.dart';
import 'package:weather_app/layouts/app_scaffold.dart';
import 'package:weather_app/models/error_product_model.dart';
import 'package:weather_app/pages/widgets/indicator_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<void>? _refreshCompleter;
  List<ErrorProduct>? _errorProducts;
  final _items = [
    "Item 0",
    "Item 1",
    "Item 2",
    "Item 3",
    "Item 4",
    "Item 5",
    "Item 6"
  ];
  late FToast fToast;

  bool isLoading = false;
  final GlobalKey<AnimatedListState> _animatedListKey = GlobalKey();

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
                    onRefresh: () => BlocProvider.of<ErrorProductCubit>(context).getErrorProducts(),
                    child: BlocBuilder<ErrorProductCubit, ErrorProductState>(
        builder: (context, state) {
          if (state is ErrorProductLoading) {
            return const IndicatorWidget();
          } else if (state is ErrorProductLoaded) {
            return _buildAnimatedList();
          } else if (state is ErrorProductError) {
            return buildMessageText(state.message);
          } else {
            return const IndicatorWidget();
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

  Widget _buildAnimatedList() => AnimatedList(
        key: _animatedListKey,
        physics: const BouncingScrollPhysics(),
        initialItemCount: _items.length,
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index, animation) {
          return SlideTransition(
            key: UniqueKey(),
            position: Tween<Offset>(
              begin: const Offset(-1, 0),
              end: const Offset(0, 0),
            ).animate(animation),
            child: SizedBox(
              height: 150,
              child: InkWell(
                onTap: () => _removeItem(index, context),
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  elevation: 10,
                  color: Colors
                      .primaries[(index * 100) % Colors.primaries.length][300],
                  child: Center(
                    child: Text(_items[index],
                        style: const TextStyle(fontSize: 28)),
                  ),
                ),
              ),
            ),
          );
        },
      );
}
