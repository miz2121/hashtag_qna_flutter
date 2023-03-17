import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QuComment extends StatelessWidget {
  const QuComment({
    super.key,
    required this.displayWidth,
    required this.index,
    required this.snapshot,
  });

  final double displayWidth;
  final int index;
  final AsyncSnapshot<Map<String, dynamic>> snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(height: 15),
        Row(
          children: [
            const Icon(Icons.subdirectory_arrow_right),
            Container(
              width: displayWidth * (7.7 / 10),
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
                        snapshot.data!["quCommentDtos"][index]["content"],
                        style: Theme.of(context).textTheme.bodyLarge!,
                      ),
                      Text(
                        snapshot.data!["quCommentDtos"][index]["writer"],
                      ),
                    ],
                  ),
                  Text(
                    DateFormat('yy년 MM월 dd일 a:h시 mm분').format(
                      DateTime.parse(snapshot.data!["quCommentDtos"][index]["date"]),
                    ),
                  ),
                ],
              ),
            ),
            Container(height: 15),
          ],
        ),
      ],
    );
  }
}
