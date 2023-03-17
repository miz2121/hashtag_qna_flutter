import 'package:flutter/material.dart';
import 'package:hashtag_qna_flutter/app/ui/create/create_second/create_second_page.dart';
import 'package:hashtag_qna_flutter/app/util/utility.dart';

class AddHashtagButton extends StatefulWidget {
  AddHashtagButton({
    super.key,
    required this.displayWidth,
    required this.buttonFontSize,
    required this.buttonSize,
    required this.createdFormLists,
    required this.createdHashtagNameList,
  });

  final double displayWidth;
  final double buttonFontSize;
  final double buttonSize;
  List<Widget> createdFormLists;
  List<String> createdHashtagNameList;

  @override
  State<AddHashtagButton> createState() => _AddHashtagButtonState();
}

class _AddHashtagButtonState extends State<AddHashtagButton> {
  @override
  Widget build(BuildContext context) {
    CreateSecondPageState? parent = context.findAncestorStateOfType<CreateSecondPageState>();
    return InkWell(
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
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
              style: TextStyle(fontSize: widget.buttonFontSize / 1.3),
            ),
            Icon(Icons.add_circle, color: Colors.lightBlue, size: widget.buttonSize),
          ],
        ),
      ),
      onTap: () {
        logger.d("_createdFormLists: ${widget.createdFormLists}");
        if (!mounted) return;
        parent?.setState(() {
          widget.createdFormLists.add(
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: widget.displayWidth * (7 / 10),
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
                    size: widget.buttonSize * 0.9,
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
