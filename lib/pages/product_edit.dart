import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/cubit/error_products/error_products_cubit.dart';
import 'package:weather_app/layouts/app_scaffold.dart';
import 'package:weather_app/pages/widgets/image_network.dart';

class ProductEditPage extends StatefulWidget {
  ProductEditPage({Key? key}) : super(key: key);

  @override
  State<ProductEditPage> createState() => _ProductEditPageState();
}

class _ProductEditPageState extends State<ProductEditPage> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        title: 'PRODUCT EDIT',
        body: Column(
          children: [
            Expanded(child: ImageNetwork(imageUrl)),
          ],
        ));
  }
}
