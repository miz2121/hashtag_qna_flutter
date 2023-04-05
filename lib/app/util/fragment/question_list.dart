import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/util/component/no_data.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class QuestionList extends StatefulWidget {
  const QuestionList({
    super.key,
    required this.snapshot,
    this.token,
    required this.previous,
  });

  final AsyncSnapshot<Map<String, dynamic>> snapshot;
  final String? token;
  final String previous;

  @override
  State<QuestionList> createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  String jsonKey = '';
  String jsonKeyList = '';
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.previous == '/home') {
      jsonKey = 'homeQuestionWithHashtagsListDto';
      jsonKeyList = 'questionListDtoList';
    } else if (widget.previous == '/question_list') {
      jsonKey = 'questionListDtoPage';
      jsonKeyList = 'content';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ((widget.snapshot.data![jsonKey]![jsonKeyList]?.length) != 0)
        ? // 데이터가 있으면 정상적으로 보여주고

        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.snapshot.data![jsonKey]![jsonKeyList]?.length ?? 0,
            itemBuilder: (context, index) {
              return InkWell(
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // boards
                      Container(height: (1.5).w),
                      ListTile(
                        title: Padding(
                          padding: EdgeInsets.fromLTRB(0, 1.w, 0, 1.w),
                          child: Text(
                            widget.snapshot.data![jsonKey][jsonKeyList][index]['title'],
                            style: Theme.of(context).textTheme.bodyLarge!,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            widget.previous == '/question_list'
                                ? SizedBox(
                                    width: 70.w,
                                    child: Row(
                                      children: [
                                        for (int h = 0; h < widget.snapshot.data!['hashtagListDtoList'][index]['hashtagDtoList'].length; h++)
                                          Text(
                                            '# ${widget.snapshot.data!['hashtagListDtoList'][index]['hashtagDtoList'][h]['hashtagName']}  ',
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                      ],
                                    ),
                                  )
                                : widget.previous == '/home'
                                    ? SizedBox(
                                        // color: Colors.red,
                                        width: 70.w,
                                        child: Wrap(
                                          direction: Axis.horizontal,
                                          alignment: WrapAlignment.start,
                                          children: [
                                            for (int h = 0; h < widget.snapshot.data!['homeQuestionWithHashtagsListDto']['hashtagListDtoList'][index]['hashtagDtoList'].length; h++)
                                              Text(
                                                '# ${widget.snapshot.data!['homeQuestionWithHashtagsListDto']['hashtagListDtoList'][index]['hashtagDtoList'][h]['hashtagName']}  ',
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: false,
                                              ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                            const Text(''),
                            Text(
                              DateFormat('yy년 MM월 dd일 a:h시 mm분').format(DateTime.parse(widget.snapshot.data![jsonKey][jsonKeyList][index]['date'])),
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey[700]),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "상태: ${widget.snapshot.data![jsonKey][jsonKeyList][index]['questionStatus']}",
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey[700]),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "답변 수: ${widget.snapshot.data![jsonKey][jsonKeyList][index]['answerCount']}",
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey[700]),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 15),
                        child: Text(
                          widget.snapshot.data![jsonKey][jsonKeyList][index]['writer'],
                          style: Theme.of(context).textTheme.bodyMedium!,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () async {
                  if (!mounted) return;
                  if (widget.token == null) {
                    Navigator.pushNamed(context, '/login');
                  } else {
                    Navigator.pushNamed(context, '/question', arguments: {
                      'id': widget.snapshot.data![jsonKey][jsonKeyList][index]['id'],
                      'token': widget.token,
                      'previous': widget.previous,
                    });
                  }
                },
              );
            },
          )
        : const NoData();
  }
}
