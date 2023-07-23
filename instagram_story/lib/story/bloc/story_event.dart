part of 'story_bloc.dart';

@immutable
abstract class StoryEvent {}

class StoryInitialEvent extends StoryEvent {}

class StoryTappedEvent extends StoryEvent {
  final TapUpDetails details;
  final BuildContext context;
  StoryTappedEvent(this.details, this.context);
}

class StoryTimeUpEvent extends StoryEvent {}

class StoriesOverEvent extends StoryEvent {}
