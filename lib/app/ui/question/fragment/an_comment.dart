import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class AnComment extends StatelessWidget {
  const AnComment({
    super.key,
    required this.snapshot,
    required this.i,
  });

  final AsyncSnapshot<Map<String, dynamic>> snapshot;
  final int i;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.subdirectory_arrow_right),
            Container(
              width: 100.w * (6.8 / 10),
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.cyan,
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        snapshot.data!["anCommentDtos"][i]["content"],
                        style: Theme.of(context).textTheme.bodyLarge!,
                      ),
                      Text(
                        snapshot.data!["anCommentDtos"][i]["writer"],
                      ),
                    ],
                  ),
                  Text(
                    DateFormat('yy년 MM월 dd일 a:h시 mm분').format(DateTime.parse(snapshot.data!["anCommentDtos"][i]["date"])),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(height: 15),
      ],
    );
  }
}
