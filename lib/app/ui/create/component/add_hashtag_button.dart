import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/ui/create/create_second/create_second_page.dart';
import 'package:hashtag_qna_flutter/app/ui/create/create_viewmodel.dart';
import 'package:hashtag_qna_flutter/app/util/utility.dart';
import 'package:sizer/sizer.dart';

class AddHashtagButton extends StatefulWidget {
  const AddHashtagButton({
    super.key,
    required this.createdFormLists,
    required this.createdHashtagNameList,
    required this.provider,
  });

  final List<Widget> createdFormLists;
  final List<String> createdHashtagNameList;
  final CreateViewModel provider;

  @override
  State<AddHashtagButton> createState() => _AddHashtagButtonState();
}

class _AddHashtagButtonState extends State<AddHashtagButton> {
  double buttonSize = 0;

  @override
  void initState() {
    super.initState();
    buttonSize = 100.w / 8;
  }

  @override
  Widget build(BuildContext context) {
    CreateSecondPageState? parent = context.findAncestorStateOfType<CreateSecondPageState>();
    return InkWell(
      child: Container(
        margin: EdgeInsets.all(1.w),
        padding: EdgeInsets.fromLTRB(2.w, 1.w, 2.w, 1.w),
        decoration: BoxDecoration(
          color: Colors.cyan[100],
          borderRadius: BorderRadius.circular(80),
          border: Border.all(
            color: Colors.cyan,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '해시태그 추가하기',
              style: TextStyle(fontSize: (100.w / 15) / 1.3),
            ),
            Icon(Icons.add_circle, color: Colors.lightBlue, size: buttonSize),
          ],
        ),
      ),
      onTap: () {
        logger.d("_createdFormLists: ${widget.createdFormLists}");
        widget.provider.isHashtagChecked.toList().add(true);
        if (!mounted) return;
        parent?.setState(() {
          widget.createdFormLists.add(
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100.w * (7 / 10),
                  child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: '해시태그 이름을 입력해 주세요.',
                      ),
                      validator: (value) => value!.isEmpty ? '해시태그 이름을 입력해 주세요.' : null,
                      onSaved: (value) {
                        if (!widget.createdHashtagNameList.contains(value)) {
                          widget.createdHashtagNameList.add(value!);
                        }
                      }),
                ),
                InkWell(
                  child: Icon(
                    Icons.delete_forever,
                    color: Colors.lightBlue,
                    size: buttonSize * 0.9,
                  ),
                  onTap: () {
                    parent.setState(() {
                      widget.createdFormLists.removeLast();
                      if (widget.createdFormLists.isEmpty) {
                        widget.createdHashtagNameList.clear();
                      }
                    });
                  },
                ),
              ],
            ),
          );
        });
      },
    );
  }
}
