import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashtag_qna_flutter/app/data/repository/home_repository.dart';


final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, HomeRepository>(
        (ref) => HomeViewModel(HomeRepository()));

class HomeViewModel extends StateNotifier<HomeRepository>{
  HomeViewModel(super.state);

  final HomeRepository _homeRepository = HomeRepository();
  HomeRepository get homeRepository => _homeRepository;
}
