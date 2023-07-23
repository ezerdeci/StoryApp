import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data_set/data_set.dart';
import '../../models/story_model.dart';
import '../../models/user_model.dart';
import '../../story/functions/videoPlayerEditor.dart';
import '../../story/data/story_page_data.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  List<StoryModel> storyLister(String name) {
    List<StoryModel> everyStoryList = UserData.userStories
        .map((e) => StoryModel(
            e["storyOwner"], e["mediaType"], e["url"], e["duration"]))
        .toList();
    List<StoryModel> userStoryList =
        everyStoryList.where((Story) => Story.storyOwner == name).toList();
    return userStoryList;
  }

  HomeBloc() : super(HomeInitial()) {
    on<HomeInitialEvent>(homeInitialEvent);
    on<ProfileTappedEvent>(profileTappedEvent);
  }

  FutureOr<void> homeInitialEvent(
      HomeInitialEvent event, Emitter<HomeState> emit) {
    emit(HomeScreenLoadedState(
      userList: UserData.userProfiles
          .map((e) => User(e['name'], e['profileUrl'], storyLister(e["name"])))
          .toList(),
    ));
  }

  FutureOr<void> profileTappedEvent(
      ProfileTappedEvent event, Emitter<HomeState> emit) {
    emit(NavigateToStoryPageState());
    userList = event.userList;
    userIndex = event.index;
    currentIndex = userIndex;
    userList[currentIndex]
        .stories[userLeftOffIndex[currentIndex]]
        .percentWatched = 0;
    //Trial:
    if (userList[currentIndex]
            .stories[userLeftOffIndex[currentIndex]]
            .mediaType ==
        "Video") {
      videoFuture.value = play(
          userList[currentIndex].stories[userLeftOffIndex[currentIndex]].url);
    }
  }
}
