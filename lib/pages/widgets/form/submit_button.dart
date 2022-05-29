import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class SubmitButton extends StatelessWidget {
  final bool submitSuccess;
  final bool isValidated;
  final Function() onTap;
  const SubmitButton({Key? key, this.submitSuccess = false, this.isValidated = true, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: submitSuccess
            ? Lottie.asset('assets/images/success.json', width: 70)
            : Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: isValidated ? Colors.green : Colors.red),
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                child: Text(
                  'SAVE',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 8.sp),
                ),
              ),
        onTap: onTap,
      );
  }
}