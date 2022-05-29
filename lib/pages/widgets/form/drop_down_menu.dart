import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sizer/sizer.dart';
import 'package:teko_test/cubit/error_products/error_products_cubit.dart';
import 'package:teko_test/data/colors_data.dart';
import 'package:teko_test/models/error_product_model.dart';

class FormColorPicker extends StatefulWidget {
  const FormColorPicker({
    Key? key,
  }) : super(key: key);

  @override
  State<FormColorPicker> createState() => _FormColorPickerState();
}

class _FormColorPickerState extends State<FormColorPicker> {
  late ErrorProductCubit _cubit;
  late ErrorProduct _errorProduct;

  @override
  void initState() {
    _cubit = BlocProvider.of<ErrorProductCubit>(context);
    _errorProduct = _cubit.errorProducts[_cubit.currentIndexEdit];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
            child: Text(
              'Color: ',
              style: TextStyle(
                  color: Colors.black45,
                  fontSize: 20,
                  fontWeight: FontWeight.w300),
            ),
            flex: 1),
        Expanded(
            child: FormBuilderDropdown(
              name: 'color',
              decoration: const InputDecoration(border: InputBorder.none),
              initialValue: _errorProduct.color,
              allowClear: true,
              hint: Text(
                'Select one color',
                style: TextStyle(fontSize: 8.sp),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
              items: _cubit.colors
                  .map((color) => DropdownMenuItem(
                        value: color.id,
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                  color: ColorsData.colorMap[color.name]),
                            ),
                            Text(
                              color.name,
                              style: TextStyle(
                                  fontSize: 8.sp, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
            flex: 3),
      ],
    );
  }
}
