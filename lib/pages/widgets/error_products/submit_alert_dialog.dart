import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:teko_test/cubit/error_products/error_products_cubit.dart';
import 'package:teko_test/models/error_product_model.dart';
import 'package:teko_test/pages/widgets/error_products/product_overview.dart';

class SubmitAlertDialog extends StatefulWidget {
  final BuildContext context;
  final Function() onSave;
  final List<int> productsIndex;
  final List<ErrorProduct> products;
  final List<String> colorsToString;
  const SubmitAlertDialog(
      {Key? key,
      required this.context,
      required this.onSave,
      required this.productsIndex,
      required this.products,
      required this.colorsToString})
      : super(key: key);

  @override
  State<SubmitAlertDialog> createState() => _SubmitAlertDialogState();
}

class _SubmitAlertDialogState extends State<SubmitAlertDialog> {
  bool isSaveSuccess = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Submit"),
      titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
      actionsOverflowButtonSpacing: 20,
      actions: [
        if (!isSaveSuccess)
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.red),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Back")),
        if (!isSaveSuccess)
          ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.green),
              onPressed: () {
                widget.onSave();
                setState(() {
                  isSaveSuccess = true;
                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.pop(context);
                  });
                });
              },
              child: const Text("Save")),
      ],
      content: isSaveSuccess
          ? Padding(
              padding: EdgeInsets.all(30),
              child: Lottie.asset('assets/images/success.json', width: 40),
            )
          : SizedBox(
              height: 60.h,
              width: 80.w,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: widget.productsIndex.length,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                itemBuilder: (context, index) {
                  int _productIndex = widget.productsIndex[index];
                  ErrorProduct _product = widget.products[_productIndex];
                  String colorToString = widget.colorsToString[_productIndex];
                  return ProductOverview(
                    disable: true,
                    index: _productIndex,
                    product: _product,
                    isFixed: true,
                    onTap: () {},
                    colorToString: colorToString,
                  );
                },
              ),
            ),
    );
  }
}
