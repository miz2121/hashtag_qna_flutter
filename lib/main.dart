import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/ui/create/create_second/create_second_page.dart';
import 'package:hashtag_qna_flutter/app/ui/create/create_third/create_third_page.dart';
import 'package:hashtag_qna_flutter/app/ui/home/home_page.dart';
import 'package:hashtag_qna_flutter/app/ui/join/join_page.dart';
import 'package:hashtag_qna_flutter/app/ui/question/create_answer.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_page.dart';
import 'package:hashtag_qna_flutter/app/ui/question_list/question_list_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sizer/sizer.dart';

import 'app/ui/create/create_first/create_first_page.dart';
import 'app/ui/login/login_page.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    initializeDateFormatting('ko_KR', null);
    // MainViewModel vm = MainViewModel();

    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (BuildContext context) {
            MaterialPageRoute(
              settings: const RouteSettings(name: '/'),
              builder: (context) => const StartPage(),
            );
            return const StartPage();
          },
          '/home': (BuildContext context) {
            MaterialPageRoute(
              settings: const RouteSettings(name: '/home'),
              builder: (context) => const HomePage(),
            );
            return const HomePage();
          },
          '/create_first': (BuildContext context) {
            MaterialPageRoute(
              settings: const RouteSettings(name: '/create_first'),
              builder: (context) => const CreateFirstPage(),
            );
            return const CreateFirstPage();
          },
          '/create_second': (BuildContext context) {
            MaterialPageRoute(
              settings: const RouteSettings(name: '/create_second'),
              builder: (context) => const CreateSecondPage(),
            );
            return const CreateSecondPage();
          },
          '/create_third': (BuildContext context) {
            MaterialPageRoute(
              settings: const RouteSettings(name: '/create_third'),
              builder: (context) => const CreateThirdPage(),
            );
            return const CreateThirdPage();
          },
          '/login': (BuildContext context) {
            MaterialPageRoute(
              settings: const RouteSettings(name: '/login'),
              builder: (context) => const LoginPage(),
            );
            return const LoginPage();
          },
          '/question': (BuildContext context) {
            MaterialPageRoute(
              settings: const RouteSettings(name: '/question'),
              builder: (context) => const QuestionPage(),
            );
            return const QuestionPage();
          },
          '/create_answer': (BuildContext context) {
            MaterialPageRoute(
              settings: const RouteSettings(name: '/create_answer'),
              builder: (context) => const CreateAnswer(),
            );
            return const CreateAnswer();
          },
          '/question_list': (BuildContext context) {
            MaterialPageRoute(
              settings: const RouteSettings(name: '/question_list'),
              builder: (context) => const QuestionListPage(),
            );
            return const QuestionListPage();
          },
          '/join': (BuildContext context) {
            MaterialPageRoute(
              settings: const RouteSettings(name: '/join'),
              builder: (context) => const JoinPage(),
            );
            return const JoinPage();
          },
        },
        theme: ThemeData(
          primaryColor: Colors.cyan[900],
          scaffoldBackgroundColor: Colors.lightBlue[50],
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.cyan[100],
          ),
          textTheme: TextTheme(
            bodyLarge: TextStyle(fontSize: 100.w / 23),
            bodyMedium: TextStyle(fontSize: 100.w / 29),
          ),
        ),
      );
    });
  }
}

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // MainViewModel vm = MainViewModel();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (route) => false,
              );
            },
            child: Text(
              '해시태그 QnA 게시판\n서비스를 시작합니다.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 100.w / 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
