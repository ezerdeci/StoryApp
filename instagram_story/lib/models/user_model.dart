import 'package:instagram_story/models/story_model.dart';

class User {
  final String name;
  final String profileUrl;
  final List<StoryModel> stories;
  final double watchedPercentage = 0;

  User(this.name, this.profileUrl, this.stories);
}
