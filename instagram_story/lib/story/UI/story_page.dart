import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:instagram_story/story/functions/videoPlayerEditor.dart';
import 'package:instagram_story/story/UI/user_story_bar.dart';

import 'package:instagram_story/story/bloc/story_bloc.dart';
import 'package:instagram_story/story/data/story_page_data.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

CarouselSliderController carouselController = CarouselSliderController();
Timer? timer;
int videoLength = 10;
bool videoPlaying = false;
late List<Widget> storyWidgets;
final StoryBloc storyBloc = StoryBloc();
bool screenBeingHold = false;

class StoryPage extends StatefulWidget {
  StoryPage({super.key});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  void initState() {
    super.initState();

    watchStory();
  }

  void dispose() {
    super.dispose();
    videoController.pause();
  }

  //Function that updates the story progress indicators fill
  void watchStory() {
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      if (!mounted) return;
      if (!screenBeingHold) {
        setState(() {
          if (userList[currentIndex]
                  .stories[userLeftOffIndex[currentIndex]]
                  .mediaType ==
              "Photo") {
            if (userList[currentIndex]
                        .stories[userLeftOffIndex[currentIndex]]
                        .percentWatched +
                    0.002 <
                1) {
              userList[currentIndex]
                  .stories[userLeftOffIndex[currentIndex]]
                  .percentWatched += 0.002;
            } else {
              timer.cancel();
              storyBloc.add(StoryTimeUpEvent());
              Future.delayed(Duration(milliseconds: 310), () {
                watchStory();
              });
            }
          } else {
            if (videoPlaying) {
              if (userList[currentIndex]
                          .stories[userLeftOffIndex[currentIndex]]
                          .percentWatched +
                      0.002 * 5 / videoController.value.duration.inSeconds <
                  1) {
                userList[currentIndex]
                        .stories[userLeftOffIndex[currentIndex]]
                        .percentWatched +=
                    0.002 *
                        5000 /
                        videoController.value.duration.inMilliseconds;
              } else {
                timer.cancel();
                storyBloc.add(StoryTimeUpEvent());
                Future.delayed(Duration(milliseconds: 350), () {
                  watchStory();
                });
              }
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //Widgets are being prepared in the following part for the carousel slider
    storyWidgets = List.generate(
        userList.length,
        (index) => Stack(
              children: [
                Container(
                  child: LayoutBuilder(builder: (context, constraints) {
                    //Checks if the story is video or photo
                    if (userList[index]
                            .stories[userLeftOffIndex[index]]
                            .mediaType ==
                        "Photo") {
                          //IF it is photo it is just added to the screen
                      return Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(userList[index]
                                    .stories[userLeftOffIndex[index]]
                                    .url),
                                fit: BoxFit.cover)),
                      );
                    } else {
                      return ValueListenableBuilder(
                        //If it is video videoController is added to the screen
                          valueListenable: videoFuture,
                          builder: (context, value, child) {
                            return Center(
                              child: AspectRatio(
                                  aspectRatio:
                                      videoController.value.aspectRatio,
                                  child: value == null
                                      ? const Scaffold()
                                      : FutureBuilder(
                                          future: value,
                                          builder: ((context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              return VideoPlayer(
                                                  videoController);
                                            } else {
                                              return Scaffold(
                                                backgroundColor: Colors.black,
                                                body: Center(
                                                    child: SpinKitCircle(
                                                  color: Colors.grey,
                                                )),
                                              );
                                            }
                                          }),
                                        )),
                            );
                          });
                    }
                  }),
                ),
                UserStoryBars(userStories: userList[index].stories),
              ],
            ));
    return BlocConsumer<StoryBloc, StoryState>(
      bloc: storyBloc,
      listenWhen: (previous, current) => current is StoryNavigationState,
      buildWhen: (previous, current) => current is! StoryNavigationState,
      listener: (context, state) {
        if (state is StoryPopState) {
          Navigator.pop(context);
          
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            GestureDetector(
              //Pauses the video and the timer when screen is hold
              onTapDown: (details) {
                screenBeingHold = true;
                if (videoController.value.isPlaying) videoController.pause();
              },
              //Resumes the video and the timer when screen is released
              onLongPressEnd: (details) {
                screenBeingHold = false;
                if (userList[currentIndex]
                        .stories[userLeftOffIndex[currentIndex]]
                        .mediaType ==
                    "Video") videoController.play();
              },
              //Pauses the video and the timer when screen is hold and if the screen is tapped it calls the story tapped event
              onTapUp: (details) {
                screenBeingHold = false;
                if (userList[currentIndex]
                        .stories[userLeftOffIndex[currentIndex]]
                        .mediaType ==
                    "Video") videoController.play();

                storyBloc.add(StoryTappedEvent(details, context));
              },
              child: CarouselSlider(
                slideTransform: CubeTransform(),
                children: storyWidgets,
                controller: carouselController,
                initialPage: userIndex,
                onSlideChanged: (int x) {
                  videoController.pause();
                  videoPlaying = false;
                  userList[currentIndex]
                      .stories[userLeftOffIndex[currentIndex]]
                      .percentWatched = 0;
                  currentIndex = x;
                  if (userList[currentIndex]
                          .stories[userLeftOffIndex[currentIndex]]
                          .mediaType ==
                      "Video") {
                    videoFuture.value = play(userList[currentIndex]
                        .stories[userLeftOffIndex[currentIndex]]
                        .url);
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
