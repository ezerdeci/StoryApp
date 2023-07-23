import 'package:flutter/material.dart';
import 'package:instagram_story/story/UI/progress_bar.dart';
import 'package:instagram_story/models/story_model.dart';

// ignore: must_be_immutable
class UserStoryBars extends StatelessWidget {
  List<StoryModel> userStories;

  UserStoryBars({required this.userStories});

  @override
  Widget build(BuildContext context) {
    List<Widget> storyProgressBarWidget = List.generate(
      userStories.length,
      (index) => Expanded(
          child: StoryProgressBar(
              percentWatched: userStories[index].percentWatched)),
    );
    return Container(
      padding: EdgeInsets.only(top: 30),
      child: Row(
        children: storyProgressBarWidget,
      ),
    );
  }
}
