import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class Utility {}

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
