import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String message;
  final Function() reload;
  const ErrorMessage({Key? key, required this.message, required this.reload})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: const TextStyle(fontSize: 20, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                onPressed: reload,
                child: const Text(
                  'Reload',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    primary: Colors.red),
              ),
            )
          ],
        )));
  }
}
