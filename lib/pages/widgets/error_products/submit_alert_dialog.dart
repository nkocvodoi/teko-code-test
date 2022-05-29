import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:teko_test/cubit/error_products/error_products_cubit.dart';
import 'package:teko_test/models/error_product_model.dart';
import 'package:teko_test/pages/widgets/error_products/product_overview.dart';

class SubmitAlertDialog extends StatefulWidget {
  final BuildContext context;
  const SubmitAlertDialog({Key? key, required this.context}) : super(key: key);

  @override
  State<SubmitAlertDialog> createState() => _SubmitAlertDialogState();
}

class _SubmitAlertDialogState extends State<SubmitAlertDialog> {
  late ErrorProductCubit _cubit;

  @override
  void initState() {
    _cubit = BlocProvider.of<ErrorProductCubit>(context);
    super.initState();
  }
   @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Submit"),
      titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
      actionsOverflowButtonSpacing: 20,
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Back")),
        ElevatedButton(onPressed: () {
          _cubit.confirmFixedList().then((value) => Navigator.pop(context));
        }, child: const Text("Save")),
      ],
      content: SizedBox(
        height: 60.h,
        width: 80.w,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: _cubit.fixSuccessProducts.length,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          itemBuilder: (context, index) {
            int _productIndex = _cubit.fixSuccessProducts[index];
            ErrorProduct _product =
                _cubit.displayErrorProducts[_productIndex];
            return ProductOverview(
              disable: true,
              index: _productIndex,
              product: _product,
              isFixed: true,
              onTap: () {},
              colorToString: _cubit.colorToString(_product.color),
            );
          },
        ),
      ),
    );
  }
}