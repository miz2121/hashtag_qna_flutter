import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/ui/create/create_viewmodel.dart';
import 'package:hashtag_qna_flutter/app/util/component/no_data.dart';
import 'package:hashtag_qna_flutter/app/util/utility.dart';
import 'package:sizer/sizer.dart';

class AllHashtags extends StatefulWidget {
  const AllHashtags({
    super.key,
    required this.provider,
    required this.hashtagNames,
  });

  final CreateViewModel provider;
  final Set<String> hashtagNames;

  @override
  State<AllHashtags> createState() => _AllHashtagsState();
}

class _AllHashtagsState extends State<AllHashtags> {
  void checkHashtagNamesEmpty(snapshot) {
    if (widget.provider.isHashtagChecked.isNotEmpty) {
      for (int i = 0; i < widget.provider.isHashtagChecked.length; i++) {
        if (widget.provider.isHashtagChecked[i] == true) {
          widget.hashtagNames.add(snapshot.data!['hashtagDtoList'][i]['hashtagName']);
        }
      }
    }
    // logger.d("hashtagNames: $hashtagNames");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: widget.provider.getHashtags(),
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          return Text('Error = ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        if (snapshot.data!.isEmpty) {
          return Container();
        } else {
          logger.d("isHashtagChecked: ${widget.provider.isHashtagChecked}");
          checkHashtagNamesEmpty(snapshot);
          logger.d("snapshot.data!['hashtagDtoList'].length: ${snapshot.data!['hashtagDtoList'].length}");
          return (snapshot.data!['hashtagDtoList'].isNotEmpty)
              ? Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.start,
                  children: [
                    for (int index = 0; index < snapshot.data!.length; index++)
                      InkWell(
                        child: Container(
                          margin: EdgeInsets.all(1.w),
                          padding: EdgeInsets.fromLTRB(2.w, 1.w, 2.w, 1.w),
                          decoration: BoxDecoration(
                            color: Colors.cyan[widget.provider.hashtagColorList[index % 3]],
                            borderRadius: BorderRadius.circular(80),
                            border: Border.all(
                              color: Colors.cyan,
                              width: 0.5.w,
                            ),
                          ),
                          child: (widget.provider.isHashtagChecked.isEmpty)
                              ? (Text(
                                  " # ${snapshot.data!['hashtagDtoList'][index]['hashtagName']}",
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.blueGrey[700]),
                                  overflow: TextOverflow.ellipsis,
                                ))
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    widget.provider.isHashtagChecked[index] == false
                                        ? Text(
                                            " # ${snapshot.data!['hashtagDtoList'][index]['hashtagName']}",
                                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.blueGrey[700]),
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        : Row(
                                            children: [
                                              Text(
                                                " # ${snapshot.data!['hashtagDtoList'][index]['hashtagName']} ",
                                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.blueGrey[700]),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const Icon(
                                                Icons.done,
                                                color: Colors.orangeAccent,
                                                size: 50,
                                              )
                                            ],
                                          ),
                                  ],
                                ),
                        ),
                        onTap: () {
                          setState(() {
                            String name = snapshot.data!['hashtagDtoList'][index]['hashtagName'];
                            if (widget.hashtagNames.contains(name)) {
                              widget.hashtagNames.remove(name);
                            } else {
                              widget.hashtagNames.add(name);
                            }
                            logger.d("index: $index, hashtagNames: ${widget.hashtagNames}");

                            if (widget.provider.isHashtagChecked.isEmpty) {
                              widget.provider.isHashtagChecked = List.filled((snapshot.data!.length) + 1, false);
                            }
                            widget.provider.isHashtagChecked[index] = !widget.provider.isHashtagChecked[index];
                          });
                        },
                      ),
                  ],
                )
              : const NoData();
        }
      },
    );
  }
}
