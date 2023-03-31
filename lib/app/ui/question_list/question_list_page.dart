import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/ui/question_list/component/insertTestData.dart';
import 'package:hashtag_qna_flutter/app/ui/question_list/component/pagination.dart';
import 'package:hashtag_qna_flutter/app/ui/question_list/question_list_viewmodel.dart';
import 'package:hashtag_qna_flutter/app/util/fragment/question_list.dart';
import 'package:hashtag_qna_flutter/app/util/fragment/upper_text_clickable.dart';
import 'package:hashtag_qna_flutter/app/util/utility.dart';
import 'package:sizer/sizer.dart';

class QuestionListPage extends ConsumerStatefulWidget {
  const QuestionListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<QuestionListPage> createState() => QuestionListPageState();
}

class QuestionListPageState extends ConsumerState<QuestionListPage> {
  late Future<Map<String, dynamic>> init;
  late QuestionListViewModel provider;
  String token = '';
  String titleText = ''; // "전체 질문을 보여드립니다." 등등
  int currentPage = 0;
  String operation = '';
  String selectedType = '전체 검색';
  String searchText = '';

  @override
  void initState() {
    super.initState();
    provider = ref.read(questionListViewModelProvider.notifier);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    token = (ModalRoute.of(context)!.settings.arguments as Map)['token'];
    titleText = (ModalRoute.of(context)!.settings.arguments as Map)['titleText'];
    currentPage = (ModalRoute.of(context)!.settings.arguments as Map)['currentPage'];
    operation = (ModalRoute.of(context)!.settings.arguments as Map)['operation']; // 'pagination', 'search'
    selectedType = (ModalRoute.of(context)!.settings.arguments as Map)['selectedType']; // 'operation'이 'search'가 아니면 ''
    searchText = (ModalRoute.of(context)!.settings.arguments as Map)['searchText']; // 'operation'이 'search'가 아니면 ''
    provider = ref.watch(questionListViewModelProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: FutureBuilder(
              future: operation == 'pagination'
                  ? provider.getViewQuestionsWithPagination(token, currentPage)
                  : operation == 'search'
                      ? provider.getSearch(token, selectedType, searchText, currentPage)
                      : null,
              builder: (BuildContext _, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error = ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading");
                }
                if (snapshot.data!.isEmpty) {
                  return Container();
                }
                if (snapshot.data!['code'] != null) {
                  switch (snapshot.data!['code']) {
                    case "INVALID_PARAMETER":
                      exceptionShowDialog(context, "INVALID_PARAMETER");
                      break;
                    case "NOT_MEMBER":
                      exceptionShowDialog(context, "NOT_MEMBER");
                      break;
                    case "INACTIVE_MEMBER":
                      exceptionShowDialog(context, "INACTIVE_MEMBER");
                      break;
                    case "RESOURCE_NOT_FOUND":
                      exceptionShowDialog(context, "RESOURCE_NOT_FOUND");
                      break;
                    case "INTERNAL_SERVER_ERROR":
                      exceptionShowDialog(context, "INTERNAL_SERVER_ERROR");
                      break;
                    default:
                      logger.e('ERROR');
                      throw Exception("Error");
                  }
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(height: 10.w),
                    Text(
                      titleText, // "전체 질문을 보여드립니다."
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 100.w / 15,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Container(height: 10.w),
                    CreateQuestionTextButton(
                      token: token,
                      previous: '/question_list',
                    ),
                    Container(height: 10.w),
                    QuestionList(
                      previous: '/question_list',
                      snapshot: snapshot,
                      token: token,
                    ),
                    Pagination(
                      operation: operation,
                      totalPages: snapshot.data!["totalPages"] ?? 1,
                      currentPage: currentPage,
                      token: token,
                      searchText: searchText,
                      selectedType: selectedType,
                    ),
                    Container(height: 10.w),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                      },
                      child: const Text('메인 화면으로 가기'),
                    ),
                    Container(height: 10.w),
                    SearchField(
                      provider: provider,
                      token: token,
                    ),
                    Container(height: 10.w),
                    InsertTestData(
                      snapshot: snapshot,
                    ),
                    Container(height: 10.w),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class SearchField extends ConsumerStatefulWidget {
  const SearchField({
    super.key,
    required this.provider,
    required this.token,
  });

  final QuestionListViewModel provider;
  final String token;
  @override
  ConsumerState<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends ConsumerState<SearchField> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    widget.provider.setSelectedType = widget.provider.getSearchType[0];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 95.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButton<String>(
                value: widget.provider.getSelectedType,
                items: (widget.provider.getSearchType)
                    .map<DropdownMenuItem<String>>((String e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    widget.provider.setSelectedType = value!;
                  });
                }),
          ),
          Container(height: 1.w),
          Row(
            children: [
              Container(
                width: 74.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Form(
                  key: formKey,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: '검색할 내용을 입력해 주세요',
                    ),
                    onSaved: (value) => widget.provider.setSearchText = value!,
                    validator: (value) => value!.isEmpty ? '검색을 원하시면 입력해 주세요.' : null,
                  ),
                ),
              ),
              Container(width: 1.w),
              SizedBox(
                width: 20.w,
                child: ElevatedButton(
                  onPressed: () {
                    formKey.currentState?.save();
                    Navigator.pushNamed(
                      context,
                      '/question_list',
                      arguments: {
                        'token': widget.token,
                        'titleText': "'${widget.provider.getSelectedType}'기준\n'${widget.provider.getSearchText}'으로\n검색한 결과를 보여드립니다.",
                        'currentPage': 1,
                        'operation': "search",
                        'selectedType': widget.provider.getSelectedType,
                        'searchText': widget.provider.getSearchText,
                      },
                    );
                  },
                  child: const Text('검색'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
