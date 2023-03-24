import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class Utility {}

Future<dynamic> exceptionShowDialog(BuildContext context, String exceptionMessage) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('확인해 주세요'),
          content: Text(exceptionMessage),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("확인"),
              ),
            ),
          ],
        );
      });
}

final logger = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

extension StateExtension<T extends StatefulWidget> on State<T> {
  Stream waitForStateLoading() async* {
    while (!mounted) {
      yield false;
    }
    yield true;
  }

  Future<void> postInit(VoidCallback action) async {
    await for (var _isLoaded in waitForStateLoading()) {}
    action();
  }
}
