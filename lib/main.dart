import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/ui/home/home_page.dart';
import 'package:hashtag_qna_flutter/app/ui/question/question_page.dart';
import 'package:hashtag_qna_flutter/app/ui/question/questions_by_hashtag_page.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/ui/create/create_page.dart';
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
    initializeDateFormatting('ko_KR', null);
    double displayWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => const StartPage(),
        '/home': (BuildContext context) => const  HomePage(),
        '/create': (BuildContext context) => const CreatePage(),
        '/login': (BuildContext context) => const LoginPage(),
        '/question': (BuildContext context) => const QuestionPage(),
        '/questions_by_hashtag' : (BuildContext context) => const QuestionsByHashtag(),
      },
      theme: ThemeData(
        primaryColor: Colors.cyan[900],
        scaffoldBackgroundColor: Colors.lightBlue[50],
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.cyan[10],
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: displayWidth / 23),
          bodyMedium: TextStyle(fontSize: displayWidth / 29),
        )
      ),
    );
  }
}

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    double buttonFontSize = displayWidth / 15;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: TextButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context, '/home', (route) => false),
            child: Text(
              '해시태그 QnA 게시판\n서비스를 시작합니다.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: buttonFontSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
