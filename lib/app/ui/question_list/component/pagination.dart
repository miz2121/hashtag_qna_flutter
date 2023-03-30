import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/util/utility.dart';
import 'package:sizer/sizer.dart';

class Pagination extends StatefulWidget {
  const Pagination({
    Key? key,
    required this.totalPages,
    required this.currentPage,
    required this.token,
  }) : super(key: key);

  final int totalPages;
  final int currentPage;
  final String token;

  @override
  State<Pagination> createState() => _PaginationState();
}

class _PaginationState extends State<Pagination> {
  int currentMinPage = 0;
  int currentMiddlePage = 0;
  int currentMaxPage = 0;
  double numberSize = (7).w;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    currentMinPage = (widget.currentPage) - (widget.currentPage) % 10 + 1;
    if (currentMinPage > (widget.currentPage)) {
      currentMinPage -= 10;
    }
    if (currentMinPage < 1) {
      currentMinPage = 1;
    }
    if (widget.totalPages <= 10) {
      currentMiddlePage = widget.totalPages;
      currentMaxPage = 1;
    } else {
      currentMaxPage = currentMinPage + 9;
      if (currentMaxPage > widget.totalPages) {
        currentMaxPage = widget.totalPages;
      }
      currentMiddlePage = (currentMinPage + currentMaxPage) ~/ 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.d('currentPage: ${widget.currentPage}, currentMinPage: $currentMinPage, currentMiddlePage: $currentMiddlePage, currentMaxPage: $currentMaxPage');
    return Column(
      children: [
        Container(height: 5.w),
        Padding(
          padding: EdgeInsets.fromLTRB((5).w, (0), (5).w, (0)),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // '<' 버튼
                  (widget.currentPage) > 10
                      ? TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/question_list', arguments: {
                              'token': widget.token,
                              'titleText': "전체 질문을 보여드립니다.",
                              'currentPage': (currentMinPage - 1),
                            });
                            // parent?.setState(() {});
                          },
                          style: TextButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: EdgeInsets.all((1.8).w),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            '<',
                            style: TextStyle(
                              fontSize: numberSize,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        )
                      : Container(),

                  // 숫자 페이지
                  for (int p = currentMinPage; p <= currentMiddlePage; p++)
                    TextButton(
                      onPressed: () {
                        if (p == (widget.currentPage)) {
                          null;
                        } else {
                          Navigator.pushNamed(context, '/question_list', arguments: {
                            'token': widget.token,
                            'titleText': "전체 질문을 보여드립니다.",
                            'currentPage': p,
                          });
                          // parent?.setState(() {});
                        }
                      },
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.all((1.8).w),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        p.toString(),
                        style: TextStyle(
                          fontSize: numberSize,
                          fontWeight: (p == widget.currentPage) ? FontWeight.bold : FontWeight.normal,
                          fontStyle: (p == widget.currentPage) ? FontStyle.italic : FontStyle.normal,
                        ),
                      ),
                    ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 숫자 페이지
                  for (int p = (currentMiddlePage + 1); p <= currentMaxPage; p++)
                    TextButton(
                      onPressed: () {
                        if (p == (widget.currentPage)) {
                          null;
                        } else {
                          Navigator.pushNamed(context, '/question_list', arguments: {
                            'token': widget.token,
                            'titleText': "전체 질문을 보여드립니다.",
                            'currentPage': p,
                          });
                          // parent?.setState(() {});
                        }
                      },
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.all((1.8).w),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        p.toString(),
                        style: TextStyle(
                          fontSize: numberSize,
                          fontWeight: (p == widget.currentPage) ? FontWeight.bold : FontWeight.normal,
                          fontStyle: (p == widget.currentPage) ? FontStyle.italic : FontStyle.normal,
                        ),
                      ),
                    ),
                  // '>' 버튼
                  ((currentMaxPage) != (widget.totalPages))
                      ? TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/question_list', arguments: {
                              'token': widget.token,
                              'titleText': "전체 질문을 보여드립니다.",
                              'currentPage': (currentMaxPage + 1),
                            });
                            // parent?.setState(() {});
                          },
                          style: TextButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: EdgeInsets.all((1.8).w),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            '>',
                            style: TextStyle(
                              fontSize: numberSize,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB((5).w, (0), (5).w, (0)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: (widget.currentPage == 1)
                    ? null
                    : () => Navigator.pushNamed(
                          context,
                          '/question_list',
                          arguments: {
                            'token': widget.token,
                            'titleText': "전체 질문을 보여드립니다.",
                            'currentPage': 1,
                          },
                        ),
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.all((1.8).w),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  '<<',
                  style: TextStyle(
                    fontSize: numberSize,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Container(width: 45.w),
              TextButton(
                onPressed: (widget.currentPage == widget.totalPages)
                    ? null
                    : () => Navigator.pushNamed(
                          context,
                          '/question_list',
                          arguments: {
                            'token': widget.token,
                            'titleText': "전체 질문을 보여드립니다.",
                            'currentPage': widget.totalPages,
                          },
                        ),
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.all((1.8).w),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  '>>',
                  style: TextStyle(
                    fontSize: numberSize,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
