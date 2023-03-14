import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

class CreateSecondPage extends StatelessWidget {
  const CreateSecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    // String? args = ModalRoute.of(context)?.settings.arguments.toString().replaceAll('{', '').replaceAll('}', '');
    var args = ModalRoute.of(context)?.settings.arguments as Set;
    

    logger.d("hashtagNamesArguments: ${args}");
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            // child: Text(args.toString()),
            child: Text(args.toString()),
          ),
        ),
      ),
    );
  }
}
