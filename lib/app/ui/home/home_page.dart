import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/data/model/home.dart';
import 'package:hashtag_qna_flutter/app/ui/home/home_viewmodel.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

var logger = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

class HomePage extends StatefulWidget {
  final String? auth;

  const HomePage({Key? key, this.auth}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPreferences? prefs;
  String? auth;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    prefs = await SharedPreferences.getInstance();
    // logger.d(prefs.getKeys());
    auth = prefs?.getString('Authorization');
  }

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    double buttonFontSize = displayWidth / 15;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(height: displayWidth / 10),
                TextButton(
                  onPressed: () {
                    // logger.d(auth);
                    if (auth == null) {
                      Navigator.pushNamed(context, '/login');
                    } else {
                      Navigator.pushNamed(context, '/create');
                    }
                  },
                  child: Text(
                    '질문을 작성하실 수 있습니다.\n클릭해 보세요.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: buttonFontSize,
                    ),
                  ),
                ),
                Container(height: displayWidth / 10),
                HomePageFragment(prefs, auth),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomePageFragment extends ConsumerWidget {
  final SharedPreferences? prefs;
  final String? auth;

  const HomePageFragment(this.prefs, this.auth, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(homeViewModelProvider.notifier);
    List<int> hashtagColorList = [100, 200, 300];

    return FutureBuilder<Map<String, dynamic>>(
      future: provider.homeRepository.getHomeQuestions(),
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
          return Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!['questionListDtos'].length,
                itemBuilder: (context, index) {
                  return InkWell(
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //
                          //
                          // boards
                          ListTile(
                            title: Text(
                              snapshot.data!['questionListDtos'][index]
                                  ['title'],
                              style: Theme.of(context).textTheme.bodyLarge!,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              DateFormat('yy년 mm월 dd일').format(DateTime.parse(
                                  snapshot.data!['questionListDtos'][index]
                                      ['date'])),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.grey[700]),
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "상태: ${snapshot.data!['questionListDtos'][index]['questionStatus']}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Colors.grey[700]),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "답변 수: ${snapshot.data!['questionListDtos'][index]['answerCount']}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Colors.grey[700]),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(15, 0, 0, 15),
                            child: Text(
                              snapshot.data!['questionListDtos'][index]
                                  ['writer'],
                              style: Theme.of(context).textTheme.bodyMedium!,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      if (auth == null) {
                        Navigator.pushNamed(context, '/login');
                      } else {
                        Navigator.pushNamed(context, '/question');
                      }
                    },
                  );
                },
              ),
              //
              // boards
              //
              Container(
                height: 30,
              ),
              //
              //
              // hashtags
              Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.start,
                // shrinkWrap: true,
                // itemCount: snapshot.data!['hashtagDtos'].length,
                // itemBuilder: (context, index) {
                //   return
                children: [
                  for (int index = 0;
                      index < snapshot.data!['hashtagDtos'].length;
                      index++)
                    InkWell(
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        decoration: BoxDecoration(
                          color: Colors.cyan[hashtagColorList[index % 3]],
                          borderRadius: BorderRadius.circular(80),
                          border: Border.all(
                            color: Colors.cyan,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          "# ${snapshot.data!['hashtagDtos'][index]['hashtagName']}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.blueGrey[700]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      onTap: () {
                        if (auth == null) {
                          Navigator.pushNamed(context, '/login');
                        } else {
                          Navigator.pushNamed(context, '/questions_by_hashtag');
                        }
                      },
                    ),
                ],
              ),
              Container(
                height: 30,
              ),
              // logout button
              ElevatedButton(
                onPressed: () {
                  prefs?.clear();  // logout
                },
                child: const Text('로그아웃 하실 수 있습니다.'),
              ),
            ],
          );
        }
      },
    );
  }
}
