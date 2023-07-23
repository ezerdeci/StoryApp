part of 'story_bloc.dart';

@immutable
abstract class StoryState {}

abstract class StoryNavigationState extends StoryState {}

class StoryInitial extends StoryState {}

class NextStoryState extends StoryState {}

class PreviousStoryState extends StoryState {}

class StoryPopState extends StoryNavigationState {}
