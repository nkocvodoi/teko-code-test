import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:teko_test/cubit/error_products/error_products_cubit.dart';
import 'package:teko_test/layouts/app_scaffold.dart';
import 'package:teko_test/models/error_product_model.dart';
import 'package:teko_test/pages/widgets/form/drop_down_menu.dart';
import 'package:teko_test/pages/widgets/form/submit_button.dart';
import 'package:teko_test/pages/widgets/form/text_field.dart';
import 'package:teko_test/pages/widgets/image_network.dart';

class ProductEditPage extends StatefulWidget {
  const ProductEditPage({Key? key}) : super(key: key);

  @override
  State<ProductEditPage> createState() => _ProductEditPageState();
}

class _ProductEditPageState extends State<ProductEditPage> {
  late ErrorProductCubit _errorProductCubit;
  late ErrorProduct _errorProduct;

  bool isValidated = true;
  bool isSaveSuccess = false;

  @override
  void initState() {
    _errorProductCubit = BlocProvider.of<ErrorProductCubit>(context);
    _errorProduct =
        _errorProductCubit.errorProducts[_errorProductCubit.currentIndexEdit];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        title: 'PRODUCT EDIT',
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    height: 50.h,
                    child: Stack(
                      children: [
                        Hero(
                            tag: _errorProduct.sku!,
                            child: ImageNetwork(_errorProduct.image)),
                        if (!_errorProductCubit.fixSuccessProducts
                            .contains(_errorProductCubit.currentIndexEdit))
                          Positioned(
                              top: 30,
                              left: 0,
                              child: Container(
                                color: Colors.red,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: Text(
                                  _errorProduct.errorDescription,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ))
                      ],
                    )),
                const Divider(
                    color: Colors.black,
                    height: 0.5,
                    indent: 10,
                    endIndent: 10),
                FormBuilder(
                  key: _errorProductCubit.fbKey,
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: FormTextField(
                            maxLength: 50,
                            name: "name",
                            isRequired: true,
                            isBold: true,
                            label: "Product name: ",
                            initialValue: _errorProduct.name ?? '',
                          )),
                      const Divider(
                          color: Colors.black,
                          height: 0.5,
                          indent: 10,
                          endIndent: 10),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: FormTextField(
                            maxLength: 20,
                            name: "sku",
                            isItalic: true,
                            isRequired: true,
                            label: "SKU: ",
                            initialValue: _errorProduct.sku ?? '',
                          )),
                      const Divider(
                          color: Colors.black,
                          height: 0.5,
                          indent: 10,
                          endIndent: 10),
                      const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: FormColorPicker()),
                    ],
                  ),
                ),
                const Divider(
                    color: Colors.black,
                    height: 0.5,
                    indent: 10,
                    endIndent: 10),
              ],
            )),
        bottomWidget: SubmitButton(
            onTap: () {
              var validateForm =
                  _errorProductCubit.fbKey.currentState?.saveAndValidate();
              if (validateForm != null && validateForm) {
                setState(() {
                  isValidated = true;
                  _errorProductCubit.editProducts();
                  isSaveSuccess = true;
                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.pop(context);
                  });
                });
              } else {
                setState(() {
                  isValidated = false;
                });
              }
            },
            isValidated: isValidated,
            submitSuccess: isSaveSuccess));
  }
}
