import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.previous == '/home') {
      jsonKey = 'questionListDtos';
    } else if (widget.previous == '/question_list') {
      jsonKey = 'content';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.snapshot.data![jsonKey].length,
      itemBuilder: (context, index) {
        return InkWell(
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // boards
                ListTile(
                  title: Text(
                    widget.snapshot.data![jsonKey][index]['title'],
                    style: Theme.of(context).textTheme.bodyLarge!,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    DateFormat('yy년 MM월 dd일 a:h시 mm분').format(DateTime.parse(widget.snapshot.data![jsonKey][index]['date'])),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey[700]),
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "상태: ${widget.snapshot.data![jsonKey][index]['questionStatus']}",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey[700]),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "답변 수: ${widget.snapshot.data![jsonKey][index]['answerCount']}",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey[700]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 15),
                  child: Text(
                    widget.snapshot.data![jsonKey][index]['writer'],
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
                'id': widget.snapshot.data![jsonKey][index]['id'],
                'token': widget.token,
                'previous': widget.previous,
              });
            }
          },
        );
      },
    );
  }
}
