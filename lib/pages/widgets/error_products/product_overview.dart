import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:teko_test/data/colors_data.dart';
import 'package:teko_test/models/error_product_model.dart';
import 'package:teko_test/pages/widgets/image_network.dart';

class ProductOverview extends StatelessWidget {
  final bool disable;
  final Function() onTap;
  final int index;
  final String colorToString;
  final bool isFixed;
  final ErrorProduct product;
  const ProductOverview(
      {Key? key,
      this.disable = false,
      required this.onTap,
      required this.product,
      required this.index,
      required this.colorToString,
      required this.isFixed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: disable,
      child: SizedBox(
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
                onTap: onTap,
                child: Container(
                  constraints: BoxConstraints(minHeight: 26.w),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Hero(
                              tag: product.sku!,
                              child: ImageNetwork(product.image))),
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
                                    style: TextStyle(
                                        fontSize: 8.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  child: Text(
                                    product.sku!,
                                    style: TextStyle(
                                        fontSize: 7.sp,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 1),
                                              color: ColorsData
                                                  .colorMap[colorToString]),
                                        ),
                                        Text(
                                          colorToString,
                                          style: TextStyle(
                                              fontSize: 6.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )),
                              ],
                            )),
                      ),
                      CircleAvatar(
                        backgroundColor: isFixed ? Colors.green : Colors.red,
                        child: Icon(
                          isFixed ? Icons.check : Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      )
                    ],
                  ),
                ),
              )),
          if (!isFixed)
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
      )),
    );
  }
}
