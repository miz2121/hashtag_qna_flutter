import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/ui/create/create_viewmodel.dart';
import 'package:hashtag_qna_flutter/app/util/component/hashtag.dart';

class SelectedHashtags extends StatelessWidget {
  const SelectedHashtags({
    super.key,
    required this.argsList,
    required this.provider,
  });

  final List argsList;
  final CreateViewModel provider;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.start,
      children: [
        for (int index = 0; index < argsList.length; index++)
          Hashtag(
            provider: provider,
            index: index,
            argsList: argsList,
          ),
      ],
    );
  }
}
