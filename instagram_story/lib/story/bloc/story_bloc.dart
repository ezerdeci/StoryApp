import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:instagram_story/story/UI/story_page.dart';
import 'package:instagram_story/story/functions/videoPlayerEditor.dart';
import 'package:instagram_story/story/data/story_page_data.dart';

part 'story_event.dart';
part 'story_state.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  StoryBloc() : super(StoryInitial()) {
    on<StoryTappedEvent>(storyTappedEventFunction);
    on<StoryTimeUpEvent>(storyTimeUpEventFunction);
    on<StoriesOverEvent>(storiesOverEventFunction);
  }

  FutureOr<void> storyTappedEventFunction(
      //This event is called if screen is tapped while story is playin
      StoryTappedEvent event,
      Emitter<StoryState> emit) {
    double xCoor = event.details.globalPosition.dx;
    double screenWidth = MediaQuery.of(event.context).size.width;

    videoPlaying = false;
    videoController.pause();
    // Checks which side of the screen is clicked
    if (xCoor > screenWidth / 2) {
      //Checks if the story that is playing is the last story of the story group or not
      if (userLeftOffIndex[currentIndex] + 1 <
          userList[currentIndex].stories.length) {
        userList[currentIndex]
            .stories[userLeftOffIndex[currentIndex]]
            .percentWatched = 1;
        userLeftOffIndex[currentIndex]++;
        emit(NextStoryState());
        //If the next story is video prepares the video player for it
        if (userList[currentIndex]
                .stories[userLeftOffIndex[currentIndex]]
                .mediaType ==
            "Video") {
          videoFuture.value = play(userList[currentIndex]
              .stories[userLeftOffIndex[currentIndex]]
              .url);
        }
      } else {
        //If the first next story in another group is video, similar to previous situation, initiliazes the video controller
        if (currentIndex + 1 < userList.length) {
          if (userList[currentIndex + 1]
                  .stories[userLeftOffIndex[currentIndex + 1]]
                  .mediaType ==
              "Video") {
            videoFuture.value = play(userList[currentIndex + 1]
                .stories[userLeftOffIndex[currentIndex + 1]]
                .url);
          }
        }
        //If the current story is the last story calls the Stories Over event to pop the story page
        if (currentIndex == userList.length - 1) {
          storyBloc.add(StoriesOverEvent());
        } else {
          // else goes to next element of the carousel slider
          carouselController.nextPage(Duration(milliseconds: 300));
        }
      }
    } else {
      //This part is the case where left part of the screen is clicked, similar to previous part
      if (userLeftOffIndex[currentIndex] > 0) {
        userList[currentIndex]
            .stories[userLeftOffIndex[currentIndex]]
            .percentWatched = 0;
        userLeftOffIndex[currentIndex]--;
        userList[currentIndex]
            .stories[userLeftOffIndex[currentIndex]]
            .percentWatched = 0;
        emit(PreviousStoryState());
        if (userList[currentIndex]
                .stories[userLeftOffIndex[currentIndex]]
                .mediaType ==
            "Video") {
          videoFuture.value = play(userList[currentIndex]
              .stories[userLeftOffIndex[currentIndex]]
              .url);
        }
      } else {
        if (currentIndex - 1 > 0) {
          if (userList[currentIndex - 1]
                  .stories[userLeftOffIndex[currentIndex - 1]]
                  .mediaType ==
              "Video") {
            videoFuture.value = play(userList[currentIndex - 1]
                .stories[userLeftOffIndex[currentIndex - 1]]
                .url);
          }
        }
        if (currentIndex > 0) {
          carouselController.previousPage(Duration(milliseconds: 300));
        } else {
          userList[0].stories[0].percentWatched = 0;
        }
      }
    }
  }

  FutureOr<void> storyTimeUpEventFunction(
      StoryTimeUpEvent event, Emitter<StoryState> emit) {
    //this event is called when the story is over due to watching time is over, changing the story code is similar to the previous part
    videoPlaying = false;
    videoController.pause();
    if (userLeftOffIndex[currentIndex] + 1 <
        userList[currentIndex].stories.length) {
      userList[currentIndex]
          .stories[userLeftOffIndex[currentIndex]]
          .percentWatched = 1;
      userLeftOffIndex[currentIndex]++;
      emit(NextStoryState());
      if (userList[currentIndex]
              .stories[userLeftOffIndex[currentIndex]]
              .mediaType ==
          "Video") {
        videoFuture.value = play(
            userList[currentIndex].stories[userLeftOffIndex[currentIndex]].url);
      }
    } else {
      if (currentIndex != userList.length - 1) {
        carouselController.nextPage(Duration(milliseconds: 300));
        Future.delayed(Duration(milliseconds: 300), () {
          userList[currentIndex - 1]
              .stories[userList[currentIndex - 1].stories.length - 1]
              .percentWatched = 0;
        });
      }
    }
  }

  FutureOr<void> storiesOverEventFunction(
      StoriesOverEvent event, Emitter<StoryState> emit) {
    emit(StoryPopState());
  }
}
