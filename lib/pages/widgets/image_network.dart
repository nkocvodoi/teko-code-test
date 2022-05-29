import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

class ImageNetwork extends StatelessWidget {
  final String imageUrl;
  const ImageNetwork(this.imageUrl, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: imageUrl != ''
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
            )
          : Lottie.asset(
              'assets/images/not-found.json',
              fit: BoxFit.cover,
            ),
    );
  }
}
