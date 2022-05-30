import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class FormTextField extends StatelessWidget {
  final bool isRequired;
  final int maxLength;
  final String name;
  final String label;
  final String initialValue;
  final bool isBold;
  final bool isItalic;
  const FormTextField({
    Key? key,
    required this.name,
    required this.isRequired,
    required this.label,
    this.maxLength = 0,
    this.isBold = false,
    this.isItalic = false,
    this.initialValue = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Text(
              label,
              style: const TextStyle(
                  color: Colors.black45,
                  fontSize: 16,
                  fontWeight: FontWeight.w300),
            ),
            flex: 1),
        Expanded(
            child: FormBuilderTextField(
              name: name,
              decoration: const InputDecoration(border: InputBorder.none),
              initialValue: initialValue,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
                  fontSize: 16),
              // valueTransformer: (text) => num.tryParse(text),
              validator: FormBuilderValidators.compose([
                if (isRequired) FormBuilderValidators.required(),
                if (maxLength > 0) FormBuilderValidators.maxLength(maxLength),
              ]),
              keyboardType: TextInputType.text,
            ),
            flex: 3),
      ],
    );
  }
}
